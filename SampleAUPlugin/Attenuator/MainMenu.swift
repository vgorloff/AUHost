//
//  MainMenu.swift
//  Attenuator
//
//  Created by Vlad Gorlov on 12.08.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import AppKit

class MainMenu: NSMenu {

   lazy var menuServices = NSMenu(title: "Services")
   lazy var menuAttenuatorItem01AboutAttenuator = NSMenuItem(title: "About Attenuator", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
   lazy var menuAttenuatorItem02Separator = NSMenuItem.separator()
   lazy var menuAttenuatorItem03Preferences = NSMenuItem(title: "Preferences…", action: nil, keyEquivalent: ",")
   lazy var menuAttenuatorItem04Separator = NSMenuItem.separator()
   lazy var menuAttenuatorItem05Services = NSMenuItem(title: "Services", action: nil, keyEquivalent: "")
   lazy var menuAttenuatorItem06Separator = NSMenuItem.separator()
   lazy var menuAttenuatorItem07HideAttenuator = NSMenuItem(title: "Hide Attenuator", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
   lazy var menuAttenuatorItem08HideOthers = NSMenuItem(title: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
   lazy var menuAttenuatorItem09ShowAll = NSMenuItem(title: "Show All", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
   lazy var menuAttenuatorItem10Separator = NSMenuItem.separator()
   lazy var menuAttenuatorItem11QuitAttenuator = NSMenuItem(title: "Quit Attenuator", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
   lazy var menuAttenuator = NSMenu(title: "Attenuator")
   lazy var menuOpenRecentItemClearMenu = NSMenuItem(title: "Clear Menu", action: #selector(NSDocumentController.clearRecentDocuments(_:)), keyEquivalent: "")
   lazy var menuOpenRecent = NSMenu(title: "Open Recent")
   lazy var menuFileItem01New = NSMenuItem(title: "New", action: #selector(NSDocumentController.newDocument(_:)), keyEquivalent: "n")
   lazy var menuFileItem02Open = NSMenuItem(title: "Open…", action: #selector(NSDocumentController.openDocument(_:)), keyEquivalent: "o")
   lazy var menuFileItem03OpenRecent = NSMenuItem(title: "Open Recent", action: nil, keyEquivalent: "")
   lazy var menuFileItem04Separator = NSMenuItem.separator()
   lazy var menuFileItem05Close = NSMenuItem(title: "Close", action: #selector(NSPopover.performClose(_:)), keyEquivalent: "w")
   lazy var menuFileItem06Save = NSMenuItem(title: "Save…", action: #selector(NSDocument.save(_:)), keyEquivalent: "s")
   lazy var menuFileItem07SaveAs = NSMenuItem(title: "Save As…", action: #selector(NSDocument.saveAs(_:)), keyEquivalent: "S")
   lazy var menuFileItem08RevertToSaved = NSMenuItem(title: "Revert to Saved", action: #selector(NSDocument.revertToSaved(_:)), keyEquivalent: "")
   lazy var menuFileItem09Separator = NSMenuItem.separator()
   lazy var menuFileItem10PageSetup = NSMenuItem(title: "Page Setup…", action: #selector(NSDocument.runPageLayout(_:)), keyEquivalent: "P")
   lazy var menuFileItem11Print = NSMenuItem(title: "Print…", action: #selector(NSView.printView(_:)), keyEquivalent: "p")
   lazy var menuFile = NSMenu(title: "File")
   lazy var menuFindItemFind = NSMenuItem(title: "Find…", action: #selector(NSTextView.performFindPanelAction(_:)), keyEquivalent: "f")
   lazy var menuFindItemFindAndReplace = NSMenuItem(title: "Find and Replace…", action: #selector(NSTextView.performFindPanelAction(_:)), keyEquivalent: "f")
   lazy var menuFindItemFindNext = NSMenuItem(title: "Find Next", action: #selector(NSTextView.performFindPanelAction(_:)), keyEquivalent: "g")
   lazy var menuFindItemFindPrevious = NSMenuItem(title: "Find Previous", action: #selector(NSTextView.performFindPanelAction(_:)), keyEquivalent: "G")
   lazy var menuFindItemUseSelectionForFind = NSMenuItem(title: "Use Selection for Find", action: #selector(NSTextView.performFindPanelAction(_:)), keyEquivalent: "e")
   lazy var menuFindItemJumpToSelection = NSMenuItem(title: "Jump to Selection", action: #selector(NSResponder.centerSelectionInVisibleArea(_:)), keyEquivalent: "j")
   lazy var menuFind = NSMenu(title: "Find")
   lazy var menuSpellingItemShowSpellingAndGrammar = NSMenuItem(title: "Show Spelling and Grammar", action: #selector(NSText.showGuessPanel(_:)), keyEquivalent: ":")
   lazy var menuSpellingItemCheckDocumentNow = NSMenuItem(title: "Check Document Now", action: #selector(NSText.checkSpelling(_:)), keyEquivalent: ";")
   lazy var menuSpellingItemSeparator = NSMenuItem.separator()
   lazy var menuSpellingItemCheckSpellingWhileTyping = NSMenuItem(title: "Check Spelling While Typing", action: #selector(NSTextView.toggleContinuousSpellChecking(_:)), keyEquivalent: "")
   lazy var menuSpellingItemCheckGrammarWithSpelling = NSMenuItem(title: "Check Grammar With Spelling", action: #selector(NSTextView.toggleGrammarChecking(_:)), keyEquivalent: "")
   lazy var menuSpellingItemCorrectSpellingAutomatically = NSMenuItem(title: "Correct Spelling Automatically", action: #selector(NSTextView.toggleAutomaticSpellingCorrection(_:)), keyEquivalent: "")
   lazy var menuSpelling = NSMenu(title: "Spelling")
   lazy var menuSubstitutionsItemShowSubstitutions = NSMenuItem(title: "Show Substitutions", action: #selector(NSTextView.orderFrontSubstitutionsPanel(_:)), keyEquivalent: "")
   lazy var menuSubstitutionsItemSeparator = NSMenuItem.separator()
   lazy var menuSubstitutionsItemSmartCopyPaste = NSMenuItem(title: "Smart Copy/Paste", action: #selector(NSTextView.toggleSmartInsertDelete(_:)), keyEquivalent: "")
   lazy var menuSubstitutionsItemSmartQuotes = NSMenuItem(title: "Smart Quotes", action: #selector(NSTextView.toggleAutomaticQuoteSubstitution(_:)), keyEquivalent: "")
   lazy var menuSubstitutionsItemSmartDashes = NSMenuItem(title: "Smart Dashes", action: #selector(NSTextView.toggleAutomaticDashSubstitution(_:)), keyEquivalent: "")
   lazy var menuSubstitutionsItemSmartLinks = NSMenuItem(title: "Smart Links", action: #selector(NSTextView.toggleAutomaticLinkDetection(_:)), keyEquivalent: "")
   lazy var menuSubstitutionsItemDataDetectors = NSMenuItem(title: "Data Detectors", action: #selector(NSTextView.toggleAutomaticDataDetection(_:)), keyEquivalent: "")
   lazy var menuSubstitutionsItemTextReplacement = NSMenuItem(title: "Text Replacement", action: #selector(NSTextView.toggleAutomaticTextReplacement(_:)), keyEquivalent: "")
   lazy var menuSubstitutions = NSMenu(title: "Substitutions")
   lazy var menuTransformationsItemMakeUpperCase = NSMenuItem(title: "Make Upper Case", action: #selector(NSResponder.uppercaseWord(_:)), keyEquivalent: "")
   lazy var menuTransformationsItemMakeLowerCase = NSMenuItem(title: "Make Lower Case", action: #selector(NSResponder.lowercaseWord(_:)), keyEquivalent: "")
   lazy var menuTransformationsItemCapitalize = NSMenuItem(title: "Capitalize", action: #selector(NSResponder.capitalizeWord(_:)), keyEquivalent: "")
   lazy var menuTransformations = NSMenu(title: "Transformations")
   lazy var menuSpeechItemStartSpeaking = NSMenuItem(title: "Start Speaking", action: #selector(NSTextView.startSpeaking(_:)), keyEquivalent: "")
   lazy var menuSpeechItemStopSpeaking = NSMenuItem(title: "Stop Speaking", action: #selector(NSTextView.stopSpeaking(_:)), keyEquivalent: "")
   lazy var menuSpeech = NSMenu(title: "Speech")
   lazy var menuEditItem01Undo = NSMenuItem(title: "Undo", action: Selector(("undo:")), keyEquivalent: "z")
   lazy var menuEditItem02Redo = NSMenuItem(title: "Redo", action: Selector(("redo:")), keyEquivalent: "Z")
   lazy var menuEditItem03Separator = NSMenuItem.separator()
   lazy var menuEditItem04Cut = NSMenuItem(title: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
   lazy var menuEditItem05Copy = NSMenuItem(title: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
   lazy var menuEditItem06Paste = NSMenuItem(title: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
   lazy var menuEditItem07PasteAndMatchStyle = NSMenuItem(title: "Paste and Match Style", action: #selector(NSTextView.pasteAsPlainText(_:)), keyEquivalent: "V")
   lazy var menuEditItem08Delete = NSMenuItem(title: "Delete", action: #selector(NSText.delete(_:)), keyEquivalent: "")
   lazy var menuEditItem09SelectAll = NSMenuItem(title: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
   lazy var menuEditItem10Separator = NSMenuItem.separator()
   lazy var menuEditItem11Find = NSMenuItem(title: "Find", action: nil, keyEquivalent: "")
   lazy var menuEditItem12SpellingAndGrammar = NSMenuItem(title: "Spelling and Grammar", action: nil, keyEquivalent: "")
   lazy var menuEditItem13Substitutions = NSMenuItem(title: "Substitutions", action: nil, keyEquivalent: "")
   lazy var menuEditItem14Transformations = NSMenuItem(title: "Transformations", action: nil, keyEquivalent: "")
   lazy var menuEditItem15Speech = NSMenuItem(title: "Speech", action: nil, keyEquivalent: "")
   lazy var menuEdit = NSMenu(title: "Edit")
   lazy var menuKernItemUseDefault = NSMenuItem(title: "Use Default", action: #selector(NSTextView.useStandardKerning(_:)), keyEquivalent: "")
   lazy var menuKernItemUseNone = NSMenuItem(title: "Use None", action: #selector(NSTextView.turnOffKerning(_:)), keyEquivalent: "")
   lazy var menuKernItemTighten = NSMenuItem(title: "Tighten", action: #selector(NSTextView.tightenKerning(_:)), keyEquivalent: "")
   lazy var menuKernItemLoosen = NSMenuItem(title: "Loosen", action: #selector(NSTextView.loosenKerning(_:)), keyEquivalent: "")
   lazy var menuKern = NSMenu(title: "Kern")
   lazy var menuLigaturesItemUseDefault = NSMenuItem(title: "Use Default", action: #selector(NSTextView.useStandardLigatures(_:)), keyEquivalent: "")
   lazy var menuLigaturesItemUseNone = NSMenuItem(title: "Use None", action: #selector(NSTextView.turnOffLigatures(_:)), keyEquivalent: "")
   lazy var menuLigaturesItemUseAll = NSMenuItem(title: "Use All", action: #selector(NSTextView.useAllLigatures(_:)), keyEquivalent: "")
   lazy var menuLigatures = NSMenu(title: "Ligatures")
   lazy var menuBaselineItemUseDefault = NSMenuItem(title: "Use Default", action: #selector(NSText.unscript(_:)), keyEquivalent: "")
   lazy var menuBaselineItemSuperscript = NSMenuItem(title: "Superscript", action: #selector(NSText.superscript(_:)), keyEquivalent: "")
   lazy var menuBaselineItemSubscript = NSMenuItem(title: "Subscript", action: #selector(NSText.subscript(_:)), keyEquivalent: "")
   lazy var menuBaselineItemRaise = NSMenuItem(title: "Raise", action: #selector(NSTextView.raiseBaseline(_:)), keyEquivalent: "")
   lazy var menuBaselineItemLower = NSMenuItem(title: "Lower", action: #selector(NSTextView.lowerBaseline(_:)), keyEquivalent: "")
   lazy var menuBaseline = NSMenu(title: "Baseline")
   lazy var menuFontItem01ShowFonts = NSMenuItem(title: "Show Fonts", action: nil, keyEquivalent: "t")
   lazy var menuFontItem02Bold = NSMenuItem(title: "Bold", action: nil, keyEquivalent: "b")
   lazy var menuFontItem03Italic = NSMenuItem(title: "Italic", action: nil, keyEquivalent: "i")
   lazy var menuFontItem04Underline = NSMenuItem(title: "Underline", action: #selector(NSText.underline(_:)), keyEquivalent: "u")
   lazy var menuFontItem05Separator = NSMenuItem.separator()
   lazy var menuFontItem06Bigger = NSMenuItem(title: "Bigger", action: nil, keyEquivalent: "+")
   lazy var menuFontItem07Smaller = NSMenuItem(title: "Smaller", action: nil, keyEquivalent: "-")
   lazy var menuFontItem08Separator = NSMenuItem.separator()
   lazy var menuFontItem09Kern = NSMenuItem(title: "Kern", action: nil, keyEquivalent: "")
   lazy var menuFontItem10Ligatures = NSMenuItem(title: "Ligatures", action: nil, keyEquivalent: "")
   lazy var menuFontItem11Baseline = NSMenuItem(title: "Baseline", action: nil, keyEquivalent: "")
   lazy var menuFontItem12Separator = NSMenuItem.separator()
   lazy var menuFontItem13ShowColors = NSMenuItem(title: "Show Colors", action: #selector(NSApplication.orderFrontColorPanel(_:)), keyEquivalent: "C")
   lazy var menuFontItem14Separator = NSMenuItem.separator()
   lazy var menuFontItem15CopyStyle = NSMenuItem(title: "Copy Style", action: #selector(NSText.copyFont(_:)), keyEquivalent: "c")
   lazy var menuFontItem16PasteStyle = NSMenuItem(title: "Paste Style", action: #selector(NSText.pasteFont(_:)), keyEquivalent: "v")
   lazy var menuFont = NSMenu(title: "Font")
   lazy var menuWritingDirectionItem01Paragraph = NSMenuItem(title: "Paragraph", action: nil, keyEquivalent: "")
   lazy var menuWritingDirectionItem02Default = NSMenuItem(title: "\tDefault", action: #selector(NSResponder.makeBaseWritingDirectionNatural(_:)), keyEquivalent: "")
   lazy var menuWritingDirectionItem03LeftToRight = NSMenuItem(title: "\tLeft to Right", action: #selector(NSResponder.makeBaseWritingDirectionLeftToRight(_:)), keyEquivalent: "")
   lazy var menuWritingDirectionItem04RightToLeft = NSMenuItem(title: "\tRight to Left", action: #selector(NSResponder.makeBaseWritingDirectionRightToLeft(_:)), keyEquivalent: "")
   lazy var menuWritingDirectionItem05Separator = NSMenuItem.separator()
   lazy var menuWritingDirectionItem06Selection = NSMenuItem(title: "Selection", action: nil, keyEquivalent: "")
   lazy var menuWritingDirectionItem07Default = NSMenuItem(title: "\tDefault", action: #selector(NSResponder.makeTextWritingDirectionNatural(_:)), keyEquivalent: "")
   lazy var menuWritingDirectionItem08LeftToRight = NSMenuItem(title: "\tLeft to Right", action: #selector(NSResponder.makeTextWritingDirectionLeftToRight(_:)), keyEquivalent: "")
   lazy var menuWritingDirectionItem09RightToLeft = NSMenuItem(title: "\tRight to Left", action: #selector(NSResponder.makeTextWritingDirectionRightToLeft(_:)), keyEquivalent: "")
   lazy var menuWritingDirection = NSMenu(title: "Writing Direction")
   lazy var menuTextItem01AlignLeft = NSMenuItem(title: "Align Left", action: #selector(NSText.alignLeft(_:)), keyEquivalent: "{")
   lazy var menuTextItem02Center = NSMenuItem(title: "Center", action: #selector(NSText.alignCenter(_:)), keyEquivalent: "|")
   lazy var menuTextItem03Justify = NSMenuItem(title: "Justify", action: #selector(NSTextView.alignJustified(_:)), keyEquivalent: "")
   lazy var menuTextItem04AlignRight = NSMenuItem(title: "Align Right", action: #selector(NSText.alignRight(_:)), keyEquivalent: "}")
   lazy var menuTextItem05Separator = NSMenuItem.separator()
   lazy var menuTextItem06WritingDirection = NSMenuItem(title: "Writing Direction", action: nil, keyEquivalent: "")
   lazy var menuTextItem07Separator = NSMenuItem.separator()
   lazy var menuTextItem08ShowRuler = NSMenuItem(title: "Show Ruler", action: #selector(NSText.toggleRuler(_:)), keyEquivalent: "")
   lazy var menuTextItem09CopyRuler = NSMenuItem(title: "Copy Ruler", action: #selector(NSText.copyRuler(_:)), keyEquivalent: "c")
   lazy var menuTextItem10PasteRuler = NSMenuItem(title: "Paste Ruler", action: #selector(NSText.pasteRuler(_:)), keyEquivalent: "v")
   lazy var menuText = NSMenu(title: "Text")
   lazy var menuFormatItemFont = NSMenuItem(title: "Font", action: nil, keyEquivalent: "")
   lazy var menuFormatItemText = NSMenuItem(title: "Text", action: nil, keyEquivalent: "")
   lazy var menuFormat = NSMenu(title: "Format")
   lazy var menuView = NSMenu(title: "View")
   lazy var menuWindowItemMinimize = NSMenuItem(title: "Minimize", action: #selector(NSWindow.performMiniaturize(_:)), keyEquivalent: "m")
   lazy var menuWindowItemZoom = NSMenuItem(title: "Zoom", action: #selector(NSWindow.performZoom(_:)), keyEquivalent: "")
   lazy var menuWindowItemSeparator = NSMenuItem.separator()
   lazy var menuWindowItemBringAllToFront = NSMenuItem(title: "Bring All to Front", action: #selector(NSApplication.arrangeInFront(_:)), keyEquivalent: "")
   lazy var menuWindow = NSMenu(title: "Window")
   lazy var menuHelpItemAttenuatorHelp = NSMenuItem(title: "Attenuator Help", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "?")
   lazy var menuHelp = NSMenu(title: "Help")
   lazy var menuMainMenuItemAttenuator = NSMenuItem(title: "Attenuator", action: nil, keyEquivalent: "")
   lazy var menuMainMenuItemFile = NSMenuItem(title: "File", action: nil, keyEquivalent: "")
   lazy var menuMainMenuItemEdit = NSMenuItem(title: "Edit", action: nil, keyEquivalent: "")
   lazy var menuMainMenuItemFormat = NSMenuItem(title: "Format", action: nil, keyEquivalent: "")
   lazy var menuMainMenuItemView = NSMenuItem(title: "View", action: nil, keyEquivalent: "")
   lazy var menuMainMenuItemWindow = NSMenuItem(title: "Window", action: nil, keyEquivalent: "")
   lazy var menuMainMenuItemHelp = NSMenuItem(title: "Help", action: nil, keyEquivalent: "")

   init() {
      super.init(title: "Main Menu")
      setupUI()
   }

   required init(coder decoder: NSCoder) {
      fatalError()
   }

   private func setupUI() {

      addItem(menuMainMenuItemAttenuator)
      addItem(menuMainMenuItemFile)
      addItem(menuMainMenuItemEdit)
      addItem(menuMainMenuItemFormat)
      addItem(menuMainMenuItemView)
      addItem(menuMainMenuItemWindow)
      addItem(menuMainMenuItemHelp)

      menuMainMenuItemHelp.submenu = menuHelp

      menuHelp.addItem(menuHelpItemAttenuatorHelp)

      menuMainMenuItemWindow.submenu = menuWindow

      menuWindow.addItem(menuWindowItemMinimize)
      menuWindow.addItem(menuWindowItemZoom)
      menuWindow.addItem(menuWindowItemSeparator)
      menuWindow.addItem(menuWindowItemBringAllToFront)

      menuMainMenuItemView.submenu = menuView

      menuMainMenuItemFormat.submenu = menuFormat

      menuFormat.addItem(menuFormatItemFont)
      menuFormat.addItem(menuFormatItemText)

      menuFormatItemText.submenu = menuText

      menuText.addItem(menuTextItem01AlignLeft)
      menuText.addItem(menuTextItem02Center)
      menuText.addItem(menuTextItem03Justify)
      menuText.addItem(menuTextItem04AlignRight)
      menuText.addItem(menuTextItem05Separator)
      menuText.addItem(menuTextItem06WritingDirection)
      menuText.addItem(menuTextItem07Separator)
      menuText.addItem(menuTextItem08ShowRuler)
      menuText.addItem(menuTextItem09CopyRuler)
      menuText.addItem(menuTextItem10PasteRuler)

      menuTextItem10PasteRuler.keyEquivalentModifierMask = [.command, .control]

      menuTextItem09CopyRuler.keyEquivalentModifierMask = [.command, .control]

      menuTextItem06WritingDirection.submenu = menuWritingDirection

      menuWritingDirection.addItem(menuWritingDirectionItem01Paragraph)
      menuWritingDirection.addItem(menuWritingDirectionItem02Default)
      menuWritingDirection.addItem(menuWritingDirectionItem03LeftToRight)
      menuWritingDirection.addItem(menuWritingDirectionItem04RightToLeft)
      menuWritingDirection.addItem(menuWritingDirectionItem05Separator)
      menuWritingDirection.addItem(menuWritingDirectionItem06Selection)
      menuWritingDirection.addItem(menuWritingDirectionItem07Default)
      menuWritingDirection.addItem(menuWritingDirectionItem08LeftToRight)
      menuWritingDirection.addItem(menuWritingDirectionItem09RightToLeft)

      menuWritingDirectionItem06Selection.isEnabled = false

      menuWritingDirectionItem01Paragraph.isEnabled = false

      menuFormatItemFont.submenu = menuFont

      menuFont.addItem(menuFontItem01ShowFonts)
      menuFont.addItem(menuFontItem02Bold)
      menuFont.addItem(menuFontItem03Italic)
      menuFont.addItem(menuFontItem04Underline)
      menuFont.addItem(menuFontItem05Separator)
      menuFont.addItem(menuFontItem06Bigger)
      menuFont.addItem(menuFontItem07Smaller)
      menuFont.addItem(menuFontItem08Separator)
      menuFont.addItem(menuFontItem09Kern)
      menuFont.addItem(menuFontItem10Ligatures)
      menuFont.addItem(menuFontItem11Baseline)
      menuFont.addItem(menuFontItem12Separator)
      menuFont.addItem(menuFontItem13ShowColors)
      menuFont.addItem(menuFontItem14Separator)
      menuFont.addItem(menuFontItem15CopyStyle)
      menuFont.addItem(menuFontItem16PasteStyle)

      menuFontItem16PasteStyle.keyEquivalentModifierMask = [.option, .command]

      menuFontItem15CopyStyle.keyEquivalentModifierMask = [.option, .command]

      menuFontItem11Baseline.submenu = menuBaseline

      menuBaseline.addItem(menuBaselineItemUseDefault)
      menuBaseline.addItem(menuBaselineItemSuperscript)
      menuBaseline.addItem(menuBaselineItemSubscript)
      menuBaseline.addItem(menuBaselineItemRaise)
      menuBaseline.addItem(menuBaselineItemLower)

      menuFontItem10Ligatures.submenu = menuLigatures

      menuLigatures.addItem(menuLigaturesItemUseDefault)
      menuLigatures.addItem(menuLigaturesItemUseNone)
      menuLigatures.addItem(menuLigaturesItemUseAll)

      menuFontItem09Kern.submenu = menuKern

      menuKern.addItem(menuKernItemUseDefault)
      menuKern.addItem(menuKernItemUseNone)
      menuKern.addItem(menuKernItemTighten)
      menuKern.addItem(menuKernItemLoosen)

      menuFontItem07Smaller.tag = 4

      menuFontItem06Bigger.tag = 3

      menuFontItem03Italic.tag = 1

      menuFontItem02Bold.tag = 2

      menuMainMenuItemEdit.submenu = menuEdit

      menuEdit.addItem(menuEditItem01Undo)
      menuEdit.addItem(menuEditItem02Redo)
      menuEdit.addItem(menuEditItem03Separator)
      menuEdit.addItem(menuEditItem04Cut)
      menuEdit.addItem(menuEditItem05Copy)
      menuEdit.addItem(menuEditItem06Paste)
      menuEdit.addItem(menuEditItem07PasteAndMatchStyle)
      menuEdit.addItem(menuEditItem08Delete)
      menuEdit.addItem(menuEditItem09SelectAll)
      menuEdit.addItem(menuEditItem10Separator)
      menuEdit.addItem(menuEditItem11Find)
      menuEdit.addItem(menuEditItem12SpellingAndGrammar)
      menuEdit.addItem(menuEditItem13Substitutions)
      menuEdit.addItem(menuEditItem14Transformations)
      menuEdit.addItem(menuEditItem15Speech)

      menuEditItem15Speech.submenu = menuSpeech

      menuSpeech.addItem(menuSpeechItemStartSpeaking)
      menuSpeech.addItem(menuSpeechItemStopSpeaking)

      menuEditItem14Transformations.submenu = menuTransformations

      menuTransformations.addItem(menuTransformationsItemMakeUpperCase)
      menuTransformations.addItem(menuTransformationsItemMakeLowerCase)
      menuTransformations.addItem(menuTransformationsItemCapitalize)

      menuEditItem13Substitutions.submenu = menuSubstitutions

      menuSubstitutions.addItem(menuSubstitutionsItemShowSubstitutions)
      menuSubstitutions.addItem(menuSubstitutionsItemSeparator)
      menuSubstitutions.addItem(menuSubstitutionsItemSmartCopyPaste)
      menuSubstitutions.addItem(menuSubstitutionsItemSmartQuotes)
      menuSubstitutions.addItem(menuSubstitutionsItemSmartDashes)
      menuSubstitutions.addItem(menuSubstitutionsItemSmartLinks)
      menuSubstitutions.addItem(menuSubstitutionsItemDataDetectors)
      menuSubstitutions.addItem(menuSubstitutionsItemTextReplacement)

      menuEditItem12SpellingAndGrammar.submenu = menuSpelling

      menuSpelling.addItem(menuSpellingItemShowSpellingAndGrammar)
      menuSpelling.addItem(menuSpellingItemCheckDocumentNow)
      menuSpelling.addItem(menuSpellingItemSeparator)
      menuSpelling.addItem(menuSpellingItemCheckSpellingWhileTyping)
      menuSpelling.addItem(menuSpellingItemCheckGrammarWithSpelling)
      menuSpelling.addItem(menuSpellingItemCorrectSpellingAutomatically)

      menuEditItem11Find.submenu = menuFind

      menuFind.addItem(menuFindItemFind)
      menuFind.addItem(menuFindItemFindAndReplace)
      menuFind.addItem(menuFindItemFindNext)
      menuFind.addItem(menuFindItemFindPrevious)
      menuFind.addItem(menuFindItemUseSelectionForFind)
      menuFind.addItem(menuFindItemJumpToSelection)

      menuFindItemUseSelectionForFind.tag = 7

      menuFindItemFindPrevious.tag = 3

      menuFindItemFindNext.tag = 2

      menuFindItemFindAndReplace.keyEquivalentModifierMask = [.option, .command]
      menuFindItemFindAndReplace.tag = 12

      menuFindItemFind.tag = 1

      menuEditItem07PasteAndMatchStyle.keyEquivalentModifierMask = [.option, .command]

      menuMainMenuItemFile.submenu = menuFile

      menuFile.addItem(menuFileItem01New)
      menuFile.addItem(menuFileItem02Open)
      menuFile.addItem(menuFileItem03OpenRecent)
      menuFile.addItem(menuFileItem04Separator)
      menuFile.addItem(menuFileItem05Close)
      menuFile.addItem(menuFileItem06Save)
      menuFile.addItem(menuFileItem07SaveAs)
      menuFile.addItem(menuFileItem08RevertToSaved)
      menuFile.addItem(menuFileItem09Separator)
      menuFile.addItem(menuFileItem10PageSetup)
      menuFile.addItem(menuFileItem11Print)

      menuFileItem10PageSetup.keyEquivalentModifierMask = [.command, .shift]

      menuFileItem03OpenRecent.submenu = menuOpenRecent

      menuOpenRecent.addItem(menuOpenRecentItemClearMenu)

      menuMainMenuItemAttenuator.submenu = menuAttenuator

      menuAttenuator.addItem(menuAttenuatorItem01AboutAttenuator)
      menuAttenuator.addItem(menuAttenuatorItem02Separator)
      menuAttenuator.addItem(menuAttenuatorItem03Preferences)
      menuAttenuator.addItem(menuAttenuatorItem04Separator)
      menuAttenuator.addItem(menuAttenuatorItem05Services)
      menuAttenuator.addItem(menuAttenuatorItem06Separator)
      menuAttenuator.addItem(menuAttenuatorItem07HideAttenuator)
      menuAttenuator.addItem(menuAttenuatorItem08HideOthers)
      menuAttenuator.addItem(menuAttenuatorItem09ShowAll)
      menuAttenuator.addItem(menuAttenuatorItem10Separator)
      menuAttenuator.addItem(menuAttenuatorItem11QuitAttenuator)

      menuAttenuatorItem08HideOthers.keyEquivalentModifierMask = [.option, .command]

      menuAttenuatorItem05Services.submenu = menuServices
   }
}
