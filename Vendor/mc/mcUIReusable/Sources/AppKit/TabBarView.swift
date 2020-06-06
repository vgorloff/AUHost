//
//  TabBarView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 31.08.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import Foundation
import mcUI

// Info: https://www.raywenderlich.com/132268/advanced-collection-views-os-x-tutorial
public class TabBarView<T: Equatable, TabItem: TabBarTabViewItem<T>>: View, NSCollectionViewDataSource, NSCollectionViewDelegate {

   public enum Event {
      case select(item: T, at: Int)
      case leadingSupplementaryViewDidClicked
      case trailingSupplementaryViewDidClicked
   }

   public var eventHandler: ((Event) -> Void)?

   public var tabs: [T] = [] {
      didSet {
         collectionView.reloadData()
      }
   }

   public var tabBarHeight: CGFloat = 24 {
      didSet {
         invalidateIntrinsicContentSize()
      }
   }

   /// Default value: **140**
   public var minimumItemWidth: CGFloat = 140 {
      didSet {
         gridLayout.minimumItemSize = CGSize(width: minimumItemWidth, height: tabBarHeight)
         gridLayout.invalidateLayout()
      }
   }

   /// Default value: **200**
   public var maximumItemWidth: CGFloat = 200 {
      didSet {
         gridLayout.maximumItemSize = CGSize(width: maximumItemWidth, height: tabBarHeight)
         gridLayout.invalidateLayout()
      }
   }

   override public var backgroundColor: NSColor? {
      didSet {
         (collectionView.backgroundView as? View)?.backgroundColor = backgroundColor
      }
   }

   public var separatorColor: NSColor {
      get {
         return gridLayout.separatorColor
      } set {
         gridLayout.separatorColor = newValue
      }
   }

   public var leadingSupplementaryView: NSView? {
      didSet {
         oldValue?.removeFromSuperview()
         if let view = leadingSupplementaryView {
            view.addGestureRecognizer(leadingClickRecognizer)
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            anchor.pin.vertically(view).activate()
            view.leftAnchor.constraint(equalTo: leftAnchor).activate()
         }
         updateNavigation()
      }
   }

   public var trailingSupplementaryView: NSView? {
      didSet {
         oldValue?.removeFromSuperview()
         if let view = trailingSupplementaryView {
            view.addGestureRecognizer(trailingClickRecognizer)
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            anchor.pin.vertically(view).activate()
            view.rightAnchor.constraint(equalTo: rightAnchor).activate()
         }
         updateNavigation()
      }
   }

   // MARK: -

   private let cellID = NSUserInterfaceItemIdentifier(rawValue: "cid.tabView")
   private lazy var collectionView = TabBarCollectionView()
   private(set) lazy var scrollView: ScrollView = TabBarScrollView(document: collectionView)
   private let gridLayout = SeparatorCollectionViewGridLayout()
   private lazy var leadingClickRecognizer = NSClickGestureRecognizer()
   private lazy var trailingClickRecognizer = NSClickGestureRecognizer()
   private lazy var area = makeTrackingArea()
   private var isMouseOverTheView = false

   // MARK: -

   override public var intrinsicContentSize: NSSize {
      return CGSize(intrinsicHeight: tabBarHeight)
   }

   override public func mouseEntered(with event: NSEvent) {
      isMouseOverTheView = true
      updateNavigation()
   }

   override public func mouseExited(with event: NSEvent) {
      isMouseOverTheView = false
      updateNavigation()
   }

   override public func updateTrackingAreas() {
      removeTrackingArea(area)
      area = makeTrackingArea()
      addTrackingArea(area)
   }

   // MARK: -

   override public func setupHandlers() {
      collectionView.delegate = self
      collectionView.dataSource = self
      collectionView.register(TabItem.self, forItemWithIdentifier: cellID)

      leadingClickRecognizer.setHandler(self) {
         $0.scrollToPreviousItem()
         $0.eventHandler?(.leadingSupplementaryViewDidClicked)
      }

      trailingClickRecognizer.setHandler(self) {
         $0.scrollToNextItem()
         $0.eventHandler?(.trailingSupplementaryViewDidClicked)
      }
   }

