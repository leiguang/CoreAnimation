//
//  AdvancedAnimationTricks_CATransition_ViewController.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/20.
//  Copyright © 2018年 雷广. All rights reserved.
//


// [Advanced Animation Tricks]

// [Transition Animations Support Changes to Layer Visibility]
// (本页关于CATransition的示例)

// 当两个图层涉及相同的转换时，您可以为两者使用相同的转换对象。 使用相同的转换对象还可以简化必须编写的代码。 但是，您可以使用不同的转换对象，并且如果每个图层的转换参数不同，则肯定会这样做。
// When two layers are involved in the same transition, you can use the same transition object for both. Using the same transition object also simplifies the code you have to write. However, you can use different transition objects and would definitely need to do so if the transition parameters for each layer are different.

/**
 CATransition 提供了 4种过渡样式 + 4种过渡方向
    样式：kCATransitionFade、kCATransitionMoveIn、kCATransitionPush、kCATransitionReveal。
    方向：kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom。
 */

/**
 经试验发现 type=kCATransitionPush, subtype=kCATransitionFromLeft时, 过渡前后v1的isHidden属性不同 则效果不同
 1.不隐藏->隐藏： 从v1的原点起，向右推出，淡出效果；
 2.隐藏->不隐藏： 从v1左边偏移一个v1宽度的地方起，向右推入，淡入效果。
 正式因为这种不同，所以可以达到 transition_push() 方法中推箱子的效果
 */


import UIKit

class AdvancedAnimationTricks_CATransition_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        fade()
        transition_fade()   // 1.淡入淡出效果
        
        moveIn()
        transition_moveIn() // 2.移入效果
        
        push()
        transition_push()   // 3.推箱子效果 (这里是两个layer使用的同一个CATransition对象，如果是相同的简单layer，可参照5中pushText方法 只使用一个layer达到效果)
        
        reveal()
        transition_reveal() // 4.reveal效果
        
        pushText()          // 5.push文字效果 (只使用了一个layer实现3中推箱子效果)
    }
    
    
    // MARK: - Animating a transition between two views in iOS
    
    
    // MARK: - 1.kCATransitionFade
    func fade() {
        let v1 = UIView(frame: CGRect(x: 80, y: 100, width: 60, height: 60))
        v1.backgroundColor = .red
        view.addSubview(v1)
        
        // 延迟1s执行，否则看不出效果
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            // CATransition inherit from CAAnimation
            let transition = CATransition()
            transition.startProgress = 0    // 动画起始点(默认是 0)
            transition.endProgress = 1.0    // 动画结束点(默认是 1)
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
            transition.type = kCATransitionFade
            transition.duration = 1.0
            
            v1.layer.add(transition, forKey: nil)
            v2.layer.add(transition, forKey: nil)
            
            v1.isHidden = true
            v2.isHidden = false
        }
    }
    
    // MARK: - 2.kCATransitionMoveIn
    func moveIn() {
        let v1 = UIView(frame: CGRect(x: 80, y: 250, width: 60, height: 60))
        v1.backgroundColor = .red
        view.addSubview(v1)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let transition = CATransition()
            transition.type = kCATransitionMoveIn
            transition.subtype = kCATransitionFromLeft
            transition.duration = 1.0
            
            v1.layer.add(transition, forKey: nil)
            
//            v1.isHidden = true    // 添加此句可观察moveIn不同的效果
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
            transition.type = kCATransitionMoveIn
            transition.subtype = kCATransitionFromLeft
            transition.duration = 1.0
            
            v1.layer.add(transition, forKey: nil)
            v2.layer.add(transition, forKey: nil)
            
            v1.isHidden = true
            v2.isHidden = false
        }
    }
    
    // MARK: - 3.kCATransitionPush
    func push() {
        let v1 = UIView(frame: CGRect(x: 80, y: 400, width: 60, height: 60))
        v1.backgroundColor = .red
        view.addSubview(v1)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let transition = CATransition()
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            transition.duration = 1.0
            v1.layer.add(transition, forKey: nil)
            
//            v1.isHidden = true  // 添加此句可观察push不同的效果
            /**
             经试验发现 type=kCATransitionPush, subtype=kCATransitionFromLeft时, 过渡前后v1的isHidden属性不同 则效果不同
                1.不隐藏->隐藏： 从v1的原点起，向右推出，淡出效果；
                2.隐藏->不隐藏： 从v1左边偏移一个v1宽度的地方起，向右推入，淡入效果。
             正式因为这种不同，所以可以达到 transition_push() 方法中推箱子的效果
             */
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
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            transition.duration = 1.0
            
            v1.layer.add(transition, forKey: nil)
            v2.layer.add(transition, forKey: nil)
            
            v1.isHidden = true
            v2.isHidden = false
        }
    }
    

    // MARK: - 4.kCATransitionReveal
    func reveal() {
        let v1 = UIView(frame: CGRect(x: 80, y: 550, width: 60, height: 60))
        v1.backgroundColor = .red
        view.addSubview(v1)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let transition = CATransition()
            transition.type = kCATransitionReveal
            transition.subtype = kCATransitionFromLeft
            transition.duration = 1.0
            
            v1.layer.add(transition, forKey: nil)
            
//            v1.isHidden = true  // 添加此句观察reveal不同的的效果
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
            transition.type = kCATransitionReveal
            transition.subtype = kCATransitionFromLeft
            transition.duration = 1.0
            
            v1.layer.add(transition, forKey: nil)
            v2.layer.add(transition, forKey: nil)
            
            v1.isHidden = true
            v2.isHidden = false
        }
    }
    
    // MARK: - 5. push text
    func pushText() {
        let layer = CATextLayer()
        layer.frame = CGRect(x: 100, y: 650, width: 200, height: 50)
        view.layer.addSublayer(layer)
        // Initial "red" state
        layer.backgroundColor = UIColor.red.cgColor
        layer.string = "Red"
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let transition = CATransition()
            transition.duration =  2
            transition.type = kCATransitionPush
            layer.add(transition, forKey: nil)
            
            
            // Transition to "blue" state
            layer.backgroundColor = UIColor.blue.cgColor
            layer.string = "Blue"
        }
    }
}

