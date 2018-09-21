//
//  DefaultTableSectionNodeModel.swift
//  ThinkerBaseKit
//
//  Created by P36348 on 20/06/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation


public struct DefaultTableSectionNodeModel: TableSectionNodeModel {
    
    public var header: TableSectionHeaderFooterNodeModel? = nil
    
    public var footer: TableSectionHeaderFooterNodeModel? = nil
    
    public var cellViewModels: [TableCellNodeModel]
    
}
