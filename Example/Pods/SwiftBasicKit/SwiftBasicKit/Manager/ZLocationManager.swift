
import UIKit
import BFKit
import CoreLocation
import SwiftBasicKit

public class ZLocationManager: NSObject {
    
    public var location: CLLocation?
    public var modelLocation: ZModelLocation?
    public var isLocationSuccess: Bool = false
    public var authorizationStatus: CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return self.manager.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    public var onAuthorizationStatus: ((_ status: CLAuthorizationStatus) -> Void)?
    public var onLocationSuccess: ((_ location: CLLocation) -> Void)?
    public var onLocationError: ((_ error: Error?) -> Void)?
    public var onReverseGeocodeError: ((_ error: Error?) -> Void)?
    public var onReverseGeocodeSuccess: ((_ model: ZModelLocation?) -> Void)?
    
    public static let shared = ZLocationManager()
    
    private var serviceEnable: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    private lazy var manager: CLLocationManager = {
        let item = CLLocationManager()
        
        item.distanceFilter = 1000
        item.desiredAccuracy = kCLLocationAccuracyBest
        
        return item
    }()
    public override init() {
        super.init()
        self.manager.delegate = self
    }
    deinit {
        self.manager.delegate = nil
    }
    public func requestUseAuthorization() {
        self.manager.requestWhenInUseAuthorization()
    }
    public func startLocation() {
        if self.serviceEnable {
            self.manager.startUpdatingLocation()
        }
    }
    public func stopLocation() {
        self.manager.stopUpdatingLocation()
    }
}
extension ZLocationManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.onAuthorizationStatus?(status)
        BFLog.debug("didChangeAuthorization")
    }
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.stopLocation()
            self.location = locations.last
            self.onLocationSuccess?(location)
            BFLog.debug("locationManager latitude: \(location.coordinate.latitude), longitude: \(location.coordinate.longitude)")
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                if #available(iOS 11.0, *) {
                    if let placemark = placemarks?.first {
                        BFLog.debug("reverseGeocodeLocation: \(placemark)")
                        
                        self?.modelLocation = ZModelLocation.init()
                        self?.modelLocation?.country = placemark.country ?? ""
                        self?.modelLocation?.city = placemark.locality ?? ""
                        self?.modelLocation?.state = placemark.thoroughfare ?? ""
                        self?.modelLocation?.area = placemark.subLocality ?? ""
                        self?.modelLocation?.street = placemark.country ?? ""
                        self?.modelLocation?.country_code = placemark.isoCountryCode ?? ""
                        self?.modelLocation?.postal_code = placemark.postalCode ?? ""
                        
                        self?.onReverseGeocodeSuccess?(self?.modelLocation)
                    } else {
                        self?.onReverseGeocodeError?(error)
                    }
                } else {
                    if let placemark = placemarks?.first, let address = placemark.addressDictionary {
                        BFLog.debug("reverseGeocodeLocation address: \(address)")
                        self?.modelLocation = ZModelLocation.init()
                        self?.modelLocation?.country = (address["Country"] as? String) ?? ""
                        self?.modelLocation?.city = (address["City"] as? String) ?? ""
                        self?.modelLocation?.state = (address["State"] as? String) ?? ""
                        self?.modelLocation?.area = (address["SubLocality"] as? String) ?? ""
                        self?.modelLocation?.street = (address["Street"] as? String) ?? ""
                        self?.modelLocation?.country_code = (address["ISOcountryCode"] as? String) ?? ""
                        self?.modelLocation?.postal_code = (address["postalCode"] as? String) ?? ""
                        
                        self?.onReverseGeocodeSuccess?(self?.modelLocation)
                    } else {
                        self?.onReverseGeocodeError?(error)
                    }
                }
            }
        }
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        BFLog.debug("didFailWithError: \(error.localizedDescription)")
        self.stopLocation()
        self.onLocationError?(error)
    }
}
