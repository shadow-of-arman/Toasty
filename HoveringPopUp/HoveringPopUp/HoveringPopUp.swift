//
//  HoveringPopUp.swift
//  HoveringPopUp
//
//  Created by Arman Zoghi on 3/2/21.
//

import Foundation
import UIKit

open class HoveringPopUp: UIView {
    
    //MARK: ----- Constants -----
    
    fileprivate let compactLabel : UILabel   = UILabel()
    fileprivate let popUpView    : PopUpView = PopUpView()
    
    //MARK: ----- Variables -----
    
    /// Sets the text to show in the title when in compact mode.
    open var compactTitleText: String? {
        didSet {
            compactLabel.text = self.compactTitleText ?? "POP"
        }
    }
    
    /// The constraints used for the popUpView
    fileprivate var viewConstraints : [NSLayoutConstraint] = []
    fileprivate var mainWindow: UIWindow?
    
    //MARK: - Create View
    
    fileprivate func createView(with window: UIWindow) {
        window.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: window, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .width  , relatedBy: .equal, toItem: window, attribute: .width  , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .height , relatedBy: .equal, toItem: window, attribute: .height , multiplier: 1, constant: 0).isActive = true
        window.bringSubviewToFront(self)
    }
    
    //MARK: - Pop up frame
    
    fileprivate func configPopUpFrame(width: CGFloat?, height: CGFloat?) {
        
    }
    
    /// Finds the main window currently active.
    fileprivate func findMainWindow() {
        if #available(iOS 13.0, *) {
            if let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first {
                self.mainWindow = window
            } else {
                if let window = UIApplication.shared.keyWindow {
                    self.mainWindow = window
                } else if let window = UIApplication.shared.delegate?.window {
                    self.mainWindow = window
                }
            }
        } else {
            if let window = UIApplication.shared.keyWindow {
                self.mainWindow = window
            } else if let window = UIApplication.shared.delegate?.window {
                self.mainWindow = window
            }

        }
    }
    
    //MARK: Directional constraints
    
    
    //MARK: - Prep
    
    /// Prepares the popUpViewToShow
    /// - Parameters:
    ///   - fullView: Sets the view to show when in full screen.
    ///   - title: Sets the title to show when in compact mode.
    ///   - font: Sets the Font to use for the title inside the compact mode.
    ///   - backgroundColor: Sets the background color to use for the compact mode.
    ///   - textColor: Sets the color of the title in compact mode.
    ///   - shadowColor: Sets the shadow color of the pop up.
    ///   - borderWidth: Sets the border width of the pop up view.
    ///   - borderColor: Sets the border color of the pop up view.
    open func preparePopUp(fullView: UIView, title: String, font: UIFont?, backgroundColor: UIColor?, textColor: UIColor?, shadowColor: UIColor?, borderWidth: CGFloat?, borderColor: UIColor?) {
        self.removeFromSuperview()
        self.findMainWindow()
        guard let window = self.mainWindow else {
            print("Error: No Window found!")
            return
        }
        self.createView(with: window)
        self.popUpView.view = fullView
    }
    
    //MARK: - Pop Up
    
    /// Pops up!
    /// - Parameter direction: Sets the direction to display to pop up from.
    open func popFrom(direction: HoveringPopUpDirection, width: CGFloat?, height: CGFloat?, animationDuration: TimeInterval? = 0.3) {
        self.addSubview(self.popUpView)
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        //decides direction
        switch direction {
        case .top:
            NSLayoutConstraint(item: self.popUpView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 10).isActive = true
            self.popUpView.transform = .init(translationX: 0, y: -(height ?? 200))
        case .bottom:
            NSLayoutConstraint(item: self.popUpView, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
            self.popUpView.transform = .init(translationX: 0, y: (height ?? 200))
        }
        NSLayoutConstraint(item: self.popUpView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.popUpView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: width ?? 150).isActive = true
        NSLayoutConstraint(item: self.popUpView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: height ?? 40).isActive = true
        //
        UIView.animate(withDuration: animationDuration ?? 0.3) {
            self.popUpView.transform = .identity
            self.popUpView.layer.cornerRadius = (height ?? 40) / 2
        }
    }
    
    open func hidePopUp() {
        
    }
    
    
    
}
