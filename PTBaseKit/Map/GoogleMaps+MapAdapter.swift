//
//  GoogleMaps+MapAdapter.swift
//  ThinkerBaseKit
//
//  Created by P36348 on 21/05/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import GoogleMaps
import RxSwift
import Alamofire
import SwiftyJSON

extension GMSMapView: Map {
    public var viewValue: UIView {return self}
}

extension GMSMarker: MapAnnotation {
    public var location: CLLocationCoordinate2D {
        return self.position
    }
    
    public var view: UIView? {
        return self.iconView
    }
}

struct GoogleMapPolyLineSource: MapPolyLineSource {
    let path: GMSPath
    let from: CLLocationCoordinate2D
    let to:   CLLocationCoordinate2D
}

/// google map适配器
public class GoogleMapsAdapter: NSObject, MapAdapter {
    
    public var map: Map {
        return self.googleMap
    }
    
    public var centerLocation: CLLocationCoordinate2D {
        return self.googleMap.projection.coordinate(for: self.googleMap.center)
    }
    
    public var userLocation: CLLocationCoordinate2D? {
        return self.googleMap.myLocation?.coordinate
    }
    
    public var didTapAnnotation: ((adapter: MapAdapter, annotationAtIndex: Int, identifier: String)) -> Bool = {_ in true}
    
    public var didTapAtLocation: PublishSubject<(adapter: MapAdapter, location: CLLocationCoordinate2D)> = PublishSubject<(adapter: MapAdapter, location: CLLocationCoordinate2D)>()
    
    public var didIdleAtLocation: PublishSubject<(adapter: MapAdapter, location: CLLocationCoordinate2D)> = PublishSubject<(adapter: MapAdapter, location: CLLocationCoordinate2D)>()
    
    public var didUpdateUserLocation: PublishSubject<(adapter: MapAdapter, location: CLLocationCoordinate2D)> = PublishSubject<(adapter: MapAdapter, location: CLLocationCoordinate2D)>()
    
    fileprivate var googleMap: GMSMapView!
    
    fileprivate var startMarker: GMSMarker?
    
    fileprivate var destinationMarker: GMSMarker?
    
    fileprivate var selectedMarker: GMSMarker? = nil
    
    fileprivate var markers: [String: [GMSMarker]] = [:]
    
    fileprivate var polylines: [GMSPolyline] = []
    
    fileprivate var overlays: [GMSOverlay] = []
    
    fileprivate var apiKey: String!
    