   override public func setupUI() {
      addSubviews(scrollView)

      wantsLayer = true

      gridLayout.maximumNumberOfRows = 1
      gridLayout.minimumItemSize = CGSize(width: minimumItemWidth, height: tabBarHeight)
      gridLayout.maximumItemSize = CGSize(width: maximumItemWidth, height: tabBarHeight)
      collectionView.collectionViewLayout = gridLayout
   }

   override public func setupLayout() {
      anchor.withFormat("|[*]|", scrollView).activate()
      anchor.withFormat("V:|[*]|", scrollView).activate()
   }

   override public func setupDefaults() {
      updateNavigation()
   }

   // MARK: - DataSource

   public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
      return tabs.count
   }

   public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
      let tabItem = tabs[indexPath.item]
      let cell = collectionView.makeItem(withIdentifier: cellID, for: indexPath)
      if let cell = cell as? TabItem {
         cell.configure(value: tabItem)
      }
      return cell
   }

   // MARK: - Delegate

   public func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
      if let first = indexPaths.first {
         if let cell = collectionView.item(at: first) {
            let diffOfMaxX = collectionView.visibleRect.maxX - cell.view.frame.maxX
            let diffOfMinX = cell.view.frame.minX - collectionView.visibleRect.minX
            if diffOfMinX < 0 {
               NSAnimationContext.implicit.run {
                  collectionView.animator().scrollToItems(at: Set([first]), scrollPosition: .leadingEdge)
               }
            } else if diffOfMaxX < 0 {
               NSAnimationContext.implicit.run {
                  collectionView.animator().scrollToItems(at: Set([first]), scrollPosition: .trailingEdge)
               }
            }
         }
         let item = tabs[first.item]
         eventHandler?(.select(item: item, at: first.item))
      }
   }

   // MARK: - Private

   private func makeTrackingArea() -> NSTrackingArea {
      return NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeInKeyWindow], owner: self, userInfo: nil)
   }

   private func updateNavigation() {
      if isMouseOverTheView, shouldShowSuplementaryViews() {
         leadingSupplementaryView?.isVisible = true
         trailingSupplementaryView?.isVisible = true
      } else {
         leadingSupplementaryView?.isVisible = false
         trailingSupplementaryView?.isVisible = false
      }
   }

   private func shouldShowSuplementaryViews() -> Bool {
      if tabs.isEmpty {
         return false
      }
      guard let firstCell = collectionView.item(at: IndexPath(item: 0, section: 0)) else {
         return true
      }
      guard let lastCell = collectionView.item(at: IndexPath(item: tabs.count - 1, section: 0)) else {
         return true
      }
      let rect = collectionView.visibleRect
      let shouldHideSuplementaryViews = rect.contains(firstCell.view.frame) && rect.contains(lastCell.view.frame)
      return !shouldHideSuplementaryViews
   }

   private func scrollToPreviousItem() {
      guard let cell = collectionView.items.visible.first, let indexPath = collectionView.indexPath(for: cell) else {
         return
      }
      let previousIndexPath = indexPath.previous.byItem
      let diffOfMinX = cell.view.frame.minX - collectionView.visibleRect.minX
      if diffOfMinX < 0 {
         NSAnimationContext.implicit.run {
            collectionView.animator().scrollToItems(at: Set([indexPath]), scrollPosition: .leadingEdge)
         }
      } else if previousIndexPath.item >= 0 {
         NSAnimationContext.implicit.run {
            collectionView.animator().scrollToItems(at: Set([previousIndexPath]), scrollPosition: .leadingEdge)
         }
      }
   }

   private func scrollToNextItem() {
      guard let cell = collectionView.items.visible.last, let indexPath = collectionView.indexPath(for: cell) else {
         return
      }
      let nextIndexPath = indexPath.next.byItem
      let diffOfMaxX = collectionView.visibleRect.maxX - cell.view.frame.maxX
      if diffOfMaxX < 0 {
         NSAnimationContext.implicit.run {
            collectionView.animator().scrollToItems(at: Set([indexPath]), scrollPosition: .trailingEdge)
         }
      } else if nextIndexPath.item < tabs.count {
         NSAnimationContext.implicit.run {
            collectionView.animator().scrollToItems(at: Set([nextIndexPath]), scrollPosition: .trailingEdge)
         }
      }
   }
}

