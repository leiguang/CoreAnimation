//
//  CADisplayLink_ViewController.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/27.
//  Copyright © 2018年 雷广. All rights reserved.
//

// [CADisplayLink]
/**
 
 特别注意：CADisplayLink的创建函数 init(target: Any, selector: Selector) 中会强引用target，解决方法见下面的demo代码。
 
 
 一个计时器对象，允许您的应用程序将其绘图与显示器的刷新速率同步。可用来制作一个简单的显示当前画面帧率的label. [FPSLabel](https://github.com/leiguang/FPSLabel)
 A timer object that allows your application to synchronize its drawing to the refresh rate of the display.
 
 

 
 你的应用程序初始化一个新的display link，提供一个target和一个selector，当屏幕更新时被调用。要使显示器循环与显示器同步，应用程序会使用add（to：forMode :)方法将其添加到run loop中。
 
 一旦display link与run loop相关联，当屏幕内容需要更新时，target上的selector将被调用。target可以读取display link的timestamp属性以检索前一帧的显示时间。例如，显示电影的应用程序可能会使用时间戳来计算下一个要显示的视频帧。执行自己的动画的应用程序可能会使用时间戳来确定显示的对象在即将到来的帧中的显示位置和方式。
 
 duration属性提供了maximumFramesPerSecond帧之间的时间量。要计算实际的帧持续时间，请使用targetTimestamp - timestamp。您可以在应用程序中使用此值来计算显示器的帧速率，下一帧将显示的大致时间，并调整绘图行为，以便及时准备下一帧以供显示。
 
 您的应用程序可以通过将isPaused属性设置为true来禁用通知。另外，如果您的应用程序无法在所提供的时间内提供帧，您可能需要选择较慢的帧速率。与跳过帧的应用程序相比，具有较慢但一致帧频的应用程序对用户来说会更平滑。您可以通过设置preferredFramesPerSecond属性来定义每秒的帧数。
 
 当你的应用程序完成display link时，它应该调用invalidate()将其从所有run loop中删除，并将其从目标中解除关联。
 
 Overview
 Your application initializes a new display link, providing a target object and a selector to be called when the screen is updated. To synchronize your display loop with the display, your application adds it to a run loop using the add(to:forMode:) method.
 
 Once the display link is associated with a run loop, the selector on the target is called when the screen’s contents need to be updated. The target can read the display link’s timestamp property to retrieve the time that the previous frame was displayed. For example, an application that displays movies might use the timestamp to calculate which video frame will be displayed next. An application that performs its own animations might use the timestamp to determine where and how displayed objects appear in the upcoming frame.
 
 The duration property provides the amount of time between frames at the maximumFramesPerSecond. To calculate the actual frame duration, use targetTimestamp - timestamp. You can use this value in your application to calculate the frame rate of the display, the approximate time that the next frame will be displayed, and to adjust the drawing behavior so that the next frame is prepared in time to be displayed.
 
 Your application can disable notifications by setting the isPaused property to true. Also, if your application cannot provide frames in the time provided, you may want to choose a slower frame rate. An application with a slower but consistent frame rate appears smoother to the user than an application that skips frames. You can define the number of frames per second by setting the preferredFramesPerSecond property.
 
 When your application finishes with a display link, it should call invalidate() to remove it from all run loops and to disassociate it from the target.
 
 
 
 CADisplayLink不应该被子类化。
 
 首选和实际帧率
 您可以通过设置其preferredFramesPerSecond来控制display link的帧速率，即每秒调用其target的selector的次数。但是，每秒的实际帧数可能与您设置的首选值不同：如实际帧速率不会超过设备最大刷新速率。
 
 例如，如果设备的最大刷新率为每秒60帧（由maximumFramesPerSecond定义），则实际帧速率包括每秒15,20,30和60帧。如果您将显示链接的首选帧速率设置为高于最大值的值，则实际帧速率为最大值。
 
 优选的帧速率不是最大帧速率的除数，而是被舍入到最接近的因子。例如，在具有60帧/秒的最大刷新速率的设备上将首选帧速率设置为26或35帧每秒, 会产生每秒30次的实际帧速率。
 
 CADisplayLink should not be subclassed.
 
 Preferred and Actual Frame Rates
 You can control a display link's frame rate, i.e. the number of times the specified selector of its target is called per second, by setting its preferredFramesPerSecond. However, the actual frames per second may differ from the preferred value you set: actual frame rates are always a factor of the maximum refresh rate of the device.
 
 For example, if your device's maximum refresh rate is 60 frames per second (defined by maximumFramesPerSecond), actual frame rates include 15, 20, 30, and 60 frames per second. If you set a display link's preferred frame rate to a value higher than the maximum, the actual frame rate is the maximum.
 
 Preferred frame rates than are not a divisor of the maximum frame rate are rounded to the nearest factor. For example, setting a preferred frame rate to either 26 or 35 frames per second on a device with a maximum refresh rate of 60 frames per second yields an actual frame rate of 30 times per second.
 
 */

