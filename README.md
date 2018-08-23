# PTBaseKit

原在公司git上, 因为与其他公司存在交接, 为了方便交流, 迁移一部分到Github

# 结构
```
chinese-xinhua/
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
