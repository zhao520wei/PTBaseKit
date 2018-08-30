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

 # 模块介绍: TableContoller & CommonTableController
 
 TableController是针对列表功能抽象出来的协议, 与之关联的还有TableCell和TableCellViewModel协议.
 thinker vc开发项目中的列表页面几乎都是CommonTableController类, 它遵守TableController协议, 内部通过TableView和RJRefresh组合成基本的上下拉加载, 另外提供简单的配置函数来给使用者对页面的顶部和底部添加UI组件, 以及数据为空时候的提示.
 
 
 
 
 
 
 
 
