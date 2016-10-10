# LZTouchID
对touchID的简单封装--Swift 3.0
<br>之前用了一个OC版本的封装,感觉还不错,现在用swift语言改写一遍,简单的封装了一下
#使用
使用非常简单,只需简单的调用几个方法即可

获取单例对象
```swift
LZTouchID.shared
```

保存用户配置,是否想使用TouchID 
```swift
func saveTouchIdEnablebyUser(isEnable: Bool)
```
读取用户配置
```swift
func isTouchIdEnableByUser() -> Bool
```
判断操作系统是否支持TouchID
```swift
func isTouchIdEnableBySystem() -> Bool
```
TouchID是否可用: 系统设备支持,用户启用
```swift
func isTouchIdEnable() -> Bool
```
开始验证
```swift
func startVerifyTouchID(completion: @escaping ()-> Void) 
```
示例:
```swift
@IBAction func useTouchID(_ sender: UISwitch) {
        // 设置用户选择
        LZTouchID.shared.saveTouchIdEnablebyUser(isEnable: sender.isOn)
    }
    
    @IBAction func verifyTouchID(_ sender: UIButton) {
        // 判断是否可用
        if LZTouchID.shared.isTouchIdEnable() {
            // 开始验证
            LZTouchID.shared.startVerifyTouchID {
                // 验证成功
                print("Success")
            }
        }
    }
```