extension TabBarView {

   public func select(at index: Int) {
      if tabs.indices.contains(index) {
         let ip = IndexPath(item: index, section: 0)
         NSAnimationContext.implicit.run {
            collectionView.selectionIndexPaths = [ip]
            collectionView.scrollToItems(at: [ip], scrollPosition: .centeredHorizontally)
         }
      }
   }

   public func select(item: T) {
      if let index = tabs.firstIndex(of: item) {
         select(at: index)
      }
   }
}

private class TabBarCollectionView: CollectionView {

   override func setupUI() {
      isSelectable = true
      allowsMultipleSelection = false
      allowsEmptySelection = false
      backgroundView = View(backgroundColor: .magenta).autoresizingView()
      backgroundColors = [.clear]
   }
}

private class TabBarScrollView: ScrollView {

   override func setupUI() {
      borderType = .noBorder
      backgroundColor = .clear
      drawsBackground = false

      horizontalScrollElasticity = .none
      verticalScrollElasticity = .none

      automaticallyAdjustsContentInsets = false
      horizontalScroller = InvisibleScroller()
   }
}

private class SeparatorCollectionViewGridLayout: NSCollectionViewGridLayout {

   private let separatorID = "com.mc.tabBar.separator"
   private var numberOfSeparators = 0
   private var separatorAttributes: [ColoredCollectionViewLayoutAttributes] = []

   var separatorWidth: CGFloat = 1 {
      didSet {
         invalidateLayout()
      }
   }

   var separatorColor: NSColor = .black {
      didSet {
         invalidateLayout()
      }
   }

   override init() {
      super.init()
      register(SeparatorView.self, forDecorationViewOfKind: separatorID)
   }

   required init?(coder aDecoder: NSCoder) {
      fatalError()
   }

   override func prepare() {
      super.prepare()
      guard let collectionView = collectionView, collectionView.numberOfSections > 0 else {
         numberOfSeparators = 0
         return
      }
      numberOfSeparators = collectionView.numberOfItems(inSection: 0) - 1
   }

   override func invalidateLayout() {
      super.invalidateLayout()
   }

   override var collectionViewContentSize: NSSize {
      let size = super.collectionViewContentSize
      let result = CGSize(width: size.width + CGFloat(numberOfSeparators) * separatorWidth, height: size.height)
      return result
   }

   override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
      let attributes = super.layoutAttributesForElements(in: rect)
      separatorAttributes.removeAll()
      for (index, attribute) in attributes.enumerated() {
         if index > 0 {
            attribute.frame = attribute.frame.offsetBy(dx: CGFloat(index) * separatorWidth, dy: 0)
            if let ip = attribute.indexPath {
               let separatorAttribute = ColoredCollectionViewLayoutAttributes(forDecorationViewOfKind: separatorID, with: ip)
               separatorAttribute.color = separatorColor
               separatorAttribute.frame = CGRect(origin: attribute.frame.origin.offsetBy(dx: -separatorWidth, dy: 0),
                                                 size: CGSize(width: separatorWidth, height: attribute.frame.height))
               separatorAttributes.append(separatorAttribute)
            }
         }
      }
      return attributes + separatorAttributes
   }

   override func layoutAttributesForDecorationView(ofKind elementKind: NSCollectionView.DecorationElementKind,
                                                   at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
      let attribute = separatorAttributes.first(where: { $0.indexPath == indexPath })
      return attribute
   }
}

private class ColoredCollectionViewLayoutAttributes: NSCollectionViewLayoutAttributes {
   var color = NSColor.clear
}

private class SeparatorView: NSView, NSCollectionViewElement {

   private var backgroundColor: NSColor?

   override func prepareForReuse() {
      super.prepareForReuse()
   }

   func apply(_ layoutAttributes: NSCollectionViewLayoutAttributes) {
      backgroundColor = (layoutAttributes as? ColoredCollectionViewLayoutAttributes)?.color
   }

   override open func draw(_ dirtyRect: NSRect) {
      if let backgroundColor = backgroundColor {
         backgroundColor.setFill()
         dirtyRect.fill()
      } else {
         super.draw(dirtyRect)
      }
   }
}
#endif