/**
 CADisplayLink的属性：
 1. perferredFramesPerSecond:
     当您在显示链接上指定每秒首选帧数时，它会根据硬件上的功能以及您的游戏或应用可能正在执行的其他任务，以尽可能接近的速率通知目标。 所选的实际帧速率通常是屏幕刷新率的一个因素，以提供一致的帧速率。 例如，如果屏幕的最大刷新率是每秒60帧，那么也是显示链路设置为实际帧速率的最高帧速率。 但是，如果要求较低的帧速率，则显示链接可能会选择每秒30,20或15帧或另一种速率作为实际帧速率。
     您的应用程序应该选择可以始终保持的帧速率。 默认值是每秒60帧。
     When you specify a preferred frames per second on a display link, it notifies the target at a rate as close as possible based on the capabilities on the hardware and other tasks your game or app may be executing. The actual frame rate chosen is usually a factor of the maximum refresh rate of the screen to provide a consistent frame rate. For example, if the maximum refresh rate of the screen is 60 frames per second, that is also the highest frame rate the display link sets as the actual frame rate. However, if you ask for a lower frame rate, the display link might choose 30, 20, or 15 frames per second, or another rate, as the actual frame rate.
     Your application should choose a frame rate that it can consistently maintain. The default value is 60 frames per second.
 
 
 2. isPaused:
     一个布尔值，用于说明display link对target的通知是否被暂停。
     默认值是false。 如果为true，则显示链接不会向目标发送通知。”isPaused“是线程安全的，这意味着它可以从独立于display link正在运行的线程中设置。
     The default value is false. If true, the display link does not send notifications to the target.
     isPaused is thread safe meaning that it can be set from a thread separate to the one in which the display link is running.
 
 3. duration: 屏幕刷新更新之间的时间间隔。
 3. timestamp: 最后一帧显示的时间值。
 4. targetTimestamp: 下一帧显示的时间值，在iOS 10.0以后才可用。
 
 */


/**
 
 注意 "func invalidate()" 函数的描述，调用invalidate时，会把display link从所有 run loop modes中移除，导致display link被run loop释放。所以display link也会释放它强引用的target。所以适时地调用invalidate(), 也可以避免循环引用。
 Description:
    Removes the display link from all run loop modes.
    Removing the display link from all run loop modes causes it to be released by the run loop. The display link also releases the target.
    invalidate() is thread safe meaning that it can be called from a thread separate to the one in which the display link is running.
 
 */

import UIKit

class CADisplayLink_ViewController: UIViewController {
    
    var displaylink: CADisplayLink?
    
    /// Proxy objct for prevending a reference cycle between the CADisplayLink and CADisplayLink_ViewController.
    class TargetProxy {

        private weak var target: CADisplayLink_ViewController?
        
        init(target: CADisplayLink_ViewController) {
            self.target = target
        }
        
        @objc func onTick(link: CADisplayLink) {
            target?.step(displaylink: link)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 注意：这3个demo都应使用TargetProxy对象来避免循环引用，这里只在demo1中做了一个示例
        
        // 通过中间对象TargetProxy 并在deinit中调用displayLink.invalidate() 来避免循环引用
        demo1()
        
        // 通过iOS 10以后的方法计算帧率
//        demo2()
        
        // 找出计算的耗时 超过屏幕下次刷新时刻 的i值
//        demo3()
    }

    
    // MARK: - demo1 - Creating a display link
    func demo1() {
        displaylink = CADisplayLink(target: TargetProxy(target: self) , selector: #selector(TargetProxy.onTick))
        displaylink?.add(to: .current, forMode: .defaultRunLoopMode)
    }
    
    @objc func step(displaylink: CADisplayLink) {
        print(displaylink.timestamp)    // "timestamp" 最后一帧显示的时间值
    }
    
    deinit {
        displaylink?.invalidate()
        print("\(self) \(#function)")
    }
    
    
    
    
    // MARK: - demo2 - calculating actual frame rate
    func demo2() {
        let displaylink = CADisplayLink(target: self, selector: #selector(calculateActualFrameRate))
        displaylink.add(to: .current, forMode: .defaultRunLoopMode)
    }
    
    @objc func calculateActualFrameRate(displaylink: CADisplayLink) {
        // 属性”targetTimestamp“, 下一帧显示的时间值，在iOS 10.0以后才可用
        if #available(iOS 10.0, *) {
            let actualFramesPerSecond = 1 / (displaylink.targetTimestamp - displaylink.timestamp)
            print("actualFramesPerSecond: \(actualFramesPerSecond)")
        } else {
            // Fallback on earlier versions
            print("Fallback on earlier versions")
        }
    }
    
    
    
    
    // MARK: - demo3 - 找出计算耗时 超过屏幕下次刷新时刻 的i值
    // The following code shows how you can create a display link and register it with a run loop. The step(displayLink:) function attempts to sum the square roots of all numbers up to max, but with each iteration checks the current time (CACurrentMediaTime()) against the targetTimestamp. If the time taken to complete the calculation is later than the target timestamp, the function breaks the loop:
    func demo3() {
        let displayLink = CADisplayLink(target: self, selector: #selector(step3))
        displayLink.add(to: .main, forMode: .defaultRunLoopMode)
    }
    
    @objc func step3(displayLink: CADisplayLink) {
        if #available(iOS 10.0, *) {
            var sqrtSum = 0.0
            for i in 0 ..< Int.max {
                sqrtSum += sqrt(Double(i))
                
                if (CACurrentMediaTime() >= displayLink.targetTimestamp) {
                    print("break at i =", i)
                    break
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