    public init(googleApiKey: String, defaultLocation: CLLocationCoordinate2D) {
        super.init()
        self.apiKey = googleApiKey
        GMSServices.provideAPIKey(googleApiKey)
        let _map = GMSMapView.map(withFrame: CGRect.zero,
                                  camera: GMSMutableCameraPosition.camera(withLatitude: defaultLocation.latitude,
                                                                          longitude: defaultLocation.longitude,
                                                                          zoom: 14))
        _map.delegate = self
        _map.isIndoorEnabled = false
        self.googleMap = _map
        self.googleMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(sender:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(sender:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    deinit {
        self.googleMap.removeObserver(self, forKeyPath: "myLocation")
    }
    
    @objc func handleNotification(sender: Notification) {
        switch sender.name {
        case .UIApplicationWillResignActive:
            self.enable(false)
        case .UIApplicationDidBecomeActive:
            self.enable(true)
        default:
            break
        }
    }
}

extension GoogleMapsAdapter {
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard
            let location = change?[NSKeyValueChangeKey.newKey] as? CLLocation
            else
        { return }
        self.didUpdateUserLocation.onNext((adapter: self, location: location.coordinate))
    }
}

extension GoogleMapsAdapter {
    public func enable(_ flag: Bool) {
        self.googleMap.preferredFrameRate = flag ? .maximum : .powerSave
        self.googleMap.delegate = flag ? self : nil
        self.googleMap.isMyLocationEnabled = flag
    }
    
    public func moveCenter(to location: CLLocationCoordinate2D) {
        self.googleMap.animate(toLocation: location)
    }
    
    public func clear() {
        self.googleMap.clear()
    }
    
    public func addAnnotation(location: CLLocationCoordinate2D, view: UIView, tapEnable: Bool, identifier: String) {
        let marker = GMSMarker(position: location)
        marker.iconView = view
        marker.isTappable = tapEnable
        marker.map = self.googleMap
        var _markers = self.markers[identifier] ?? []
        _markers.append(marker)
        self.markers[identifier] = _markers
    }
    
    public func updateAnnotation(with option: (view: UIView, tapEnable: Bool), at index: Int, identifier: String) {
        let marker = self.markers[identifier]?[index]
        marker?.iconView = option.view
        marker?.isTappable = option.tapEnable
    }
    
    public func removeAnnotation(at index: Int, identifier: String) {
        guard
            var _markers = self.markers[identifier],
            _markers.count >= index-1
            else {return}
        
        let marker = _markers[index]
        marker.map = nil
        _markers.remove(at: index)
    }
    
    public func removeAllAnnotations(identifier: String) {
        self.markers[identifier]?.forEach {$0.map = nil}
        self.markers[identifier] = nil
    }
    
    public func removeAllAnnotations() {
        self.markers.forEach {param in param.value.forEach {$0.map = nil}}
        self.markers.removeAll()
    }
    
    public func addPath(fromOption: AnnotationOption, toOption: AnnotationOption) {
        if let _oldStartMarker = self.startMarker {
            _oldStartMarker.map = nil
        }
        
        if let _oldDestinationMarker = self.destinationMarker {
            _oldDestinationMarker.map = nil
        }
        
        if let _oldSelectedMarker = self.selectedMarker {
            _oldSelectedMarker.map = self.googleMap
        }
        
        self.startMarker = GMSMarker(position: fromOption.location)
        self.startMarker?.map = self.googleMap
        self.startMarker?.isTappable = false
        self.startMarker?.iconView = fromOption.view
        
        self.selectedMarker = self.markers[toOption.identifier]?.filter {$0.position.latitude == toOption.location.latitude && $0.position.longitude == toOption.location.longitude}.first
        self.selectedMarker?.map = nil
        
        self.destinationMarker = GMSMarker(position: toOption.location)
        self.destinationMarker?.map = self.googleMap
        self.destinationMarker?.isTappable = false
        self.destinationMarker?.iconView = toOption.view
        
        _ = fetchGoogleDirections(from: fromOption.location, to: toOption.location, apiKey: self.apiKey)
            .subscribe(onNext: {[weak self] in self?.addPolyLine(with: $0.first?.path)},
                       onError: {_ in })
    }
    
    public func removeAllPaths() {
        self.removeAllPolyLines()
        self.startMarker?.map = nil
        self.destinationMarker?.map = nil
        self.selectedMarker?.map = self.googleMap
        self.selectedMarker = nil
    }
    
    public func fetchPathInfo(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Observable<(adapter: MapAdapter, duration: Double, distance: UInt, polyLineSource: MapPolyLineSource)> {
        return fetchGoogleDirections(from: from, to: to, apiKey: self.apiKey)
            .flatMap { [weak self] res -> Observable<(adapter: MapAdapter, duration: Double, distance: UInt, polyLineSource: MapPolyLineSource)> in
                guard let weakSelf = self else { return Observable.error(NSError(domain: "adapter deinited", code: 0, userInfo: nil))}
                guard let path = res.first else {return Observable.error(NSError(domain: "Sorry, we didn't get any path.", code: 0, userInfo: nil))}
                
                return Observable.of((adapter: weakSelf,
                                      duration: path.duration,
                                      distance: path.distance,
                                      polyLineSource: GoogleMapPolyLineSource(path: path.path, from: from, to: to)))
        }
    }
    
    
    
    public func addPath(with polyLineSource: MapPolyLineSource, fromView: UIView, toView: UIView) {
        
        guard let source = polyLineSource as? GoogleMapPolyLineSource else {return}
        if let _oldStartMarker = self.startMarker {
            _oldStartMarker.map = nil
        }
        
        if let _oldDestinationMarker = self.destinationMarker {
            _oldDestinationMarker.map = nil
        }
        
        if let _oldSelectedMarker = self.selectedMarker {
            _oldSelectedMarker.map = self.googleMap
        }
        
        self.startMarker = GMSMarker(position: source.from)
        self.startMarker?.map = self.googleMap
        self.startMarker?.isTappable = false
        self.startMarker?.iconView = fromView
        
        let allMarkers = self.markers.values.reduce([]) { (result, _markers) -> [GMSMarker] in
            return [] + _markers
        }
        
        self.selectedMarker = allMarkers.filter {$0.position.latitude == source.to.latitude && $0.position.longitude == source.to.longitude}.first
        self.selectedMarker?.map = nil
        
        self.destinationMarker = GMSMarker(position: source.to)
        self.destinationMarker?.map = self.googleMap
        self.destinationMarker?.isTappable = false
        self.destinationMarker?.iconView = toView
        
        self.addPolyLine(with: source.path)
    }
    
    public func addPolyLine(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        let path = GMSMutablePath()
        path.add(from)
        path.add(to)
        self.addPolyLine(with: path)
    }
    
    private func addPolyLine(with path: GMSPath?) {
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = 0x0090ff.hexColor
        polyline.strokeWidth = 4
        polyline.map = self.googleMap
        self.polylines.append(polyline)
    }
    
    public func removePolyLine(at index: Int) {
        guard self.polylines.count >= index-1 else { return }
        
        let line = self.polylines[index]
        line.map = nil
        self.polylines.remove(at: index)
    }
    
    public func removeAllPolyLines() {
        self.polylines.forEach {$0.map = nil}
        self.polylines.removeAll()
    }
    
    public func addOverlay(_ option: MapOverlayOption) {
        switch option {
        case .circle(let location, let radius):
            let circ = GMSCircle(position: location, radius: radius)
            circ.fillColor = UIColor.tk.main.withAlphaComponent(0.2)
            circ.strokeColor = UIColor.tk.main
            circ.map = self.googleMap
            self.overlays.append(circ)
        case .polygon(let locations):
            let path = GMSMutablePath()
            locations.forEach {path.add($0)}
            
            let overlay = GMSPolygon(path: path)
            overlay.fillColor = UIColor.tk.main.withAlphaComponent(0.2)
            overlay.strokeColor = UIColor.tk.main
            overlay.strokeWidth = 2
            overlay.map = self.googleMap
            self.overlays.append(overlay)
        }
    }
    
    public func removeOverlay(at index: Int) {
        guard self.overlays.count >= index-1 else { return }
        
        let Overlay = self.overlays[index]
        Overlay.map = nil
        self.overlays.remove(at: index)
    }
    
    public func removeAllOverlays() {
        self.overlays.forEach {$0.map = nil}
        self.overlays.removeAll()
    }
    
    public func locationOfAnnotaion(at index: Int, identifier: String) -> CLLocationCoordinate2D? {
        return self.markers[identifier]?[index].position
    }
}

extension GoogleMapsAdapter: GMSMapViewDelegate {
    public func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.didIdleAtLocation.onNext((adapter: self, location: position.target))
        self.perform(#selector(self.enablePerformanceMode(_:)), with: false, afterDelay: 0.5, inModes: [RunLoopMode.defaultRunLoopMode])
    }
    public func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        Thread.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.enablePerformanceMode(_:)), object: nil)
        self.enablePerformanceMode(true)
    }
    
