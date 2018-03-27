//
//  AdvancedAnimationTricks_CATransaction_ViewController.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/21.
//  Copyright © 2018年 雷广. All rights reserved.
//

// [Advanced Animation Tricks]
// (本页关于 CATransaction)

/**

 显式事务让您更改动画参数
 您对图层所做的每一项更改都必须是交易的一部分。 CATransaction类在适当的时候管理动画的创建和分组以及它们的执行。在大多数情况下，您不需要创建自己的交易。无论何时将显式或隐式动画添加到其中一个图层，Core Animation都会自动创建隐式事务。但是，您也可以创建显式事务来更精确地管理这些动画。
 您可以使用CATransaction类的方法创建和管理事务。要开始（并隐式创建）一个新事务，请调用begin类方法;要结束该事务，请调用提交类方法。在这些调用之间是你想做的变化。如Listing 5-5。
 Explicit Transactions Let You Change Animation Parameters
 Every change you make to a layer must be part of a transaction. The CATransaction class manages the creation and grouping of animations and their execution at the appropriate time. In most cases, you do not need to create your own transactions. Core Animation automatically creates an implicit transaction whenever you add explicit or implicit animations to one of your layers. However, you can also create explicit transactions to manage those animations more precisely.
 You create and manage transactions using the methods of the CATransaction class. To start (and implicitly create) a new transaction call the begin class method; to end that transaction, call the commit class method. In between those calls are the changes that you want to be part of the transaction.
 
 
 Listing 5-5  Creating an explicit transaction:
    [CATransaction begin];
    theLayer.zPosition=200.0;
    theLayer.opacity=0.0;
    [CATransaction commit];
 
 
 使用交易的主要原因之一是，在明确交易的范围内，您可以更改持续时间，计时功能和其他参数。您还可以为整个事务分配一个完成块，以便在动画组结束时通知您的应用程序。更改动画参数需要使用setValue：forKey：方法修改事务字典中的相应键。例如，要将默认持续时间更改为10秒，您可以更改kCATransactionAnimationDuration键，如清单5-6所示。
 One of the main reasons to use transactions is that within the confines of an explicit transaction, you can change the duration, timing function, and other parameters. You can also assign a completion block to the entire transaction so that your app can be notified when the group of animations finishes. Changing animation parameters requires modifying the appropriate key in the transaction dictionary using the setValue:forKey: method. For example, to change the default duration to 10 seconds, you would change the kCATransactionAnimationDuration key, as shown in Listing 5-6.
 
 
 您可以在要为不同的动画集提供不同默认值的情况下嵌套事务。要将一个事务嵌套到另一个事务中，只需再次调用begin类方法即可。每次开始调用都必须通过对commit方法的相应调用进行匹配。只有在您为最外层事务提交更改后，Core Animation才会开始关联的动画。
 You can nest transactions in situations where you want to provide different default values for different sets of animations. To nest one transaction inside of another, just call the begin class method again. Each begin call must be matched by a corresponding call to the commit method. Only after you commit the changes for the outermost transaction does Core Animation begin the associated animations.

 
 在事务期间，您可以临时获取用于管理属性原子性的递归旋转锁。
 During a transaction you can temporarily acquire a recursive spin lock for managing property atomicity.
 
 */

import UIKit

class AdvancedAnimationTricks_CATransaction_ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        explicitTransactions()          // transaction用法示例
        nestedExplicitTransactions()    // 嵌套的transaction
    }

    // MARK: - Creating an explicit transaction
    func explicitTransactions() {
        let layer1 = CALayer()
        layer1.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
        layer1.position = CGPoint(x: 60, y: 150)
        layer1.backgroundColor = UIColor.red.cgColor
        view.layer.addSublayer(layer1)
        
        let layer2 = CALayer()
        layer2.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
        layer2.position = CGPoint(x: 180, y: 150)
        layer2.backgroundColor = UIColor.red.cgColor
        view.layer.addSublayer(layer2)
        
        let layer3 = CALayer()
        layer3.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
        layer3.position = CGPoint(x: 300, y: 150)
        layer3.backgroundColor = UIColor.red.cgColor
        view.layer.addSublayer(layer3)
        
        let layer4 = CALayer()
        layer4.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
        layer4.position = CGPoint(x: 60, y: 300)
        layer4.backgroundColor = UIColor.green.cgColor
        view.layer.addSublayer(layer4)
        
  
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {

            // 1.禁用动画效果
            CATransaction.begin()
            CATransaction.setDisableActions(true)   // 相当于CATransaction.setValue(true, forKey: kCATransactionDisableActions)
            layer1.opacity = 0
            CATransaction.commit()


            // 2.默认animation duration （0.25s）
            layer2.opacity = 0


            // 3.把default animation duration改为 3s
            // 4.设置动画完成后的回调函数
            CATransaction.begin()
            CATransaction.setAnimationDuration(3)   // 相当于CATransaction.setValue(3, forKey: kCATransactionAnimationDuration)
            CATransaction.setCompletionBlock({      // 相当于kCATransactionCompletionBlock
                print("completion")
            })
            layer3.opacity = 0
            CATransaction.commit()

            
            // 5.设置动画的时间函数
            // CAMediaTimingFunction效果查看器 [Tween-o-Matic](https://github.com/simonwhitaker/tween-o-matic)
            CATransaction.begin()
            CATransaction.setAnimationDuration(2)
            let timingFunction = CAMediaTimingFunction(controlPoints: 0, 0.9, 0.1, 1)
            CATransaction.setAnimationTimingFunction(timingFunction)    // 相当于kCATransactionAnimationTimingFunction
            layer4.position = CGPoint(x: 300, y: 300)
            CATransaction.commit()
            
        }
    }
    
    // MARK: - Nesting explicit transactions
    func nestedExplicitTransactions() {
        let layer = CALayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
        layer.position = CGPoint(x: 60, y: 400)
        layer.backgroundColor = UIColor.blue.cgColor
        view.layer.addSublayer(layer)
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        
            // 如果多线程中需要的话，可以使用CATransaction提供的递归自旋锁来保证属性的原子性 (Attempts to acquire a recursive spin-lock lock, ensuring that returned layer values are valid until unlocked.)
            CATransaction.lock()
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(2.0)
            layer.position = CGPoint(x: 300, y: 400)
            
                // Inner transaction
                CATransaction.begin()
                CATransaction.setAnimationDuration(5.0)
                layer.zPosition = 200.0
                layer.opacity = 0
                CATransaction.commit()
            
            CATransaction.commit()
            
            CATransaction.unlock()
        }
        
        
        /** [Adding Perspective to Your Animations]
         // Adding a perspective transform to a parent layer
         var perspective = CATransform3DIdentity
         perspective.m34 = -1.0 / 1000
         
         // Apply the transform to a parent layer.
         view.layer.sublayerTransform = perspective
        */
    }
}
