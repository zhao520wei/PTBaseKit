//
//  TableController.swift
//  ThinkerBaseKit
//
//  Created by P36348 on 13/12/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import UIKit

public protocol TableSection: class {
    var viewModel: TableSectionViewModel? {get}
}

public protocol TableSectionViewModel {
    
    var header: TableSectionHeaderFooterViewModel? {get}
    
    var footer: TableSectionHeaderFooterViewModel? {get}
    
    var cellViewModels: [TableCellViewModel] {get}
}

public protocol TableSectionHeaderFooter: class {
    var viewModel: TableSectionHeaderFooterViewModel? {get}
    
    func setup(with viewModel: TableSectionHeaderFooterViewModel)
}

public protocol TableSectionHeaderFooterViewModel {
    
    var viewClass: AnyClass {get}
    
    var height: CGFloat {get}
}

public protocol TableCell: class {
    
    var viewModel: TableCellViewModel? {get}
    
    func setup(with viewModel: TableCellViewModel)
}

public protocol TableCellViewModel {
    
    var cellClass: AnyClass {get}
    
    var canEdit: Bool {get}
    
    var height: CGFloat {get}
    
    var performWhenSelect: ((UITableView, IndexPath)->Void)? {get}
}

extension TableCellViewModel {
    public var performWhenSelect: ((UITableView, IndexPath)->Void)? {
        return nil
    }
    public var canEdit: Bool { return false }
}

public protocol TableController: class {
        
    var tableView: UITableView {get}
    
    var header: UIView? {get set}
    
    var footer: UIView? {get set}
    
    func reload(withCellViewModels viewModels: [TableCellViewModel], isLast: Bool) -> Void
    
    func loadMore(withCellViewModels viewModels: [TableCellViewModel], isLast: Bool) -> Void
    
    func reload(withSectionViewModels viewModels: [TableSectionViewModel], isLast: Bool) -> Void
    
    func loadMore(withSectionViewModels viewModels: [TableSectionViewModel], isLast: Bool) -> Void
    
}
