# LZTouchID
对touchID的简单封装--Swift 3.0
之前用了一个OC版本的封装,感觉还不错,现在用swift语言改写一遍,简单的封装了一下
#使用
使用非常简单,只需简单的调用几个方法即可

获取单例对象
```
LZTouchID.shared
```

保存用户配置,是否想使用TouchID 
```
func saveTouchIdEnablebyUser(isEnable: Bool)
```
读取用户配置
```
func isTouchIdEnableByUser() -> Bool
```
判断操作系统是否支持TouchID
```
func isTouchIdEnableBySystem() -> Bool
```
TouchID是否可用: 系统设备支持,用户启用
```
func isTouchIdEnable() -> Bool
```
开始验证
```
func startVerifyTouchID(completion: @escaping ()-> Void) 
```
