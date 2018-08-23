//
//  MapController.swift
//  ThinkerBaseKit
//
//  Created by P36348 on 21/05/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import CoreLocation

func createDefaultMapAdapter() -> MapAdapter {
    return GoogleMapsAdapter(googleApiKey: "AIzaSyC7MlLSfn5vv6xj0au2G4ceRPa8UFfHm00",
                             defaultLocation: CLLocationCoordinate2D(latitude: 1.420612, longitude: 103.862463))
}

//func createAMapAdapter() -> MapAdapter {
//    return AMapAdapter()
//}

class MapController: BaseController {
    
    let mapAdapter: MapAdapter
    
    public init(mapAdapter: MapAdapter) {
        self.mapAdapter = mapAdapter
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init() {
        self.init(mapAdapter: createDefaultMapAdapter())
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func performSetup() {
        
        self.view.addSubview(self.mapAdapter.map.viewValue)
        self.mapAdapter.map.viewValue.snp.makeConstraints {$0.edges.equalToSuperview()}
        
        self.mapAdapter.enable(true)
        
        self.addMapObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.mapAdapter.enable(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mapAdapter.enable(true)
    }
    
    func addMapObservers() {
        self.mapAdapter
            .didUpdateUserLocation
            .take(1)
            .subscribe(onNext: { $0.adapter.moveCenter(to: $0.location) })
            .disposed(by: self)
        
        
        self.mapAdapter
            .didTapAtLocation
            .subscribe(onNext: { $0.adapter.moveCenter(to: $0.location) })
            .disposed(by: self)
        
        self.mapAdapter
            .didIdleAtLocation
            .subscribe()
            .disposed(by: self)
        
//        self.mapAdapter.didTapAnnotation = { _ in true }
    }
}

