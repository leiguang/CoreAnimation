//
//  AdvancedAnimationTricks_CAMediaTiming_ViewController.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/21.
//  Copyright © 2018年 雷广. All rights reserved.
//

// [Advanced Animation Tricks]

// [Customizing the Timing of an Animation]
// (本页关于控制动画时间)

// >> 参考 [CoreAnimation动画时间控制](http://blog.csdn.net/u013282174/article/details/51605403#begintime)
// >> [关于贝塞尔曲线的公式和表现形式](http://en.wikipedia.org/wiki/Bezier_curve)

/**
 CAMediaTiming协议:
 
    beginTime: 设置为CACurrentMediaTime() + 1s 即动画开始时间为当前时间延后1s。
 
    fillMode: 如果要让动画在开始之前（延迟的这段时间内）显示fromValue的状态，你可以设置动画向后填充：设置fillMode为kCAFillModeBackwards。
 
    autoreverses: 将使动画先正常走，完了以后反着从结束值回到起始值（所有动画属性都会反过来，比如动画速度，如果正常的是先快后慢，则反过来后变成先慢后快）。
 
    repeatCount: 相比之下，repeatCount可以让动画重复执行两次（首次动画结束后再执行一次，正如你下面将看到的）或者任意多次（你甚至可以将重复次数设置为小数，比如设置为1.5，这样第二次动画只执行到一半）。一旦动画到达结束值，它将立即返回到起始值并且重新开始。
 
    repeatDuration: 类似于repeatCount，但是极少会使用。它简单地在给定的持续时间内重复执行动画（下面设置为2秒）。如果repeatDuration比动画持续时间小，那么动画将提前结束（repeatDuration到达后就结束）
 
    speed: 如果把动画的duration设置为3秒，而speed设置为2，动画将会在1.5秒结束，因为它以两倍速在执行。(注意：动画速度speed是有层级关系的，一个动画的speed为1.5，它同时是一个speed为2的动画组的一个动画成员，则它将以3倍速度被执行。)
 
    timeOffset: 动画时间偏移量，单位:秒数。
                假如一个动画，duration=3，原始的效果是从红变绿，现在设置timeOffset=1，那么这个动画将从正常动画（timeOffset为0的状态）的第1秒开始执行，直到2秒后它完全变绿，然后它一下子跳回最开始的状态（红色）再执行1秒。就像是我们把正常动画的第1秒给剪下来粘贴到动画最后一样。timeOffset可以偏移整个动画, 但是动画还是会走完全部过程。
                这个属性实际上并不会自己单独使用，而会结合一个暂停动画（speed=0）一起使用来控制动画的“当前时间”。暂停的动画将会在第一帧卡住，然后通过改变timeOffset来随意控制动画进程，因为如上图所示，动画的第一帧就是timeOffset指定的那一帧。
 */

/**
 CAMediaTiming协议的其他实现
 
 CAAnimation实现了CAMediaTiming协议，然而CoreAnimation最基本的类：CALayer也实现了CAMediaTiming协议。这意味着你可以给一个CALayer设置speed为2，那么所有加到它上面的动画都将以两倍速执行。这同样符合动画时间层级，比如你把一个speed为3的动画加到一个speed为0.5的layer上，则这个动画将以1.5倍速度执行。
 
 控制动画和layer的速度同样可以用来暂停动画，你只需要把speed设为0就行了。结合timeOffset属性，就可以通过一个外部的控制器（比如一个UISlider）来控制动画了，我们将在这一章较后的内容中进行讲解。
 
 */


/**
 
 应该使用如下方法来获取图层当前的本地时间:
 let localLayerTime = layer.convertTime(CACurrentMediaTime(), from: nil)
 
 为了帮助您确保给定图层的时间值合适，CALayer类定义了convertTime：fromLayer：和convertTime：toLayer：方法。您可以使用这些方法将固定时间值转换为图层的本地时间，或将时间值从一层转换为另一层。这些方法考虑了可能影响图层本地时间的媒体定时属性，并返回可用于其他图层的值。清单5-3显示了一个例子，您应该经常使用它来获取图层的当前本地时间。 CACurrentMediaTime函数是一个方便的函数，它返回计算机当前的时钟时间，该方法将其转换为图层的本地时间。
 
 To assist you in making sure time values are appropriate for a given layer, the CALayer class defines the convertTime:fromLayer: and convertTime:toLayer: methods. You can use these methods to convert a fixed time value to the local time of a layer or to convert time values from one layer to another. The methods take into account the media timing properties that might affect the local time of the layer and return a value that you can use with the other layer. Listing 5-3 shows an example that you should use regularly to get the current local time for a layer. The CACurrentMediaTime function is a convenience function that returns the computer’s current clock time, which the method takes and converts to the layer’s local time.
 
 */

import UIKit

class AdvancedAnimationTricks_CAMediaTiming_ViewController: UIViewController {

