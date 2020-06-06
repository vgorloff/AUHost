//
//  Geocoder.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation
import MapKit

public class Geocoder {
   public struct Code {
      var address: String
   }

   public struct Reverse {
      private let poi: CLLocationCoordinate2D
      public private(set) var error: Error?
      public private(set) var adress: Address?
   }

   public struct Address {

      public let street: String
      public let city: String
      public let subLocality: String
      public let houseNumber: String
      public let zip: String

      init?(placemark: CLPlacemark?) {
         city = placemark?.locality ?? ""
         subLocality = placemark?.subLocality ?? ""
         houseNumber = placemark?.subThoroughfare ?? ""
         zip = placemark?.postalCode ?? ""
         var streetString = placemark?.name ?? ""
         if !streetString.isEmpty, streetString.contains(houseNumber) {
            streetString = streetString.replacingOccurrences(of: houseNumber, with: "").trimmingCharacters(in: .whitespaces)
         }
         if streetString == zip + " " + city {
            streetString = ""
         }
         street = streetString
      }
   }
}

extension Geocoder.Reverse {

   public init(poi: CLLocationCoordinate2D) {
      self.poi = poi
   }

   public func getAddress(completion: ((Geocoder.Address?, Error?) -> Void)?) {
      let geoCoder = CLGeocoder()
      let location = CLLocation(latitude: poi.latitude, longitude: poi.longitude)
      geoCoder.reverseGeocodeLocation(location) { placemarks, error in
         completion?(Geocoder.Address(placemark: placemarks?.first), error)
      }
   }
}

extension Geocoder.Code {

   public init(country: String, houseNo: String, street: String, city: String, zipCode: String) {
      var address = ""
      if !country.isEmpty {
         address += country + ", "
      }
      if !houseNo.isEmpty {
         address += houseNo + " "
      }
      if !street.isEmpty {
         address += street + ", "
      }
      if !city.isEmpty {
         address += city + ", "
      }
      if !zipCode.isEmpty {
         address += zipCode + " "
      }
      self.address = address
   }

   func getCoordinate(completion: ((CLLocationCoordinate2D?, Error?) -> Void)?) {
      let geoCoder = CLGeocoder()
      geoCoder.geocodeAddressString(address) { placemarks, error in
         let location = placemarks?.first?.location?.coordinate
         completion?(location, error)
      }
   }
}
