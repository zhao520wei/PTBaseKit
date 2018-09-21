//
//  DefaultTableController.swift
//  ThinkerBaseKit
//
//  Created by P36348 on 2018/5/3.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import RxSwift
import MJRefresh
import AsyncDisplayKit

public struct TableConfiguration {
    var loadAutomatically: Bool = false
}

private enum TableUpdateType {
    case reload
    case loadMore
    case update(option: TableNodeUpdateOption)
}

public class DefaultTableController: BaseController, TableNodeController {
    
    fileprivate var reloadAction: (() -> Observable<TableNodeUpdateOption>)? = nil
    
    fileprivate var loadMoreAction: (() -> Observable<TableNodeUpdateOption>)? = nil
    
    public let tableDidReload: PublishSubject<DefaultTableController> = PublishSubject<DefaultTableController>()
    
    public let tableDidLoadMore: PublishSubject<DefaultTableController> = PublishSubject<DefaultTableController>()
    
    // MARK: datas
    
    public var viewModels: [TableSectionNodeModel] = []
    
    public var config: TableConfiguration = TableConfiguration()
    
    // MARK: nodes
    
    public let table: ASTableNode = ASTableNode()
    
    public override func performPreSetup() {
        self.table.dataSource = self
        self.table.delegate = self
        self.view.addSubnode(self.table)
        self.table.view.snp.makeConstraints {$0.edges.equalTo(UIEdgeInsets.zero)}
    }
    
    public override func performSetup() {
        
        if let action = self.reloadAction {
            self.setupRefreshHeader(with: action)
        }
        if self.config.loadAutomatically {
            self.performReload().subscribe().disposed(by: self)
        }
    }
    
    fileprivate func setupRefreshHeader(with action: @escaping () -> Observable<TableNodeUpdateOption>) {
        self.table.view.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let weakSelf = self else {return}
            _ = weakSelf.performUpdateTable(with: .reload, action: action)
                .subscribe(onNext: {weakSelf.tableDidReload.onNext($0)}, onError: {weakSelf.tableDidReload.onError($0)})
        })
    }
    
    fileprivate func setupLoadMoreFooter(with action: @escaping () -> Observable<TableNodeUpdateOption>) {
        self.table.view.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            guard let weakSelf = self else {return}
            _ = weakSelf.performUpdateTable(with: .loadMore, action: action)
                .subscribe(onNext: {weakSelf.tableDidLoadMore.onNext($0)}, onError: {weakSelf.tableDidLoadMore.onError($0)})
        })
    }
}

extension DefaultTableController {
    
    public func bindReloadDataGenerator(_ action: @escaping () -> Observable<TableNodeUpdateOption>) {
        self.reloadAction = action
        
    }
    
    public func bindLoadMoreDataGenerator(_ action: @escaping () -> Observable<TableNodeUpdateOption>) {
        self.loadMoreAction = action
    }
    
    private func rx_tableBeginRefreshing() -> Observable<()> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            if
                let header = self?.table.view.mj_header
            {
                header.beginRefreshing(completionBlock: {
                    observer.onNext(())
                })
            }
            else
            {
                observer.onError(NSError(domain: "No refresh header inited", code: -1024, userInfo: nil))
            }
            
