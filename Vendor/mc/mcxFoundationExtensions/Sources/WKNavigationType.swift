import Foundation
#if !os(watchOS)
import WebKit

extension WKNavigationType: CustomStringConvertible {
   public var description: String {
      switch self {
      case .backForward:
         return "backForward"
      case .formResubmitted:
         return "formResubmitted"
      case .formSubmitted:
         return "formSubmitted"
      case .linkActivated:
         return "linkActivated"
      case .other:
         return "other"
      case .reload:
         return "reload"
      @unknown default:
         return "unknown"
      }
   }
}
#endif
