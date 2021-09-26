import CoreLocation
import Foundation

extension CLAuthorizationStatus: CustomStringConvertible {

   public var description: String {
      switch self {
      case .authorizedAlways:
         return "authorizedAlways"
      case .notDetermined:
         return "notDetermined"
      case .restricted:
         return "restricted"
      case .denied:
         return "denied"
      case .authorizedWhenInUse:
         return "authorizedWhenInUse"
      @unknown default:
         return "unknown"
      }
   }
}
