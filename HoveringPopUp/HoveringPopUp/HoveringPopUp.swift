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
    
    fileprivate var popUpWidthAndHeightConstraints : [NSLayoutConstraint] = []
    fileprivate var mainWindow: UIWindow?
    fileprivate var direction : HoveringPopUpDirection = .top
    fileprivate var directionTransform : CGAffineTransform?
    
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
    
    fileprivate func configPopUpFrame(width: CGFloat?, height: CGFloat?, offset: CGFloat? = -5) {
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        self.popUpWidthAndHeightConstraints = []
        switch self.direction {
        case .top:
            NSLayoutConstraint(item: self.popUpView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: offset ?? -5).isActive = true
            self.popUpView.transform = .init(translationX: 0, y: -(height ?? 50) - abs(offset ?? -5) - 100)
            self.directionTransform = self.popUpView.transform
        case .bottom:
            NSLayoutConstraint(item: self.popUpView, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: offset ?? -5).isActive = true
            self.popUpView.transform = .init(translationX: 0, y: (height ?? 200))
            self.directionTransform = self.popUpView.transform 
        }
        NSLayoutConstraint(item: self.popUpView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        let widthConstraint = NSLayoutConstraint(item: self.popUpView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: width ?? 190)
        let heightConstraint = NSLayoutConstraint(item: self.popUpView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: height ?? 50)
        self.popUpWidthAndHeightConstraints = [widthConstraint, heightConstraint]
        NSLayoutConstraint.activate(self.popUpWidthAndHeightConstraints)
    }
    
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
    open func preparePopUp(fullView: UIView, title: String, font: UIFont? = nil, backgroundColor: UIColor? = nil, textColor: UIColor? = nil, shadowColor: UIColor? = nil, borderWidth: CGFloat? = nil, borderColor: UIColor? = nil) {
        self.removeFromSuperview()
        self.findMainWindow()
        guard let window = self.mainWindow else {
            print("Error: No Window found!")
            return
        }
        self.createView(with: window)
        self.popUpView.view = fullView
        self.popUpView.layer.shadowColor = UIColor.gray.cgColor
        self.popUpView.layer.shadowOffset = .init(width: 0, height: 10)
        self.popUpView.layer.shadowOpacity = 0.25
        self.popUpView.layer.shadowRadius = 15
    }
    
    //MARK: - Pop Up
    
    /// Shows toast notification.
    /// - Parameter direction: Sets the direction to display to pop up from.
    open func show(from direction: HoveringPopUpDirection, width: CGFloat? = nil, height: CGFloat? = nil, animationDuration: TimeInterval? = nil, offset: CGFloat? = -5) {
        if self.directionTransform == nil {
            self.addSubview(self.popUpView)
            self.direction = direction
            self.configPopUpFrame(width: width, height: height, offset: offset)
            UIView.animate(withDuration: animationDuration ?? 0.35, delay: 0, options: [.preferredFramesPerSecond60, .curveEaseOut]) {
                self.popUpView.transform = .identity
                self.popUpView.layer.cornerRadius = 25
            }
        }
    }
    
    /// Hides toast notification.
    /// - Parameter animationDuration: Sets the animation duration.
    open func hide(animationDuration: TimeInterval? = nil) {
        UIView.animate(withDuration: animationDuration ?? 0.25, delay: 0, options: [.preferredFramesPerSecond60, .curveEaseIn]) {
            if let transform = self.directionTransform {
                self.popUpView.transform = transform
            } else {
                print("Not pop up yet.")
            }
        } completion: { (_) in
            self.directionTransform = nil
            self.popUpView.removeFromSuperview()
        }
    }
    
}

//MARK: - Extensions and Delegations

private extension HoveringPopUp {
    
    //find window
    func findMainWindow() {
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
    
}
