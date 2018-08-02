//
//  TableNodeController.swift
//  ThinkerBaseKit
//
//  Created by P36348 on 2018/5/3.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import RxSwift
import AsyncDisplayKit

public protocol TableSectionNode: class {
    var viewModel: TableSectionNodeModel? {get}
}

public protocol TableSectionNodeModel {
    
    var header: TableSectionHeaderFooterNodeModel? {get}
    
    var footer: TableSectionHeaderFooterNodeModel? {get}
    
    var cellViewModels: [TableCellNodeModel] {get set}
}

public protocol TableSectionHeaderFooterNode: class {
    var viewModel: TableSectionHeaderFooterNodeModel? {get}
    
    func setup(with viewModel: TableSectionHeaderFooterNodeModel)
}

public protocol TableSectionHeaderFooterNodeModel {
    
    var viewClass: AnyClass {get}
    
    var height: CGFloat {get}
}

public protocol TableCellNode: class {
    var viewModel: TableCellNodeModel? {get}
}

private var cellNodeModelKey: String = ""

extension TableCellNode {
    public var viewModel: TableCellNodeModel? {
        set {
            objc_setAssociatedObject(self, &cellNodeModelKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &cellNodeModelKey) as? TableCellNodeModel
        }
    }
}

public protocol TableCellNodeModel {
    
    var cellNodeBlock: ASCellNodeBlock {get}

    var performWhenSelect: ((IndexPath)->Void)? {get}
    
    func setup(for node: ASCellNode)
}

extension TableCellNodeModel {
    public var performWhenSelect: ((IndexPath)->Void)? {
        return nil
    }
}

/// table刷新参数
///
/// - sections: 全部section
/// - rowsAtSection: 某section的row
public enum TableNodeUpdateOption {
    case sections(viewModels: [TableSectionNodeModel], isLast: Bool)
    case rowsAtSection(viewModels: [TableCellNodeModel], section: Int, isLast: Bool)
}

public protocol TableNodeController {
    
    var table: ASTableNode {get}
    
    var viewModels: [TableSectionNodeModel] {get}
}
