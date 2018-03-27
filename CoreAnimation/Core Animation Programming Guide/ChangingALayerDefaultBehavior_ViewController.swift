//
//  ChangingALayerDefaultBehavior_ViewController.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/22.
//  Copyright © 2018年 雷广. All rights reserved.
//

// [Changing a Layer's Default Behavior]
// (主要关于CAAction)

import UIKit

class ChangingALayerDefaultBehavior_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let layer = CATextLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 100)
        layer.position = CGPoint(x: 100, y: 150)
        layer.backgroundColor = UIColor.red.cgColor
        layer.fontSize = 22
        layer.string = "纸短情长啊"
        self.view.layer.addSublayer(layer)
        
        let anim = CATransition()
        anim.duration = 2.0
        anim.repeatCount = Float.greatestFiniteMagnitude
        anim.autoreverses = true
        anim.type = kCATransitionPush
        anim.subtype = kCATransitionFromRight
        
        layer.actions = ["contents": anim]      // 使用actions修改layer的默认contents动画
    }
    
    // CALayerDelegate protocol
//    func action(for layer: CALayer, forKey event: String) -> CAAction? {
//        if event == "contents" {
//            let anim = CATransition()
//            anim.duration = 1.0
//            anim.type = kCATransitionPush
//            anim.subtype = kCATransitionFromRight
//            return anim
//        }
//        return nil
//    }
}


/**
 
 Core Animation使用action对象为图层实现其隐式动画行为。action对象是符合CAAction协议并定义要在图层上执行的一些相关行为的对象。所有CAAnimation对象都实现了该协议，并且这些对象通常分配为在图层属性更改时执行。
 Core Animation implements its implicit animation behaviors for layers using action objects. An action object is an object that conforms to the CAAction protocol and defines some relevant behavior to perform on a layer. All CAAnimation objects implement the protocol, and it is these objects that are usually assigned to be executed whenever a layer property changes.
 
 
 
 要创建您自己的操作对象，请从您的某个类采用CAAction协议并实现runActionForKey：object：arguments：方法。在该方法中，使用可用的信息执行您想要在图层上执行的任何操作。您可以使用该方法将动画对象添加到图层，或者可以使用它来执行其他任务。
 当你定义一个动作对象时，你必须决定你想如何触发该动作。动作的触发器定义了您稍后用于注册该动作的密钥。操作对象可以由以下任何情况触发：
 其中一个图层属性的值已更改。这可以是图层的任何属性，而不仅仅是可动画的属性。 （您还可以将操作与添加到图层的自定义属性相关联。）标识此操作的键是该属性的名称。
 图层变得可见或被添加到图层层次结构中。识别此操作的关键是kCAOnOrderIn。
 图层已从图层分层结构中移除。识别此操作的关键是kCAOnOrderOut。
 该层即将参与过渡动画。识别这个动作的关键是kCATransition。
 To create your own action object, adopt the CAAction protocol from one of your classes and implement the runActionForKey:object:arguments: method. In that method, use the available information to perform whatever actions you want to take on the layer. You might use the method to add an animation object to the layer or you might use it to perform other tasks.
 When you define an action object, you must decide how you want that action to be triggered. The trigger for an action defines the key you use to register that action later. Action objects can be triggered by any of the following situations:
 The value of one of the layer’s properties changed. This can be any of the layer’s properties and not just the animatable ones. (You can also associate actions with custom properties you add to your layers.) The key that identifies this action is the name of the property.
 The layer became visible or was added to a layer hierarchy. The key that identifies this action is kCAOnOrderIn.
 The layer was removed from a layer hierarchy. The key that identifies this action is kCAOnOrderOut.
 The layer is about to be involved in a transition animation. The key that identifies this action is kCATransition.
 
 
 
 在执行操作之前，该层需要找到相应的要执行的操作对象。与层相关的操作的关键是要修改的属性的名称或标识操作的特殊字符串。在图层上发生适当的事件时，图层会调用其actionForKey：方法来搜索与该图像关联的操作对象。在此搜索过程中，您的应用可以在多个位置插入自身，并为该密钥提供相关操作对象。
 
 核心动画按以下顺序查找动作对象：
 
 如果图层具有委托并且该委托实现了actionForLayer：forKey：方法，那么图层将调用该方法。代表必须执行以下任一操作：
 返回给定键的操作对象。
 如果它不处理动作，则返回nil，在这种情况下继续搜索。
 返回NSNull对象，在这种情况下，搜索立即结束。
 该图层在层的动作字典中查找给定的键。
 该图层在样式字典中查找包含该键的动作字典。 （换句话说，样式字典包含一个动作键，其值也是一个字典，该层在第二个字典中查找给定的键。）
 该图层调用其defaultActionForKey：类方法。
 该层执行由Core Animation定义的隐式操作（如果有的话）。
 如果您在任何适当的搜索点提供了一个操作对象，那么图层会停止搜索并执行返回的操作对象。当它找到一个动作对象时，该层会调用该对象的runActionForKey：object：arguments：方法来执行动作。如果为给定键定义的动作已经是CAAnimation类的实例，则可以使用该方法的默认实现来执行动画。如果您正在定义符合CAAction协议的自定义对象，则必须使用对象的该方法实现来执行适当的操作。
 
 你在哪里安装你的动作对象取决于你打算如何修改图层。
 Before an action can be performed, the layer needs to find the corresponding action object to execute. The key for layer-related actions is either the name of the property being modified or a special string that identifies the action. When an appropriate event occurs on the layer, the layer calls its actionForKey: method to search for the action object associated with the key. Your app can interpose itself at several points during this search and provide a relevant action object for that key.
 
 Core Animation looks for action objects in the following order:
 
 If the layer has a delegate and that delegate implements the actionForLayer:forKey: method, the layer calls that method. The delegate must do one of the following:
 Return the action object for the given key.
 Return nil if it does not handle the action, in which case the search continues.
 Return the NSNull object, in which case the search ends immediately.
 The layer looks for the given key in the layer’s actions dictionary.
 The layer looks in the style dictionary for an actions dictionary that contains the key. (In other word, the style dictionary contains an actions key whose value is also a dictionary. The layer looks for the given key in this second dictionary.)
 The layer calls its defaultActionForKey: class method.
 The layer performs the implicit action (if any) defined by Core Animation.
 If you provide an action object at any of the appropriate search points, the layer stops its search and executes the returned action object. When it finds an action object, the layer calls that object’s runActionForKey:object:arguments: method to perform the action. If the action you define for a given key is already an instance of the CAAnimation class, you can use the default implementation of that method to perform the animation. If you are defining your own custom object that conforms to the CAAction protocol, you must use your object’s implementation of that method to take whatever actions are appropriate.
 
 Where you install your action objects depends on how you intend to modify the layer.
 
 For actions that you might apply only in specific circumstances, or for layers that already use a delegate object, provide a delegate and implement its actionForLayer:forKey: method.
 For layer objects that do not normally use a delegate, add the action to the layer’s actions dictionary.
 For actions related to custom properties that you define on the layer object, include the action in the layer’s style dictionary.
 For actions that are fundamental to the behavior of the layer, subclass the layer and override the defaultActionForKey: method.
 Listing 6-1 shows an implementation of the delegate method used to provide action objects. In this case, the delegate looks for changes to the layer’s contents property and swaps the new contents into place using a transition animation.
 
 */
