//
//  SystemImage.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public enum SystemImage: String, CaseIterable {

   case actionTemplate
   case addTemplate
   case advanced
   case applicationIcon
   case bluetoothTemplate
   case bonjour
   case bookmarksTemplate
   case caution
   case colorPanel
   case columnViewTemplate
   case computer
   case enterFullScreenTemplate
   case everyone
   case exitFullScreenTemplate
   case flowViewTemplate
   case folder
   case folderBurnable
   case folderSmart
   case followLinkFreestandingTemplate
   case fontPanel
   case goBackTemplate
   case goForwardTemplate
   case goLeftTemplate
   case goRightTemplate
   case homeTemplate
   case iChatTheaterTemplate
   case iconViewTemplate
   case info
   case invalidDataFreestandingTemplate
   case leftFacingTriangleTemplate
   case listViewTemplate
   case lockLockedTemplate
   case lockUnlockedTemplate
   case menuMixedStateTemplate
   case menuOnStateTemplate
   case mobileMe
   case multipleDocuments
   case network
   case pathTemplate
   case preferencesGeneral
   case quickLookTemplate
   case refreshFreestandingTemplate
   case refreshTemplate
   case removeTemplate
   case revealFreestandingTemplate
   case rightFacingTriangleTemplate
   case shareTemplate
   case slideshowTemplate
   case smartBadgeTemplate
   case statusAvailable
   case statusNone
   case statusPartiallyAvailable
   case statusUnavailable
   case stopProgressFreestandingTemplate
   case stopProgressTemplate
   case trashEmpty
   case trashFull
   case user
   case userAccounts
   case userGroup
   case userGuest

   case touchBarAddDetailTemplate
   case touchBarAddTemplate
   case touchBarAlarmTemplate
   case touchBarAudioInputMuteTemplate
   case touchBarAudioInputTemplate
   case touchBarAudioOutputMuteTemplate
   case touchBarAudioOutputVolumeHighTemplate
   case touchBarAudioOutputVolumeLowTemplate
   case touchBarAudioOutputVolumeMediumTemplate
   case touchBarAudioOutputVolumeOffTemplate
   case touchBarBookmarksTemplate
   case touchBarColorPickerFill
   case touchBarColorPickerFont
   case touchBarColorPickerStroke
   case touchBarCommunicationAudioTemplate
   case touchBarCommunicationVideoTemplate
   case touchBarComposeTemplate
   case touchBarDeleteTemplate
   case touchBarDownloadTemplate
   case touchBarEnterFullScreenTemplate
   case touchBarExitFullScreenTemplate
   case touchBarFastForwardTemplate
   case touchBarFolderCopyToTemplate
   case touchBarFolderMoveToTemplate
   case touchBarFolderTemplate
   case touchBarGetInfoTemplate
   case touchBarGoBackTemplate
   case touchBarGoDownTemplate
   case touchBarGoForwardTemplate
   case touchBarGoUpTemplate
   case touchBarHistoryTemplate
   case touchBarIconViewTemplate
   case touchBarListViewTemplate
   case touchBarMailTemplate
   case touchBarNewFolderTemplate
   case touchBarNewMessageTemplate
   case touchBarOpenInBrowserTemplate
   case touchBarPauseTemplate
   case touchBarPlayPauseTemplate
   case touchBarPlayTemplate
   case touchBarQuickLookTemplate
   case touchBarRecordStartTemplate
   case touchBarRecordStopTemplate
   case touchBarRefreshTemplate
   case touchBarRemoveTemplate
   case touchBarRewindTemplate
   case touchBarRotateLeftTemplate
   case touchBarRotateRightTemplate
   case touchBarSearchTemplate
   case touchBarShareTemplate
   case touchBarSidebarTemplate
   case touchBarSkipAhead15SecondsTemplate
   case touchBarSkipAhead30SecondsTemplate
   case touchBarSkipAheadTemplate
   case touchBarSkipBack15SecondsTemplate
   case touchBarSkipBack30SecondsTemplate
   case touchBarSkipBackTemplate
   case touchBarSkipToEndTemplate
   case touchBarSkipToStartTemplate
   case touchBarSlideshowTemplate
   case touchBarTagIconTemplate
   case touchBarTextBoldTemplate
   case touchBarTextBoxTemplate
   case touchBarTextCenterAlignTemplate
   case touchBarTextItalicTemplate
   case touchBarTextJustifiedAlignTemplate
   case touchBarTextLeftAlignTemplate
   case touchBarTextListTemplate
   case touchBarTextRightAlignTemplate
   case touchBarTextStrikethroughTemplate
   case touchBarTextUnderlineTemplate
   case touchBarUserAddTemplate
   case touchBarUserGroupTemplate
   case touchBarUserTemplate
   case touchBarVolumeDownTemplate
   case touchBarVolumeUpTemplate
   case touchBarPlayheadTemplate

   public var name: NSImage.Name {
      switch self {
      case .addTemplate: return NSImage.addTemplateName
      case .bluetoothTemplate: return NSImage.bluetoothTemplateName
      case .bonjour: return NSImage.bonjourName
      case .bookmarksTemplate: return NSImage.bookmarksTemplateName
      case .caution: return NSImage.cautionName
      case .computer: return NSImage.computerName
      case .enterFullScreenTemplate: return NSImage.enterFullScreenTemplateName
      case .exitFullScreenTemplate: return NSImage.exitFullScreenTemplateName
      case .folder: return NSImage.folderName
      case .folderBurnable: return NSImage.folderBurnableName
      case .folderSmart: return NSImage.folderSmartName
      case .followLinkFreestandingTemplate: return NSImage.followLinkFreestandingTemplateName
      case .homeTemplate: return NSImage.homeTemplateName
      case .iChatTheaterTemplate: return NSImage.iChatTheaterTemplateName
      case .lockLockedTemplate: return NSImage.lockLockedTemplateName
      case .lockUnlockedTemplate: return NSImage.lockUnlockedTemplateName
      case .network: return NSImage.networkName
      case .pathTemplate: return NSImage.pathTemplateName
      case .quickLookTemplate: return NSImage.quickLookTemplateName
      case .refreshFreestandingTemplate: return NSImage.refreshFreestandingTemplateName
      case .refreshTemplate: return NSImage.refreshTemplateName
      case .removeTemplate: return NSImage.removeTemplateName
      case .revealFreestandingTemplate: return NSImage.revealFreestandingTemplateName
      case .shareTemplate: return NSImage.shareTemplateName
      case .slideshowTemplate: return NSImage.slideshowTemplateName
      case .statusAvailable: return NSImage.statusAvailableName
      case .statusNone: return NSImage.statusNoneName
      case .statusPartiallyAvailable: return NSImage.statusPartiallyAvailableName
      case .statusUnavailable: return NSImage.statusUnavailableName
      case .stopProgressFreestandingTemplate: return NSImage.stopProgressFreestandingTemplateName
      case .stopProgressTemplate: return NSImage.stopProgressTemplateName
      case .trashEmpty: return NSImage.trashEmptyName
      case .trashFull: return NSImage.trashFullName
      case .actionTemplate: return NSImage.actionTemplateName
      case .smartBadgeTemplate: return NSImage.smartBadgeTemplateName
      case .iconViewTemplate: return NSImage.iconViewTemplateName
      case .listViewTemplate: return NSImage.listViewTemplateName
      case .columnViewTemplate: return NSImage.columnViewTemplateName
      case .flowViewTemplate: return NSImage.flowViewTemplateName
      case .invalidDataFreestandingTemplate: return NSImage.invalidDataFreestandingTemplateName
      case .goForwardTemplate: return NSImage.goForwardTemplateName
      case .goBackTemplate: return NSImage.goBackTemplateName
      case .goRightTemplate: return NSImage.goRightTemplateName
      case .goLeftTemplate: return NSImage.goLeftTemplateName
      case .rightFacingTriangleTemplate: return NSImage.rightFacingTriangleTemplateName
      case .leftFacingTriangleTemplate: return NSImage.leftFacingTriangleTemplateName
      case .mobileMe: return NSImage.mobileMeName
      case .multipleDocuments: return NSImage.multipleDocumentsName
      case .userAccounts: return NSImage.userAccountsName
      case .preferencesGeneral: return NSImage.preferencesGeneralName
      case .advanced: return NSImage.advancedName
      case .info: return NSImage.infoName
      case .fontPanel: return NSImage.fontPanelName
      case .colorPanel: return NSImage.colorPanelName
      case .user: return NSImage.userName
      case .userGroup: return NSImage.userGroupName
      case .everyone: return NSImage.everyoneName
      case .userGuest: return NSImage.userGuestName
      case .menuOnStateTemplate: return NSImage.menuOnStateTemplateName
      case .menuMixedStateTemplate: return NSImage.menuMixedStateTemplateName
      case .applicationIcon: return NSImage.applicationIconName

      case .touchBarAddDetailTemplate: return NSImage.touchBarAddDetailTemplateName
      case .touchBarAddTemplate: return NSImage.touchBarAddTemplateName
      case .touchBarAlarmTemplate: return NSImage.touchBarAlarmTemplateName
      case .touchBarAudioInputMuteTemplate: return NSImage.touchBarAudioInputMuteTemplateName
      case .touchBarAudioInputTemplate: return NSImage.touchBarAudioInputTemplateName
      case .touchBarAudioOutputMuteTemplate: return NSImage.touchBarAudioOutputMuteTemplateName
      case .touchBarAudioOutputVolumeHighTemplate: return NSImage.touchBarAudioOutputVolumeHighTemplateName
      case .touchBarAudioOutputVolumeLowTemplate: return NSImage.touchBarAudioOutputVolumeLowTemplateName
      case .touchBarAudioOutputVolumeMediumTemplate: return NSImage.touchBarAudioOutputVolumeMediumTemplateName
      case .touchBarAudioOutputVolumeOffTemplate: return NSImage.touchBarAudioOutputVolumeOffTemplateName
      case .touchBarBookmarksTemplate: return NSImage.touchBarBookmarksTemplateName
      case .touchBarColorPickerFill: return NSImage.touchBarColorPickerFillName
      case .touchBarColorPickerFont: return NSImage.touchBarColorPickerFontName
      case .touchBarColorPickerStroke: return NSImage.touchBarColorPickerStrokeName
      case .touchBarCommunicationAudioTemplate: return NSImage.touchBarCommunicationAudioTemplateName
      case .touchBarCommunicationVideoTemplate: return NSImage.touchBarCommunicationVideoTemplateName
      case .touchBarComposeTemplate: return NSImage.touchBarComposeTemplateName
      case .touchBarDeleteTemplate: return NSImage.touchBarDeleteTemplateName
      case .touchBarDownloadTemplate: return NSImage.touchBarDownloadTemplateName
      case .touchBarEnterFullScreenTemplate: return NSImage.touchBarEnterFullScreenTemplateName
      case .touchBarExitFullScreenTemplate: return NSImage.touchBarExitFullScreenTemplateName
      case .touchBarFastForwardTemplate: return NSImage.touchBarFastForwardTemplateName
      case .touchBarFolderCopyToTemplate: return NSImage.touchBarFolderCopyToTemplateName
      case .touchBarFolderMoveToTemplate: return NSImage.touchBarFolderMoveToTemplateName
      case .touchBarFolderTemplate: return NSImage.touchBarFolderTemplateName
      case .touchBarGetInfoTemplate: return NSImage.touchBarGetInfoTemplateName
      case .touchBarGoBackTemplate: return NSImage.touchBarGoBackTemplateName
      case .touchBarGoDownTemplate: return NSImage.touchBarGoDownTemplateName
      case .touchBarGoForwardTemplate: return NSImage.touchBarGoForwardTemplateName
      case .touchBarGoUpTemplate: return NSImage.touchBarGoUpTemplateName
      case .touchBarHistoryTemplate: return NSImage.touchBarHistoryTemplateName
      case .touchBarIconViewTemplate: return NSImage.touchBarIconViewTemplateName
      case .touchBarListViewTemplate: return NSImage.touchBarListViewTemplateName
      case .touchBarMailTemplate: return NSImage.touchBarMailTemplateName
      case .touchBarNewFolderTemplate: return NSImage.touchBarNewFolderTemplateName
      case .touchBarNewMessageTemplate: return NSImage.touchBarNewMessageTemplateName
      case .touchBarOpenInBrowserTemplate: return NSImage.touchBarOpenInBrowserTemplateName
      case .touchBarPauseTemplate: return NSImage.touchBarPauseTemplateName
      case .touchBarPlayPauseTemplate: return NSImage.touchBarPlayPauseTemplateName
      case .touchBarPlayTemplate: return NSImage.touchBarPlayTemplateName
      case .touchBarQuickLookTemplate: return NSImage.touchBarQuickLookTemplateName
      case .touchBarRecordStartTemplate: return NSImage.touchBarRecordStartTemplateName
      case .touchBarRecordStopTemplate: return NSImage.touchBarRecordStopTemplateName
      case .touchBarRefreshTemplate: return NSImage.touchBarRefreshTemplateName
      case .touchBarRemoveTemplate: return NSImage.touchBarRemoveTemplateName
      case .touchBarRewindTemplate: return NSImage.touchBarRewindTemplateName
      case .touchBarRotateLeftTemplate: return NSImage.touchBarRotateLeftTemplateName
      case .touchBarRotateRightTemplate: return NSImage.touchBarRotateRightTemplateName
      case .touchBarSearchTemplate: return NSImage.touchBarSearchTemplateName
      case .touchBarShareTemplate: return NSImage.touchBarShareTemplateName
      case .touchBarSidebarTemplate: return NSImage.touchBarSidebarTemplateName
      case .touchBarSkipAhead15SecondsTemplate: return NSImage.touchBarSkipAhead15SecondsTemplateName
      case .touchBarSkipAhead30SecondsTemplate: return NSImage.touchBarSkipAhead30SecondsTemplateName
      case .touchBarSkipAheadTemplate: return NSImage.touchBarSkipAheadTemplateName
      case .touchBarSkipBack15SecondsTemplate: return NSImage.touchBarSkipBack15SecondsTemplateName
      case .touchBarSkipBack30SecondsTemplate: return NSImage.touchBarSkipBack30SecondsTemplateName
      case .touchBarSkipBackTemplate: return NSImage.touchBarSkipBackTemplateName
      case .touchBarSkipToEndTemplate: return NSImage.touchBarSkipToEndTemplateName
      case .touchBarSkipToStartTemplate: return NSImage.touchBarSkipToStartTemplateName
      case .touchBarSlideshowTemplate: return NSImage.touchBarSlideshowTemplateName
      case .touchBarTagIconTemplate: return NSImage.touchBarTagIconTemplateName
      case .touchBarTextBoldTemplate: return NSImage.touchBarTextBoldTemplateName
      case .touchBarTextBoxTemplate: return NSImage.touchBarTextBoxTemplateName
      case .touchBarTextCenterAlignTemplate: return NSImage.touchBarTextCenterAlignTemplateName
      case .touchBarTextItalicTemplate: return NSImage.touchBarTextItalicTemplateName
      case .touchBarTextJustifiedAlignTemplate: return NSImage.touchBarTextJustifiedAlignTemplateName
      case .touchBarTextLeftAlignTemplate: return NSImage.touchBarTextLeftAlignTemplateName
      case .touchBarTextListTemplate: return NSImage.touchBarTextListTemplateName
      case .touchBarTextRightAlignTemplate: return NSImage.touchBarTextRightAlignTemplateName
      case .touchBarTextStrikethroughTemplate: return NSImage.touchBarTextStrikethroughTemplateName
      case .touchBarTextUnderlineTemplate: return NSImage.touchBarTextUnderlineTemplateName
      case .touchBarUserAddTemplate: return NSImage.touchBarUserAddTemplateName
      case .touchBarUserGroupTemplate: return NSImage.touchBarUserGroupTemplateName
      case .touchBarUserTemplate: return NSImage.touchBarUserTemplateName
      case .touchBarVolumeDownTemplate: return NSImage.touchBarVolumeDownTemplateName
      case .touchBarVolumeUpTemplate: return NSImage.touchBarVolumeUpTemplateName
      case .touchBarPlayheadTemplate: return NSImage.touchBarPlayheadTemplateName
      }
   }

   public var image: NSImage? {
      return NSImage(named: name)
   }

   public var view: NSImageView {
      let view = NSImageView()
      view.image = image
      return view
   }
}

#endif
