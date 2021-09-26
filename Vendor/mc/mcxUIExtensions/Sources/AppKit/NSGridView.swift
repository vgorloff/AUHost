#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSGridView {

   public func mergeCellsInRow(_ row: Int) {
      mergeCells(inHorizontalRange: NSRange(location: 0, length: numberOfColumns), verticalRange: NSRange(location: row, length: 1))
   }
}

#endif
