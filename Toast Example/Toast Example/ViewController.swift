//
//  ViewController.swift
//  Toast Example
//
//  Created by Arman Zoghi on 3/2/21.
//

import UIKit
import Toasty

class ViewController: UIViewController {

    let toast = Toasty()
    
    let showButton  = UIButton()
    let hideButton = UIButton()
    
    var exampleOn = false
    
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
        self.showButtonConfig()
        self.hideButtonConfig()
        self.toast.fullSizeFrameConstraints(width: UIScreen.main.bounds.width - 30, height: 200)
    }
    
    //MARK: - Prepare toast
    
    fileprivate func prepareToasty() {
        let view = UIView()
        view.backgroundColor = .lightGray
        if #available(iOS 13.0, *) {
            self.toast.prepareToast(title: "Silent Mode", titleFont: nil, subtitle: "On", expandedView: view, backgroundColor: nil, titleColor: nil, shadowColor: nil, borderWidth: nil, borderColor: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    //MARK: - showButton
    
    //config
    fileprivate func showButtonConfig() {
        self.view.addSubview(self.showButton)
        self.showButtonConstraints()
        self.showButton.backgroundColor = .systemRed
        self.showButton.setTitle("show", for: .normal)
        self.showButton.layer.cornerRadius = 10
        self.showButton.addTarget(self, action: #selector(self.showToast), for: .touchUpInside)
    }
    
    //constraints
    fileprivate func showButtonConstraints() {
        self.showButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.showButton, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: self.showButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.showButton, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0, constant: 100).isActive = true
        NSLayoutConstraint(item: self.showButton, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 40).isActive = true
    }
    
    //MARK: - HideButton
    
    //config
    fileprivate func hideButtonConfig() {
        self.view.addSubview(self.hideButton)
        self.hideButtonConstraints()
        self.hideButton.backgroundColor = .systemBlue
        self.hideButton.setTitle("hide", for: .normal)
        self.hideButton.layer.cornerRadius = 10
        self.hideButton.addTarget(self, action: #selector(self.hide(_:)), for: .touchUpInside)
    }
    
    //constraints
    fileprivate func hideButtonConstraints() {
        self.hideButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.hideButton, attribute: .top, relatedBy: .equal, toItem: self.showButton, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: self.hideButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.hideButton, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0, constant: 100).isActive = true
        NSLayoutConstraint(item: self.hideButton, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 40).isActive = true
    }

    //MARK: - objc
    
    @objc fileprivate func showToast(_ target: UIButton) {
        self.prepareToasty()
        if self.exampleOn == true {
            if #available(iOS 13.0, *) {
                self.toast.show(from: .top, changeSubtitle: "Off", autoDismiss: true)
            } else {
                // Fallback on earlier versions
            }
            self.exampleOn = false
        } else {
            if #available(iOS 13.0, *) {
                self.toast.show(from: .top, changeSubtitle: "On", autoDismiss: true)
            } else {
                // Fallback on earlier versions
            }
            self.exampleOn = true
        }
    }
    
    @objc fileprivate func hide(_ target: UIButton) {
        self.toast.hide()
    }

}

