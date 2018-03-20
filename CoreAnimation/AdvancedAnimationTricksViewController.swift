//
//  AdvancedAnimationTricksViewController.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/20.
//  Copyright © 2018年 雷广. All rights reserved.
//


// [Advanced Animation Tricks]


// 当两个图层涉及相同的转换时，您可以为两者使用相同的转换对象。 使用相同的转换对象还可以简化必须编写的代码。 但是，您可以使用不同的转换对象，并且如果每个图层的转换参数不同，则肯定会这样做。
// When two layers are involved in the same transition, you can use the same transition object for both. Using the same transition object also simplifies the code you have to write. However, you can use different transition objects and would definitely need to do so if the transition parameters for each layer are different.


import UIKit

class AdvancedAnimationTricksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        fade()
        transition_fade()
        
        moveIn()
        transition_moveIn()
        
        push()
        transition_push()
        
        reveal()
        transition_reveal()
    }
    
    
    // MARK: - Animating a transition between two views in iOS
    
    
    // MARK: - kCATransitionFade
    func fade() {
        let v1 = UIView(frame: CGRect(x: 80, y: 100, width: 60, height: 60))
        v1.backgroundColor = .red
        view.addSubview(v1)
        
        // 延迟1s执行，否则看不出效果
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            // CATransition inherit from CAAnimation
            let transition = CATransition()
            transition.startProgress = 0    // 动画起始点
            transition.endProgress = 1.0    // 动画结束点
            transition.type = kCATransitionFade // 指定过渡效果的类型。
            //            transition.subtype = kCATransitionFromRight   // 指定过渡方向(Optional) 。（当过渡类型是kCATransitionFade时，"subtype"参数无效）
            transition.duration = 1.0
            
            // Add the transition animation to both layers
            v1.layer.add(transition, forKey: nil)
            
            // Finally, change the visibility of the layers.
            v1.isHidden = true
        }
    }
    
    func transition_fade() {
        let v1 = UIView(frame: CGRect(x: 240, y: 100, width: 60, height: 60))
        v1.backgroundColor = .red
        view.addSubview(v1)
        
        let v2 = UIView(frame: CGRect(x: 240, y: 100, width: 60, height: 60))
        v2.backgroundColor = .green
        v2.isHidden = true
        view.addSubview(v2)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            let transition = CATransition()
            transition.startProgress = 0
            transition.endProgress = 1.0
            transition.type = kCATransitionFade
            transition.duration = 1.0
            
            v1.layer.add(transition, forKey: nil)
            v2.layer.add(transition, forKey: nil)
            
            v1.isHidden = true
            v2.isHidden = false
        }
    }
    
    // MARK: - kCATransitionMoveIn
    func moveIn() {
        let v1 = UIView(frame: CGRect(x: 80, y: 250, width: 60, height: 60))
        v1.backgroundColor = .red
        view.addSubview(v1)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let transition = CATransition()
            transition.startProgress = 0
            transition.endProgress = 1.0
            transition.type = kCATransitionMoveIn
            transition.subtype = kCATransitionFromLeft
            transition.duration = 1.0
            
            v1.layer.add(transition, forKey: nil)
            
            v1.isHidden = true
        }
    }
    
    func transition_moveIn() {
        let v1 = UIView(frame: CGRect(x: 240, y: 250, width: 60, height: 60))
        v1.backgroundColor = .red
        view.addSubview(v1)
        
        let v2 = UIView(frame: CGRect(x: 240, y: 250, width: 60, height: 60))
        v2.backgroundColor = .green
        v2.isHidden = true
        view.addSubview(v2)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            let transition = CATransition()
            transition.startProgress = 0
            transition.endProgress = 1.0
            transition.type = kCATransitionMoveIn
            transition.subtype = kCATransitionFromLeft
            transition.duration = 1.0
            
            v1.layer.add(transition, forKey: nil)
            v2.layer.add(transition, forKey: nil)
            
            v1.isHidden = true
            v2.isHidden = false
        }
    }
    
    // MARK: - kCATransitionPush
    func push() {
        let v1 = UIView(frame: CGRect(x: 80, y: 400, width: 60, height: 60))
        v1.backgroundColor = .red
        view.addSubview(v1)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let transition = CATransition()
            transition.startProgress = 0
            transition.endProgress = 1.0
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            transition.duration = 1.0
            
            v1.layer.add(transition, forKey: nil)
            
            v1.isHidden = true
        }
    }
    
    func transition_push() {
        let v1 = UIView(frame: CGRect(x: 240, y: 400, width: 60, height: 60))
        v1.backgroundColor = .red
        view.addSubview(v1)
        
        let v2 = UIView(frame: CGRect(x: 240, y: 400, width: 60, height: 60))
        v2.backgroundColor = .green
        v2.isHidden = true
        view.addSubview(v2)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            let transition = CATransition()
            transition.startProgress = 0
            transition.endProgress = 1.0
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            transition.duration = 1.0
            
            v1.layer.add(transition, forKey: nil)
            v2.layer.add(transition, forKey: nil)
            
            v1.isHidden = true
            v2.isHidden = false
        }
    }
    

    // MARK: - kCATransitionReveal
    func reveal() {
        let v1 = UIView(frame: CGRect(x: 80, y: 550, width: 60, height: 60))
        v1.backgroundColor = .red
        view.addSubview(v1)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let transition = CATransition()
            transition.startProgress = 0
            transition.endProgress = 1.0
            transition.type = kCATransitionReveal
            transition.subtype = kCATransitionFromLeft
            transition.duration = 1.0
            
            v1.layer.add(transition, forKey: nil)
            
            v1.isHidden = true
        }
    }
    
    func transition_reveal() {
        let v1 = UIView(frame: CGRect(x: 240, y: 550, width: 60, height: 60))
        v1.backgroundColor = .red
        view.addSubview(v1)
        
        let v2 = UIView(frame: CGRect(x: 240, y: 550, width: 60, height: 60))
        v2.backgroundColor = .green
        v2.isHidden = true
        view.addSubview(v2)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            let transition = CATransition()
            transition.startProgress = 0
            transition.endProgress = 1.0
            transition.type = kCATransitionReveal
            transition.subtype = kCATransitionFromLeft
            transition.duration = 1.0
            
            v1.layer.add(transition, forKey: nil)
            v2.layer.add(transition, forKey: nil)
            
            v1.isHidden = true
            v2.isHidden = false
        }
    }
}

