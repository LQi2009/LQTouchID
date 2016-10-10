//
//  ViewController.swift
//  LZTouchID
//
//  Created by Artron_LQQ on 2016/10/10.
//  Copyright © 2016年 Artup. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var ws: UISwitch!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 如果系统支持,则显示验证touchID的按钮开关
        if LZTouchID.shared.isTouchIdEnableBySystem() {
            
            label.isHidden = true
            ws.isHidden = false
            idLabel.isHidden = false
            
            // 设置开关的状态
            ws.isOn = LZTouchID.shared.isTouchIdEnableByUser()
            
        } else {
            
            label.isHidden = false
            ws.isHidden = true
            idLabel.isHidden = true
        }
    }

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

