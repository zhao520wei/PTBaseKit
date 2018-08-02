//
//  IGListController.swift
//  ThinkerBaseKit
//
//  Created by P36348 on 21/06/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import IGListKit

public class CustomListSectionController: ListSectionController {
    var item: ListSectionViewModel? = nil
    
    public override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard
        let cellClass = item?.cellViewModels[index].cellClass,
        let cell = self.collectionContext?.dequeueReusableCell(of: cellClass, for: self, at: index) else {
            fatalError()
        }
        return cell
    }
    
    public override func didUpdate(to object: Any) {
        
    }
    
    public override func didSelectItem(at index: Int) {

    }
}


public class IGListController: BaseController, ListController {
    
    // fileprivate values
    fileprivate var _list: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    fileprivate  var _viewModels: [ListDiffable] {
        return self.viewModels.flatMap {$0.listDiffableValues}
    }
    
    public var list: ListView {return self._list}
    
    lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let _adapter = ListAdapter(updater: updater, viewController: self)
        _adapter.collectionView = self._list
        return _adapter
    }()
    
    public var viewModels: [ListSectionViewModel] = []
    
    override public func performSetup() {
        self.view.addSubview(self.list.view)
        self.list.view.snp.makeConstraints {$0.edges.equalTo(UIEdgeInsets.zero)}
        
        self.adapter.dataSource = self
    }
}

extension IGListController: ListAdapterDataSource {
    public func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self._viewModels
    }
    
    public func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return CustomListSectionController()
    }
    
    public func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
}
