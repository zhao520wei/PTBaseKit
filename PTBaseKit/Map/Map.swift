//
//  Map.swift
//  ThinkerBaseKit
//
//  Created by P36348 on 01/07/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

public class MapManager {
    
    var map: Map
    
    public var didTapAnnotation: Observable<(adapter: MapAdapter, annotationAtIndex: Int, identifier: String)> {
        return _didtapAnnotation
    }
    
    public var didTapAtLocation: Observable<(adapter: MapAdapter, location: CLLocationCoordinate2D)> {
        return _didTapAtLocation
    }
    
    public var didIdleAtLocation: Observable<(adapter: MapAdapter, location: CLLocationCoordinate2D)> {
        return _didIdleAtLocation
    }
    
    public var didUpdateUserLocation: Observable<(adapter: MapAdapter, location: CLLocationCoordinate2D)> {
        return _didUpdateUserLocation
    }
    
    fileprivate var _didtapAnnotation = PublishSubject<(adapter: MapAdapter, annotationAtIndex: Int, identifier: String)>()
    
    fileprivate var _didTapAtLocation = PublishSubject<(adapter: MapAdapter, location: CLLocationCoordinate2D)>()
    
    fileprivate var _didIdleAtLocation = PublishSubject<(adapter: MapAdapter, location: CLLocationCoordinate2D)>()
    
    fileprivate var _didUpdateUserLocation = PublishSubject<(adapter: MapAdapter, location: CLLocationCoordinate2D)>()
    
    public init (withMap map: Map) {
        self.map = map
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(sender:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(sender:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    @objc private func handleNotification(sender: Notification) {
        switch sender.name {
        case .UIApplicationWillResignActive:
            self.enableMap(false)
        case .UIApplicationDidBecomeActive:
            self.enableMap(true)
        default:
            break
        }
    }
    
    
}

extension MapManager {
    func enableMap(_ flag: Bool) {
        
    }
    
    func moveMapCenter(to location: CLLocationCoordinate2D) {
        
    }
    
    func clearMap() {
        
    }
}
