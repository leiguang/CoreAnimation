//
//  TableViewController.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/20.
//  Copyright © 2018年 雷广. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let datas =  [
        ["text": "Animating Layer Content", "className": "AnimatingLayerContent_ViewController"],
        ["text": "Advanced Animation Tricks CATransition", "className": "AdvancedAnimationTricks_CATransition_ViewController"],
        ["text": "Advanced Animation Tricks CAMediaTiming", "className": "AdvancedAnimationTricks_CAMediaTiming_ViewController"],
        ["text": "Advanced Animation Tricks CATransaction", "className": "AdvancedAnimationTricks_CATransaction_ViewController"],
        ["text": "Changing a Layer's Default Behavior", "className": "ChangingALayerDefaultBehavior_ViewController"],
        ["text": "CAShapeLayer", "className": "CAShapeLayer_ViewController"],
        ["text": "CASpringAnimation", "className": "CASpringAnimation_ViewController"],
        ["text": "CADisplayLink", "className": "CADisplayLink_ViewController"],
        ["text": "CAEmitterLayer", "className": "CAEmitterLayer_ViewController"],
        ["text": "CAScrollLayer", "className": "CAScrollLayer_ViewController"],
        ["text": "CATiledLayer", "className": "CATiledLayer_ViewController"],
        ["text": "CATransformLayer", "className": "CATransformLayer_ViewController"],
        ["text": "CAReplicatorLayer", "className": "CAReplicatorLayer_ViewController"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Core Animations"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }


    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = datas[indexPath.row]["text"]
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 在Swift中，由字符串转为类型的时候，如果类型是自定义的，需要在类型字符串前边加上你的项目的名字！
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        let vcClass = NSClassFromString(appName + "." + datas[indexPath.row]["className"]!) as! UIViewController.Type
        let vc = vcClass.init()
        vc.view.backgroundColor = .white
        vc.title = datas[indexPath.row]["text"]
        navigationController?.pushViewController(vc, animated: true)
    }

}
