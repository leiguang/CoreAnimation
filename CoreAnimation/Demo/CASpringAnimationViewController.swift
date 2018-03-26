//
//  CASpringAnimationViewController.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/26.
//  Copyright © 2018年 雷广. All rights reserved.
//

// MARK: - [CASpringAnimation]

/**
 一种动画，将类似弹簧的力施加到图层的属性上。
 您通常会使用弹簧动画来为一个图层的位置设置动画，以使其看起来像是被弹簧拉向目标。 layer离目标越远，加速度越大。
 CASpringAnimation允许控制基于物理的属性，如弹簧的阻尼和刚度。
 您可以使用弹簧动画来对其位置以外的图层的属性进行动画。 清单1显示了如何创建一个弹簧动画，通过将其图层的缩放比例从0跳转到1，从而将图层弹入视图。由于弹簧动画可能超过其toValue，因此动画图层可能会超出其框架。
 Overview
 You would typically use a spring animation to animate a layer's position so that it appears to be pulled towards a target by a spring. The further the layer is from the target, the greater the acceleration towards it is.
 CASpringAnimation allows control over physically based attributes such as the spring's damping and stiffness.
 You can use a spring animation to animation properties of a layer other than its position. Listing 1 shows how to create a spring animation that bounces a layer into view by animating its scale from 0 to 1. Because the spring animation can overshoot its toValue, the animated layer may exceed its frame.
 
 */

import UIKit

class CASpringAnimationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        demo()
        
    }
    
    func demo() {
        let layer = CALayer()
        layer.frame = CGRect(x: 200, y: 200, width: 100, height: 100)
        layer.backgroundColor = UIColor.red.cgColor
        view.layer.addSublayer(layer)

        let anim = CASpringAnimation(keyPath: "transform.scale")
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 3
        
//        anim.damping = 1    // 默认是10，值越大，阻尼越大，弹性越小
//        anim.initialVelocity = 0   // 默认为0，表示一个不动的对象。负值表示物体远离弹簧连接点，正值表示物体朝弹簧连接点移动。
//        anim.mass = 10    // 默认是1，连接到弹簧末端的物体的质量。增大此值将增加弹簧效应
//        anim.stiffness = 100     // 默认值100，弹簧刚度系数。增大此值将减少震荡次数 (效果咋和API Reference描述的不同啊...)
//        print(anim.settlingDuration)    // 弹簧系统被认为处于静止状态所需的预计持续时间，受其他属性影响。
        
        layer.add(anim, forKey: nil)
    }
}
