# PTBaseKit

原在公司git上, 因为与其他公司存在交接, 为了方便交流, 迁移一部分到Github

# 结构
```
PTBaseKit/
|
+- Application/
|  |
|  +- AppDelegate.swift <-- 执行了一个配置
|
+- Source/ <-- 源码
|  | |
|  +- UI <-- View和ViewController轮子
|  | |
|  | +- List <-- 列表封装(TableView)
|  | |
|  | +- Base <-- ViewController基类, View构造工厂
|  | |
|  | +- Web  <-- WKWebView的Hybrid界面
|  | .
|  | .
|  | .
|  +- Foundation <-- 基础数据处理轮子
|  |
|  +- Map <-- 地图业务协议
|  | .
|  | .
|  | .
|
+- Example/ <-- 用例
|  |
|  +- Views <-- demo用的UI组件
|  |
|  +- Map <-- 地图业务协议具体实现
|  |
|  +- Controllers <-- demo页面
```

 # TableContoller, CommonTableController
 
 TableController是针对列表功能抽象出来的协议, 与之关联的还有TableCell, TableSectionViewModel和TableCellViewModel协议. 整体上是一个MVVM的设计, 把TableCell的适配从Controller分离出来, TableController专注于Table的加载动作, TableCellViewModel用于中转Model->Cell的数据以及持有Cell的一些交互回调.
 
 thinker vc开发项目中的列表页面几乎都是`CommonTableController`类, 它遵守`TableController`协议, 内部通过TableView和RJRefresh组合成基本的上下拉加载, 另外提供简单的配置函数来给使用者对页面的顶部和底部添加UI组件, 以及数据为空时候的提示.
 
  - 使用者需要创建一个列表界面的时候可以直接使用`CommonTableController`, 它提供的接口可以应付大部分使用场景, 而且数据加载逻辑以及组件加载逻辑都经过 了thinker验证. 这样有利于避免创建多个ViewController带来的维护高成本和低代码复用.
  - 使用者也可以直接使用`PerformanceTableCell`, 它几乎兼容thinker目前所有列表的显示需要, 而且它使用了比较好理解的fram计算来实现layout. 这样除了提供不错的滑动性能, 也让使用者根据项目变更的情况较快修改, 比起ASDK这种滑动性能极佳可是又难上手的框架要好.
  - 专注`SectionViewModel/TableCellViewModel`的产生和变化, 它们以数组的形式传入`CommonTableController`, 根据数组中元素顺序的不同, `CommonTableController`的显示内容就会有相应变化.
 
 UIKitTableController.swift文件中有一个调用`CommonTableController`的例子:
 
 ```
 CommonTableController()
        .setupTableView(with: .sepratorStyle(.singleLine))
        .performWhenReload { (_table) in
            DispatchQueue.global()
                .rx_async(with: ())
                .flatMap { Observable.just(fakeFetchData()) }
                .flatMap { DispatchQueue.main.rx_async(with: $0) }
                .subscribe(onNext: { _table.reload(withSectionViewModels: $0) })
                .disposed(by: _table)
        }
        .performWhenLoadMore { (_table) in
            DispatchQueue.global()
                .rx_async(with: ())
                .flatMap { Observable.just(fakeFetchData()) }
                .flatMap { DispatchQueue.main.rx_async(with: $0) }
                .subscribe(onNext: { _table.loadMore(withSectionViewModels: $0, isLast: true) })
                .disposed(by: _table)
    }
 ```
 其中`performWhenReload`和`performWhenLoadMore`分别用于传入加载操作, 需要调用者自己结束加载. 回调闭包中有一个参数正是`CommonTableController`本身.
 
 
 
