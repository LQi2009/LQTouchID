//
//  LZTouchIDLock.swift
//  LZAccount-swift
//
//  Created by Artron_LQQ on 2016/10/9.
//  Copyright © 2016年 Artup. All rights reserved.
//

import UIKit
import LocalAuthentication
import AudioToolbox

let key_isTouchIDEnableeByUser = "key_isTouchIDEnableeByUser"

class LZTouchID {
    //解释校验指纹的原因
    var reasonThatExplainAuthentication: String
    //如果用户拒绝使用touchID解锁，则 显示提醒。
    var alertMessageToShowWhenUserDisableTouchID: String
    
    private var appName: String
    static let shared = LZTouchID.init()
    private init() {
        
        let infoDic = Bundle.main.infoDictionary
        
        let name = infoDic?["CFBundleName"]
        
        if let name = name {
            
            appName = "\(name)"
        } else {
            appName = "APP"
        }
        
        reasonThatExplainAuthentication = "通过验证指纹解锁\(appName)"
        alertMessageToShowWhenUserDisableTouchID = "请在\(appName)设置-开启TouchID指纹解锁"
    }
    
    // 保存用户配置: 用户是否想使用TouchID
    func saveTouchIdEnablebyUser(isEnable: Bool) {
        
        let ud = UserDefaults.standard
        ud.set(isEnable, forKey: key_isTouchIDEnableeByUser)
        
        ud.synchronize()
    }
    
    // 读取用户配置: 用户是否想使用TouchId
    func isTouchIdEnableByUser() -> Bool {
        
        let ud = UserDefaults.standard
        let enable = ud.object(forKey: key_isTouchIDEnableeByUser) as! Bool
        
        return enable
    }
    
    // iOS 操作系统 是否 支持TouchID解锁
    func isTouchIdEnableBySystem() -> Bool {
        
        let context = LAContext.init()
        var error: NSError?
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            if error == nil {
                // 支持
                return true
            } else {
                // 发生错误
                return false
            }
        } else {
            // 设备不支持
            return false
        }
    }
    // touchID 是否可用,系统支持且用户同意,才会返回true
    func isTouchIdEnable() -> Bool {
        
        let isSysteEnable = self.isTouchIdEnableBySystem()
        let isUserEnable = self.isTouchIdEnableByUser()
        
        if isSysteEnable && isUserEnable {
            
            return true
        } else {
            if isUserEnable == false {
                
                self.showAlert()
            }
            
            return false
        }
    }
    // 开始验证指纹
    func startVerifyTouchID(completion: @escaping ()-> Void) {
        
        let context = LAContext.init()
        var error: NSError?
        // 隐藏掉输入密码的按钮
        context.localizedFallbackTitle = ""
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            // 读取用户配置,用户是否想使用TouchID解锁
            let isEnableByUser = self.isTouchIdEnableByUser()
            
            if isEnableByUser == false {
                
                // 如果用户拒绝使用touchID解锁,则弹框提醒
                self.showAlert()
                return
            }
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonThatExplainAuthentication, reply: { (success, error) in
                
                if success == true {
                    
                    DispatchQueue.main.async {
                        
                        // 指纹验证成功
                        completion()
                    }
                } else {
                    
                    DispatchQueue.main.async {
                        
                        // 指纹验证失败
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    }
                }
            })
            
        } else {
            
            DispatchQueue.main.async {
                // 无法验证
            }
        }
    }
    
    private func showAlert() {
        
        let title = "未开启\(appName)指纹解锁"
        
        let alert = UIAlertController.init(title: title, message: alertMessageToShowWhenUserDisableTouchID, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "知道了", style: .default, handler: nil)
        alert.addAction(ok)
        
        let vc = UIApplication.shared.keyWindow?.rootViewController
        vc?.present(alert, animated: true, completion: nil)
    }
}
