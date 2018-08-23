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
        let item = UISegmentedControl(items: ["UIKitTable", "ASDKTable", "GoogleMaps", "Utils"])
        item.selectedSegmentIndex = 0
        return item
    }()
    
    let uikitTable: UIKitTableController = UIKitTableController()
    
    let asdkTable: CustomTableNodeController = CustomTableNodeController()
    
    let map: MapController = MapController()
    
    let utils: UtilsController = UtilsController()

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
        self.setup(view: self.utils.view, segmentIndex: 3)
    }
    
    private func setup(view aView: UIView, segmentIndex: Int) {
        // 添加到背景上
        self.view.addSubview(aView)
        aView.snp.makeConstraints{$0.edges.equalToSuperview()}
        // 把显示与否绑定到对应的index上
        self.segmented.rx.value.map { $0 != segmentIndex }.bind(to: aView.rx.isHidden).disposed(by: self)
    }
}