    let redLayer = CALayer()
    let colorLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startOrStopAnim()   // 开始/暂停 动画
        changeColorAnim()   // 手动控制动画颜色
        
        beginTime()
        timeOffset()
    }

    // MARK: - 开始/暂停 动画
    // 开关按钮
    func startOrStopAnim() {
        // 开关按钮
        let button = UISwitch()
        button.center = CGPoint(x: 50, y: 150)
        button.isOn = true
        button.addTarget(self, action: #selector(tapSwitch), for: UIControlEvents.valueChanged)
        view.addSubview(button)
        // 红色方块
        redLayer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        redLayer.position = CGPoint(x: 150, y: 150)
        redLayer.backgroundColor = UIColor.red.cgColor
        view.layer.addSublayer(redLayer)
        //位移动画
        let anim = CABasicAnimation(keyPath: "position")
        anim.fromValue = CGPoint(x: 150, y: 150)
        anim.toValue = CGPoint(x: 300, y: 150)
        anim.duration = 2
        anim.autoreverses = true
        anim.repeatCount = Float.greatestFiniteMagnitude
        
        redLayer.add(anim, forKey: nil)
    }
    
    // 开始/暂停 动画
    @objc func tapSwitch(_ sender: UISwitch) {
        if sender.isOn {    // 开启动画
            let pausedTime = redLayer.timeOffset
            redLayer.speed = 1.0           // 1.
            redLayer.timeOffset = 0.0      // 2.
            redLayer.beginTime = 0.0       // 3. 需要设置这三步，来确保convertTime转换的时间正确
            let timeSincePause = redLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            redLayer.beginTime = timeSincePause
            
            print(timeSincePause)
            
        } else {            // 暂停动画
            let pausedTime = redLayer.convertTime(CACurrentMediaTime(), from: nil)
            redLayer.speed = 0.0
            redLayer.timeOffset = pausedTime
        }
        
        // 我还没有理解对这段代码每一步的含义，参考自苹果文档：[Core Animation Programming Guide -> Advanced Animation Tricks -> Pausing and Resuming Animations](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreAnimation_guide/AdvancedAnimationTricks/AdvancedAnimationTricks.html#//apple_ref/doc/uid/TP40004514-CH8-SW1)
        // 另外可参考文章 (https://blog.csdn.net/xiaolinyeyi/article/details/51736907)
    }
    
    
    // MARK: - 手动控制动画颜色
    func changeColorAnim() {
        // 颜色可调整的color layer
        colorLayer.bounds = CGRect(x: 0, y: 0, width: 250, height: 100)
        colorLayer.position = CGPoint(x: 200, y: 350)
        colorLayer.backgroundColor = UIColor.orange.cgColor
        view.layer.addSublayer(colorLayer)
        // 滑动条
        let slider = UISlider(frame: CGRect(x: 75, y: 420, width: 250, height: 30))
        slider.addTarget(self, action: #selector(tapSlider), for: .valueChanged)
        view.addSubview(slider)
        // 颜色动画
        let anim = CABasicAnimation(keyPath: "backgroundColor")
        anim.fromValue = UIColor.orange.cgColor
        anim.toValue = UIColor.blue.cgColor
        anim.duration = 1.0
        colorLayer.add(anim, forKey: nil)
        // 暂停动画
        colorLayer.speed = 0.0
    }

    @objc func tapSlider(_ sender: UISlider) {
        colorLayer.timeOffset = Double(sender.value * 1.0)  // slider.value * 动画duration.   (注：timeOffset/duration 表示动画进行的百分比)
    }
    
    // MARK: - beginTime (观察beginTime属性)
    func beginTime() {
        let layer = CALayer()
        layer.frame = CGRect(x: 50, y: 500, width: 100, height: 100)
        layer.backgroundColor = UIColor.green.cgColor
        view.layer.addSublayer(layer)
        
        let anim = CABasicAnimation(keyPath: "bounds")
        anim.fromValue = CGRect(x: 0, y: 0, width: 100, height: 100)
        anim.toValue = CGRect(x: 0, y: 0, width: 50, height: 50)
        anim.duration = 3.0
        anim.beginTime = layer.convertTime(CACurrentMediaTime(), from: nil) + 1.0   // // 或者放进CAAnimationGroup中，直接设为1
        layer.add(anim, forKey: nil)
    }
    
    // MARK: - timeOffset (观察timeOffset属性)
    func timeOffset() {
        let layer = CALayer()
        layer.frame = CGRect(x: 200, y: 500, width: 100, height: 100)
        layer.backgroundColor = UIColor.green.cgColor
        view.layer.addSublayer(layer)
        
        let anim = CABasicAnimation(keyPath: "bounds")
        anim.fromValue = CGRect(x: 0, y: 0, width: 100, height: 100)
        anim.toValue = CGRect(x: 0, y: 0, width: 50, height: 50)
        anim.duration = 3.0
        anim.timeOffset = 2.0

        layer.add(anim, forKey: nil)
    }
}


