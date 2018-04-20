//
//  CAReplicatorLayer3_ViewController.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/4/13.
//  Copyright © 2018年 雷广. All rights reserved.
//

import UIKit

class CAReplicatorLayer3_ViewController: UIViewController {
    
    let layer = CALayer()
    let duration: CFTimeInterval = 0.25
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 仿下拉刷新

        layer.frame = CGRect(x: 100, y: 200, width: 36, height: 36)
        layer.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor
        view.layer.addSublayer(layer)
        
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.fromValue = 0
        anim.toValue = Float.pi
        anim.duration = duration
        anim.repeatCount = Float.greatestFiniteMagnitude
        layer.add(anim, forKey: "rotation")
        // 暂停动画
        layer.speed = 0
        
        
        // UISlider
        let slider = UISlider(frame: CGRect(x: 50, y: 400, width: view.bounds.width - 100, height: 30))
        slider.addTarget(self, action: #selector(tapSlider), for: .valueChanged)
        view.addSubview(slider)
    }
    
    @objc func tapSlider(_ sender: UISlider) {
        if sender.value < 0.6 { // 拖动旋转
            layer.speed = 0
            layer.timeOffset = Double(Double(sender.value) / 0.6 * duration)
            
        } else {                // 自动旋转
            layer.speed = 1
        }
    }
}


