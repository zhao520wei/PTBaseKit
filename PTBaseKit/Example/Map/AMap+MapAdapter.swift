////
////  AMap+MapAdapter.swift
////  ThinkerBaseKit
////
////  Created by P36348 on 21/05/2018.
////  Copyright © 2018 P36348. All rights reserved.
////
//
//import Foundation
//import MAMapKit
//import RxSwift
//import AMapSearchKit
//
//extension MAMapView: Map {
//    public var viewValue: UIView {
//        return self
//    }
//}
//
//public class AMapAdapter: NSObject, MapAdapter {
//    public var map: Map {
//        return self.amap
//    }
//    
//    
//    
//    public var centerLocation: CLLocationCoordinate2D {
//        return CLLocationCoordinate2D()
//    }
//    
//    public var userLocation: CLLocationCoordinate2D?
//    
//    public var didTapAnnotation: ((adapter: MapAdapter, annotationAtIndex: Int, identifier: String)) -> Bool = {_ in false }
//    
//    public var didTapAtLocation: PublishSubject<(adapter: MapAdapter, location: CLLocationCoordinate2D)> = PublishSubject<(adapter: MapAdapter, location: CLLocationCoordinate2D)>()
//    
//    public var didIdleAtLocation: PublishSubject<(adapter: MapAdapter, location: CLLocationCoordinate2D)> = PublishSubject<(adapter: MapAdapter, location: CLLocationCoordinate2D)>()
//    
//    public var didUpdateUserLocation: PublishSubject<(adapter: MapAdapter, location: CLLocationCoordinate2D)> = PublishSubject<(adapter: MapAdapter, location: CLLocationCoordinate2D)>()
//    
//    fileprivate var search: AMapSearchAPI = AMapSearchAPI()
//    
//    fileprivate var amap: MAMapView = MAMapView(frame: CGRect.zero)
//    
//    public override init() {
//        super.init()
//        self.amap.delegate = self
//        self.amap.showsUserLocation = true
//        self.amap.showsCompass = false
//        self.amap.showsScale = false
//        self.amap.isShowTraffic = false
//        self.amap.zoomLevel = 16
//        self.amap.isRotateEnabled = true
//        self.amap.isRotateCameraEnabled = false
//        self.amap.userTrackingMode = .follow
//        
//        self.search.delegate = self
//        self.search.language = AMapSearchLanguage.zhCN
//    }
//}
//
//extension AMapAdapter {
//    public func enable(_ flag: Bool) {
//        
//    }
//    
//    public func moveCenter(to location: CLLocationCoordinate2D) {
//        
//    }
//    
//    public func clear() {
//        
//    }
//    
//    public func addAnnotation(location: CLLocationCoordinate2D, view: UIView, tapEnable: Bool, identifier: String) {
//        
//    }
//    
//    public func updateAnnotation(with option: (view: UIView, tapEnable: Bool), at index: Int, identifier: String) {
//        
//    }
//    
//    public func removeAnnotation(at index: Int, identifier: String) {
//        
//    }
//    
//    public func removeAllAnnotations(identifier: String) {
//        
//    }
//    
//    public func removeAllAnnotations() {
//        
//    }
//    
//    public func addPolyLine(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
//        
//    }
//    
//    public func removePolyLine(at index: Int) {
//        
//    }
//    
//    public func removeAllPolyLines() {
//        
//    }
//    
//    public func fetchPathInfo(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Observable<(adapter: MapAdapter, duration: Double, distance: UInt, polyLineSource: MapPolyLineSource)> {
//        
//    }
//    
//    public func addPath(with polyLineSource: MapPolyLineSource, fromView: UIView, toView: UIView) {
//        
//    }
//    
//    public func addPath(fromOption: AnnotationOption, toOption: AnnotationOption) {
//        
//    }
//    
//    public func removeAllPaths() {
//        
//    }
//    
//    public func addOverlay(_ option: MapOverlayOption) {
//        
//    }
//    
//    public func removeOverlay(at index: Int) {
//        
//    }
//    
//    public func removeAllOverlays() {
//        
//    }
//    
//    public func locationOfAnnotaion(at index: Int, identifier: String) -> CLLocationCoordinate2D? {
//        
//    }
//}
//
//extension AMapAdapter: MAMapViewDelegate {
//    public func mapView(_ mapView: MAMapView!, regionDidChangeAnimated animated: Bool) {
//        
//    }
//    
//    public func mapViewDidFinishLoadingMap(_ mapView: MAMapView!) {
//        
//    }
//    
//    public func mapViewRegionChanged(_ mapView: MAMapView!) {
//        
//    }
//}
//
//extension AMapAdapter: AMapSearchDelegate {
//    public func onRouteSearchDone(_ request: AMapRouteSearchBaseRequest!, response: AMapRouteSearchResponse!) {
//        
//    }
//}