    public func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.didTapAtLocation.onNext((adapter: self, location: coordinate))
    }
    
    @objc private func enablePerformanceMode(_ flag: Bool) {
        self.googleMap.preferredFrameRate = flag ? .maximum : .powerSave
    }
    
    public func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        var result = false
        var index = 0
        var id = ""
        self.markers.forEach {param in
            if let _index = param.value.index(of: marker) {
                result = true
                index = _index
                id = param.key
            }
        }
        if result {
            return self.didTapAnnotation((self, index, id))
        }
        return false
    }
}

typealias DirectionResult = (path: GMSPath, distance: UInt, duration: Double)

private func fetchGoogleDirections(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, apiKey: String) -> Observable<[DirectionResult]> {
    return Observable<[DirectionResult]>.create({ (observer) -> Disposable in
        let params = [
            "origin": "\(from.latitude),\(from.longitude)",
            "destination": "\(to.latitude),\(to.longitude)",
            "mode": "walking",
            "key": apiKey]
        
        Alamofire
            .request("https://maps.googleapis.com/maps/api/directions/json", method: HTTPMethod.get, parameters: params)
            .responseJSON(completionHandler: { (res) in
                guard
                    let data = res.data,
                    let json = try? JSON(data: data)
                    else
                {return observer.onError(NSError(domain: "Fail to load path, please try again later.", code: 0, userInfo: nil))}
                var results: [DirectionResult] = []
                json["routes"].arrayValue.forEach({ (route) in
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let legs = route["legs"].arrayValue
                    let distance: UInt = legs.reduce(0, { (result, leg) -> UInt in
                        return leg["distance"]["value"].uIntValue + result
                    })
                    let duration: Double = legs.reduce(0, { (result, leg) -> Double in
                        return leg["duration"]["value"].doubleValue + result
                    })
                    
                    if let path = GMSPath(fromEncodedPath: points!) {
                        results.append((path: path, distance: distance, duration: duration))
                    }
                })
                observer.onNext(results)
            })
        
        return Disposables.create()
    })
}