            return Disposables.create()
        })
    }
    
    /// 主动调用刷新, table自动处理刷新viewModels, subcribe之后, tableDidReload照样会发送信号
    public func performReload() -> Observable<DefaultTableController> {
        self.table.view.mj_header.beginRefreshing()
        return self.tableDidReload.takeLast(1)
    }
    
    /// 更新table
    ///
    /// - Parameters:
    ///   - updateType: 更新类型
    ///   - action: 数据更新动作
    fileprivate func performUpdateTable(with updateType: TableUpdateType, action: @escaping () -> Observable<TableNodeUpdateOption>) -> Observable<DefaultTableController> {
        return
            (Thread.isMainThread ? DispatchQueue.global().rx_async(with: ()) : Observable.just(()))// 保证在子线程中调用加载
                .flatMap { action() }
                .flatMap { DispatchQueue.main.rx_async(with: $0) } // 切换回主线程
                .flatMap { [weak self] param -> Observable<DefaultTableController> in
                    guard let weakSelf = self else {return Observable.error(NSError())} //TODO: 报错
                    switch updateType {
                    case .reload:
                        return weakSelf.reload(withOption: param)
                    case .loadMore:
                        return weakSelf.loadMore(withOption: param)
                    case .update:
                        return weakSelf.update(withOption: param)
                    }
        }
    }
    
    func reload(withOption option: TableNodeUpdateOption) -> Observable<DefaultTableController> {
        if
            self.table.view.mj_header?.state == .refreshing
        {
            self.table.view.mj_header.endRefreshing()
        }
        
        var isLast = false
        
        switch option {
        case .rowsAtSection(let _viewModels, let section, let _isLast):
            isLast = _isLast
            var newModel = self.viewModels[section]
            newModel.cellViewModels = _viewModels
            self.viewModels[section] = newModel
        case .sections(let _viewModels, let _isLast):
            self.viewModels = _viewModels
            isLast = _isLast
        }
        
        if
            let action = self.loadMoreAction,
            self.table.view.mj_footer == nil,
            !isLast
        {   // 保证在第一次刷新成功后才出现加载更多
            self.setupLoadMoreFooter(with: action)
        }
        
        return self.reloadTable()
    }
    
    func loadMore(withOption option: TableNodeUpdateOption) -> Observable<DefaultTableController> {
        var showNoMoreData = false
        switch option {
        case .rowsAtSection(let _viewModels, let section, let _isLast):
            var newModel = self.viewModels[section]
            let newCellModels = newModel.cellViewModels + _viewModels
            newModel.cellViewModels = newCellModels
            self.viewModels[section] = newModel
            showNoMoreData = _isLast || _viewModels.count == 0
        case .sections(let _viewModels, let _isLast):
            self.viewModels = self.viewModels + _viewModels
            showNoMoreData = _isLast || _viewModels.count == 0
        }
        
        return self.reloadTable().do(onNext: { _controller in
            if _controller.table.view.mj_footer.state == .refreshing {
                showNoMoreData ? _controller.table.view.mj_footer.endRefreshingWithNoMoreData() : _controller.table.view.mj_footer.endRefreshing()
            }
        })
    }
    
    private func reloadTable() -> Observable<DefaultTableController> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            if let weakSelf = self {
                weakSelf.table.reloadData(completion: {observer.onNext(weakSelf)})
            }else {
                observer.onError(NSError(domain: "table deinintd", code: 0, userInfo: nil))
            }
            return Disposables.create()
        })
    }
    
    func update(withOption option: TableNodeUpdateOption) -> Observable<DefaultTableController> {
//        switch option {
//        case .rowsAtSection(let viewModels, let section, let isLast):
//            break
//        case .sections(let viewModels, let isLast):
//            break
//        }
        return Observable.just(self)
    }
}

extension DefaultTableController: ASTableDataSource {
    
    public func numberOfSections(in tableNode: ASTableNode) -> Int {
        return self.viewModels.count
    }
    
    public func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.viewModels[section].cellViewModels.count
    }
    
    public func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return self.viewModels[indexPath.section].cellViewModels[indexPath.row].cellNodeBlock
    }
    
}

extension DefaultTableController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let identifier = self.viewModels[section].header?.viewClass.description(),
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
            else
        {return nil}
        return view
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard
            let identifier = self.viewModels[section].footer?.viewClass.description(),
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
            else
        {return nil}
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.viewModels[section].header?.height ?? 0.001
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.viewModels[section].footer?.height ?? 0.001
    }
}

extension DefaultTableController: ASTableDelegate {
    public func tableNode(_ tableNode: ASTableNode, willDisplayRowWith node: ASCellNode) {
        
    }
    
    public func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        self.viewModels[indexPath.section].cellViewModels[indexPath.row].performWhenSelect?(indexPath)
    }
}
