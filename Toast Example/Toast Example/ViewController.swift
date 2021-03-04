//
//  ViewController.swift
//  Toast Example
//
//  Created by Arman Zoghi on 3/2/21.
//

import UIKit
import HoveringPopUp

class ViewController: UIViewController {

    let popUpView = HoveringPopUp()
    
    let popButton  = UIButton()
    let hideButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Create UI
    
    fileprivate func createUI() {
        self.view.backgroundColor = .white
        self.popButtonConfig()
        self.hideButtonConfig()
    }
    
    //MARK: - Prepare pop up
    
    fileprivate func preparePopUp() {
        let view = UIView()
        view.backgroundColor = .gray
        self.popUpView.preparePopUp(fullView: view, title: "Question", font: nil, backgroundColor: nil, textColor: nil, shadowColor: nil, borderWidth: nil, borderColor: nil)
    }
    
    //MARK: - popButton
    
    //config
    fileprivate func popButtonConfig() {
        self.view.addSubview(self.popButton)
        self.popButtonConstraints()
        self.popButton.backgroundColor = .systemRed
        self.popButton.setTitle("show", for: .normal)
        self.popButton.addTarget(self, action: #selector(self.popUp), for: .touchUpInside)
    }
    
    //constraints
    fileprivate func popButtonConstraints() {
        self.popButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.popButton, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: self.popButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.popButton, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0, constant: 100).isActive = true
        NSLayoutConstraint(item: self.popButton, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 40).isActive = true
    }
    
    //MARK: - HideButton
    
    //config
    fileprivate func hideButtonConfig() {
        self.view.addSubview(self.hideButton)
        self.hideButtonConstraints()
        self.hideButton.backgroundColor = .systemBlue
        self.hideButton.setTitle("hide", for: .normal)
        self.hideButton.addTarget(self, action: #selector(self.hide(_:)), for: .touchUpInside)
    }
    
    //constraints
    fileprivate func hideButtonConstraints() {
        self.hideButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.hideButton, attribute: .top, relatedBy: .equal, toItem: self.popButton, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: self.hideButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.hideButton, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0, constant: 100).isActive = true
        NSLayoutConstraint(item: self.hideButton, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 40).isActive = true
    }

    //MARK: - objc
    
    @objc fileprivate func popUp(_ target: UIButton) {
        self.preparePopUp()
        self.popUpView.show(from: .top, autoDismiss: true)
    }
    
    @objc fileprivate func hide(_ target: UIButton) {
        self.popUpView.hide()
    }

}

