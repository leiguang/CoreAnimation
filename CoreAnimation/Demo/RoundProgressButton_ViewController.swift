//
//  RoundProgressButton_ViewController.swift
//  CoreAnimation
//
//  Created by Guang Lei  on 2019/4/1.
//  Copyright © 2019 雷广. All rights reserved.
//

import UIKit

class RoundProgressButton_ViewController: UIViewController {

    let progressButton = RoundProgressButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addNavigationItems()
        addRoundProgressButton()
    }
    
    func addNavigationItems() {
        let increaseButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(clickIncreaseButton))
        let decreaseButton = UIBarButtonItem(title: "-", style: .plain, target: self, action: #selector(clickDecreaseButton))
        navigationItem.rightBarButtonItems = [decreaseButton, increaseButton]
    }
    
    @objc func clickIncreaseButton() {
        progressButton.step = min(progressButton.step + 1, progressButton.maximumStep)
    }
    
    @objc func clickDecreaseButton() {
        progressButton.step = max(progressButton.step - 1, 0)
    }
    
    func addRoundProgressButton() {
        progressButton.frame = CGRect(x: 150, y: 150, width: 100, height: 100)
        progressButton.maximumStep = 5
        progressButton.addTarget(self, action: #selector(clickProgressButton), for: .touchUpInside)
        view.addSubview(progressButton)
    }
    
    @objc func clickProgressButton() {
        print("clicked")
    }
}
