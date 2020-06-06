//
//  CarbonIcon.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public enum CarbonIcon: String, CaseIterable {

   case aFPServer
   case alertCaution
   case alertCautionBadge
   case alertNote
   case alertStop
   case aliasBadge
   case appearanceFolder
   case appleExtrasFolder
   case appleLogo
   case appleMenu
   case appleMenuFolder
   case appleScriptBadge
   case appleTalk
   case appleTalkZone
   case applicationSupportFolder
   case applicationsFolder
   case assistantsFolder
   case backwardArrow
   case burning
   case clipboard
   case clippingPictureType
   case clippingSoundType
   case clippingTextType
   case clippingUnknownType
   case colorSyncFolder
   case computer
   case connectTo
   case contextualMenuItemsFolder
   case controlPanelDisabledFolder
   case controlPanelFolder
   case controlStripModulesFolder
   case deleteAlias
   case desktop
   case documentsFolder
   case dropFolder
   case ejectMedia
   case extensionsDisabledFolder
   case extensionsFolder
   case fTPServer
   case favoriteItems
   case favoritesFolder
   case finder
   case fontSuitcase
   case fontsFolder
   case forwardArrow
   case fullTrash
   case genericApplication
   case genericCDROM
   case genericComponent
   case genericControlPanel
   case genericControlStripModule
   case genericDeskAccessory
   case genericDocument
   case genericEditionFile
   case genericExtension
   case genericFileServer
   case genericFloppy
   case genericFolder
   case genericFont
   case genericFontScaler
   case genericHardDisk
   case genericIDisk
   case genericMoverObject
   case genericNetwork
   case genericPCCard
   case genericPreferences
   case genericQueryDocument
   case genericRAMDisk
   case genericRemovableMedia
   case genericSharedLibary
   case genericStationery
   case genericSuitcase
   case genericURL
   case genericWORM
   case genericWindow
   case grid
   case group
   case guestUser
   case hTTPServer
   case help
   case helpFolder
   case iPFileServer
   case internationResources
   case internationalResources
   case internetFolder
   case internetLocationAppleShare
   case internetLocationAppleTalkZone
   case internetLocationFTP
   case internetLocationFile
   case internetLocationGeneric
   case internetLocationHTTP
   case internetLocationMail
   case internetLocationNSLNeighborhood
   case internetLocationNews
   case internetPlugInFolder
   case internetSearchSitesFolder
   case keepArranged
   case keyboardLayout
   case localesFolder
   case locked
   case lockedBadge
   case macOSReadMeFolder
   case mountedBadge
   case mountedFolder
   case noFiles
   case noFolder
   case noWrite
   case openFolder
   case ownedFolder
   case owner
   case preferencesFolder
   case printMonitorFolder
   case printerDescriptionFolder
   case printerDriverFolder
   case privateFolder
   case protectedApplicationFolder
   case protectedSystemFolder
   case publicFolder
   case questionMark
   case recentApplicationsFolder
   case recentDocumentsFolder
   case recentItems
   case recentServersFolder
   case rightContainerArrow
   case scriptingAdditionsFolder
   case scriptsFolder
   case sharedBadge
   case sharedFolder
   case sharedLibrariesFolder
   case sharingPrivsNotApplicable
   case sharingPrivsReadOnly
   case sharingPrivsReadWrite
   case sharingPrivsUnknown
   case sharingPrivsWritable
   case shortcut
   case shutdownItemsDisabledFolder
   case shutdownItemsFolder
   case sortAscending
   case sortDescending
   case soundFile
   case speakableItemsFo
   case startupItemsDisabledFolder
   case startupItemsFolder
   case systemExtensionDisabledFolder
   case systemFolder
   case systemSuitcase
   case textEncodingsFolder
   case toolbarAdvanced
   case toolbarApplicationsFolder
   case toolbarCustomize
   case toolbarDelete
   case toolbarDesktopFolder
   case toolbarDocumentsFolder
   case toolbarDownloadsFolder
   case toolbarFavorites
   case toolbarHome
   case toolbarInfo
   case toolbarLabels
   case toolbarLibraryFolder
   case toolbarMovieFolder
   case toolbarMusicFolder
   case toolbarPicturesFolder
   case toolbarPublicFolder
   case toolbarSitesFolder
   case toolbarUtilitiesFolder
   case trash
   case trueTypeFlatFont
   case trueTypeFont
   case trueTypeMultiFlatFont
   case unknownFSObject
   case unlocked
   case user
   case userFolder
   case userIDisk
   case usersFolder
   case utilitiesFolder
   case voicesFolder
   case workgroupFolder

   public var code: Int {
      switch self {
      case .clipboard: return kClipboardIcon
      case .clippingUnknownType: return kClippingUnknownTypeIcon
      case .clippingPictureType: return kClippingPictureTypeIcon
      case .clippingTextType: return kClippingTextTypeIcon
      case .clippingSoundType: return kClippingSoundTypeIcon
      case .desktop: return kDesktopIcon
      case .finder: return kFinderIcon
      case .computer: return kComputerIcon
      case .fontSuitcase: return kFontSuitcaseIcon
      case .fullTrash: return kFullTrashIcon
      case .genericApplication: return kGenericApplicationIcon
      case .genericCDROM: return kGenericCDROMIcon
      case .genericControlPanel: return kGenericControlPanelIcon
      case .genericControlStripModule: return kGenericControlStripModuleIcon
      case .genericComponent: return kGenericComponentIcon
      case .genericDeskAccessory: return kGenericDeskAccessoryIcon
      case .genericDocument: return kGenericDocumentIcon
      case .genericEditionFile: return kGenericEditionFileIcon
      case .genericExtension: return kGenericExtensionIcon
      case .genericFileServer: return kGenericFileServerIcon
      case .genericFont: return kGenericFontIcon
      case .genericFontScaler: return kGenericFontScalerIcon
      case .genericFloppy: return kGenericFloppyIcon
      case .genericHardDisk: return kGenericHardDiskIcon
      case .genericIDisk: return kGenericIDiskIcon
      case .genericRemovableMedia: return kGenericRemovableMediaIcon
      case .genericMoverObject: return kGenericMoverObjectIcon
      case .genericPCCard: return kGenericPCCardIcon
      case .genericPreferences: return kGenericPreferencesIcon
      case .genericQueryDocument: return kGenericQueryDocumentIcon
      case .genericRAMDisk: return kGenericRAMDiskIcon
      case .genericSharedLibary: return kGenericSharedLibaryIcon
      case .genericStationery: return kGenericStationeryIcon
      case .genericSuitcase: return kGenericSuitcaseIcon
      case .genericURL: return kGenericURLIcon
      case .genericWORM: return kGenericWORMIcon
      case .internationalResources: return kInternationalResourcesIcon
      case .keyboardLayout: return kKeyboardLayoutIcon
      case .soundFile: return kSoundFileIcon
      case .systemSuitcase: return kSystemSuitcaseIcon
      case .trash: return kTrashIcon
      case .trueTypeFont: return kTrueTypeFontIcon
      case .trueTypeFlatFont: return kTrueTypeFlatFontIcon
      case .trueTypeMultiFlatFont: return kTrueTypeMultiFlatFontIcon
      case .userIDisk: return kUserIDiskIcon
      case .unknownFSObject: return kUnknownFSObjectIcon
      case .internationResources: return kInternationResourcesIcon
      case .internetLocationHTTP: return kInternetLocationHTTPIcon
      case .internetLocationFTP: return kInternetLocationFTPIcon
      case .internetLocationAppleShare: return kInternetLocationAppleShareIcon
      case .internetLocationAppleTalkZone: return kInternetLocationAppleTalkZoneIcon
      case .internetLocationFile: return kInternetLocationFileIcon
      case .internetLocationMail: return kInternetLocationMailIcon
      case .internetLocationNews: return kInternetLocationNewsIcon
      case .internetLocationNSLNeighborhood: return kInternetLocationNSLNeighborhoodIcon
      case .internetLocationGeneric: return kInternetLocationGenericIcon
      case .genericFolder: return kGenericFolderIcon
      case .dropFolder: return kDropFolderIcon
      case .mountedFolder: return kMountedFolderIcon
      case .openFolder: return kOpenFolderIcon
      case .ownedFolder: return kOwnedFolderIcon
      case .privateFolder: return kPrivateFolderIcon
      case .sharedFolder: return kSharedFolderIcon
      case .sharingPrivsNotApplicable: return kSharingPrivsNotApplicableIcon
      case .sharingPrivsReadOnly: return kSharingPrivsReadOnlyIcon
      case .sharingPrivsReadWrite: return kSharingPrivsReadWriteIcon
      case .sharingPrivsUnknown: return kSharingPrivsUnknownIcon
      case .sharingPrivsWritable: return kSharingPrivsWritableIcon
      case .userFolder: return kUserFolderIcon
      case .workgroupFolder: return kWorkgroupFolderIcon
      case .guestUser: return kGuestUserIcon
      case .user: return kUserIcon
      case .owner: return kOwnerIcon
      case .group: return kGroupIcon
      case .appearanceFolder: return kAppearanceFolderIcon
      case .appleExtrasFolder: return kAppleExtrasFolderIcon
      case .appleMenuFolder: return kAppleMenuFolderIcon
      case .applicationsFolder: return kApplicationsFolderIcon
      case .applicationSupportFolder: return kApplicationSupportFolderIcon
      case .assistantsFolder: return kAssistantsFolderIcon
      case .colorSyncFolder: return kColorSyncFolderIcon
      case .contextualMenuItemsFolder: return kContextualMenuItemsFolderIcon
      case .controlPanelDisabledFolder: return kControlPanelDisabledFolderIcon
      case .controlPanelFolder: return kControlPanelFolderIcon
      case .controlStripModulesFolder: return kControlStripModulesFolderIcon
      case .documentsFolder: return kDocumentsFolderIcon
      case .extensionsDisabledFolder: return kExtensionsDisabledFolderIcon
      case .extensionsFolder: return kExtensionsFolderIcon
      case .favoritesFolder: return kFavoritesFolderIcon
      case .fontsFolder: return kFontsFolderIcon
      case .helpFolder: return kHelpFolderIcon
      case .internetFolder: return kInternetFolderIcon
      case .internetPlugInFolder: return kInternetPlugInFolderIcon
      case .internetSearchSitesFolder: return kInternetSearchSitesFolderIcon
      case .localesFolder: return kLocalesFolderIcon
      case .macOSReadMeFolder: return kMacOSReadMeFolderIcon
      case .publicFolder: return kPublicFolderIcon
      case .preferencesFolder: return kPreferencesFolderIcon
      case .printerDescriptionFolder: return kPrinterDescriptionFolderIcon
      case .printerDriverFolder: return kPrinterDriverFolderIcon
      case .printMonitorFolder: return kPrintMonitorFolderIcon
      case .recentApplicationsFolder: return kRecentApplicationsFolderIcon
      case .recentDocumentsFolder: return kRecentDocumentsFolderIcon
      case .recentServersFolder: return kRecentServersFolderIcon
      case .scriptingAdditionsFolder: return kScriptingAdditionsFolderIcon
      case .sharedLibrariesFolder: return kSharedLibrariesFolderIcon
      case .scriptsFolder: return kScriptsFolderIcon
      case .shutdownItemsDisabledFolder: return kShutdownItemsDisabledFolderIcon
      case .shutdownItemsFolder: return kShutdownItemsFolderIcon
      case .speakableItemsFo: return kSpeakableItemsFolder
      case .startupItemsDisabledFolder: return kStartupItemsDisabledFolderIcon
      case .startupItemsFolder: return kStartupItemsFolderIcon
      case .systemExtensionDisabledFolder: return kSystemExtensionDisabledFolderIcon
      case .systemFolder: return kSystemFolderIcon
      case .textEncodingsFolder: return kTextEncodingsFolderIcon
      case .usersFolder: return kUsersFolderIcon
      case .utilitiesFolder: return kUtilitiesFolderIcon
      case .voicesFolder: return kVoicesFolderIcon
      case .appleScriptBadge: return kAppleScriptBadgeIcon
      case .lockedBadge: return kLockedBadgeIcon
      case .mountedBadge: return kMountedBadgeIcon
      case .sharedBadge: return kSharedBadgeIcon
      case .aliasBadge: return kAliasBadgeIcon
      case .alertCautionBadge: return kAlertCautionBadgeIcon
      case .alertNote: return kAlertNoteIcon
      case .alertCaution: return kAlertCautionIcon
      case .alertStop: return kAlertStopIcon
      case .appleTalk: return kAppleTalkIcon
      case .appleTalkZone: return kAppleTalkZoneIcon
      case .aFPServer: return kAFPServerIcon
      case .fTPServer: return kFTPServerIcon
      case .hTTPServer: return kHTTPServerIcon
      case .genericNetwork: return kGenericNetworkIcon
      case .iPFileServer: return kIPFileServerIcon
      case .toolbarCustomize: return kToolbarCustomizeIcon
      case .toolbarDelete: return kToolbarDeleteIcon
      case .toolbarFavorites: return kToolbarFavoritesIcon
      case .toolbarHome: return kToolbarHomeIcon
      case .toolbarAdvanced: return kToolbarAdvancedIcon
      case .toolbarInfo: return kToolbarInfoIcon
      case .toolbarLabels: return kToolbarLabelsIcon
      case .toolbarApplicationsFolder: return kToolbarApplicationsFolderIcon
      case .toolbarDocumentsFolder: return kToolbarDocumentsFolderIcon
      case .toolbarMovieFolder: return kToolbarMovieFolderIcon
      case .toolbarMusicFolder: return kToolbarMusicFolderIcon
      case .toolbarPicturesFolder: return kToolbarPicturesFolderIcon
      case .toolbarPublicFolder: return kToolbarPublicFolderIcon
      case .toolbarDesktopFolder: return kToolbarDesktopFolderIcon
      case .toolbarDownloadsFolder: return kToolbarDownloadsFolderIcon
      case .toolbarLibraryFolder: return kToolbarLibraryFolderIcon
      case .toolbarUtilitiesFolder: return kToolbarUtilitiesFolderIcon
      case .toolbarSitesFolder: return kToolbarSitesFolderIcon
      case .appleLogo: return kAppleLogoIcon
      case .appleMenu: return kAppleMenuIcon
      case .backwardArrow: return kBackwardArrowIcon
      case .favoriteItems: return kFavoriteItemsIcon
      case .forwardArrow: return kForwardArrowIcon
      case .grid: return kGridIcon
      case .help: return kHelpIcon
      case .keepArranged: return kKeepArrangedIcon
      case .locked: return kLockedIcon
      case .noFiles: return kNoFilesIcon
      case .noFolder: return kNoFolderIcon
      case .noWrite: return kNoWriteIcon
      case .protectedApplicationFolder: return kProtectedApplicationFolderIcon
      case .protectedSystemFolder: return kProtectedSystemFolderIcon
      case .recentItems: return kRecentItemsIcon
      case .shortcut: return kShortcutIcon
      case .sortAscending: return kSortAscendingIcon
      case .sortDescending: return kSortDescendingIcon
      case .unlocked: return kUnlockedIcon
      case .connectTo: return kConnectToIcon
      case .genericWindow: return kGenericWindowIcon
      case .questionMark: return kQuestionMarkIcon
      case .deleteAlias: return kDeleteAliasIcon
      case .ejectMedia: return kEjectMediaIcon
      case .burning: return kBurningIcon
      case .rightContainerArrow: return kRightContainerArrowIcon
      }
   }

   public var fileType: String? {
      if code < 0 {
         return nil
      }
      return NSFileTypeForHFSTypeCode(OSType(code))
   }

   public var image: NSImage? {
      return fileType.map { NSWorkspace.shared.icon(forFileType: $0) }
   }

   public var view: NSImageView {
      let view = NSImageView()
      view.image = image
      return view
   }
}

#endif
