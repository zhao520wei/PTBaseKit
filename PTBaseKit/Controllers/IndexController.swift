//
//  IndexController.swift
//  PTBaseKit
//
//  Created by P36348 on 21/08/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit

class IndexController: BaseController {
    
    let segmented: UISegmentedControl = {
        let item = UISegmentedControl(items: ["UIKitTable", "ASDKTable", "GoogleMaps"])
        item.selectedSegmentIndex = 0
        return item
    }()
    
    let uikitTable: UIKitTableController = UIKitTableController()
    
    let asdkTable: CustomTableNodeController = CustomTableNodeController()
    
    let map: MapController = MapController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func performPreSetup() {
        self.navigationItem.titleView = self.segmented
        self.segmented.tintColor = UIColor.tk.main
    }
    
    override func performSetup() {
        
        self.setup(view: self.uikitTable.view, segmentIndex: 0)
        self.setup(view: self.asdkTable.view, segmentIndex: 1)
        self.setup(view: self.map.view, segmentIndex: 2)
        
    }
    
    private func setup(view aView: UIView, segmentIndex: Int) {
        self.view.addSubview(aView)
        aView.snp.makeConstraints{$0.edges.equalToSuperview()}
        self.segmented.rx.value.map { $0 != segmentIndex }.bind(to: aView.rx.isHidden).disposed(by: self)
    }
}
