//
//  ListController.swift
//  ThinkerBaseKit
//
//  Created by P36348 on 21/06/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import IGListKit
import AsyncDisplayKit

public protocol ListView: class {
    var view: UIView {get}
}

extension UITableView: ListView {
    public var view: UIView {
        return self
    }
}

extension UICollectionView: ListView {
    public var view: UIView {
        return self
    }
}

public protocol ListCellViewModel {
    var cellClass: AnyClass {get}
}

public protocol ListHeaderFooterViewModel {
    
}

public protocol ListSectionViewModel {
    
    var listDiffableValues: ListDiffable? {get}
    
    var header: ListHeaderFooterViewModel? {get}
    
    var footer: ListHeaderFooterViewModel? {get}
    
    var cellViewModels: [ListCellViewModel] {get}
}

extension ListSectionViewModel {
    public var listDiffableValues: ListDiffable? {return nil}
}

public protocol ListController {
    var list: ListView {get}
    
    var viewModels: [ListSectionViewModel] {get}
    
}
