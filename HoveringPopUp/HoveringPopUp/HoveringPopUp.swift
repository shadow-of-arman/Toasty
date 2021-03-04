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
    fileprivate var popUpInitialConstraints                : [NSLayoutConstraint] = []
    fileprivate var popUpCompactWidthAndHeightConstraints  : [NSLayoutConstraint] = []
    fileprivate var popUpFullSizeWidthAndHeightConstraints : [NSLayoutConstraint] = []
    fileprivate var mainWindow: UIWindow?
    fileprivate var direction : HoveringPopUpDirection = .top
    fileprivate var directionTransform : CGAffineTransform?
    
    //MARK: ----- Gestures -----
    
    lazy fileprivate var gesture = UITapGestureRecognizer(target: self, action: #selector(self.changeMode(_:)))
    
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
    
    fileprivate func configPopUpFrame(width: CGFloat?, height: CGFloat?, offset: CGFloat?) {
        self.popUpView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivate(self.popUpInitialConstraints)
        var y: NSLayoutConstraint!
        switch self.direction {
        case .top:
            y = NSLayoutConstraint(item: self.popUpView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: offset ?? -5)
            self.popUpView.transform = .init(translationX: 0, y: -(height ?? 50) - abs(offset ?? -5) - 100)
            self.directionTransform = self.popUpView.transform
        case .bottom:
            y = NSLayoutConstraint(item: self.popUpView, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: offset ?? -5)
            self.popUpView.transform = .init(translationX: 0, y: +(height ?? 50) + abs(offset ?? -5) + 100)
            self.directionTransform = self.popUpView.transform 
        }
        let x = NSLayoutConstraint(item: self.popUpView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: self.popUpView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: width ?? 190)
        let heightConstraint = NSLayoutConstraint(item: self.popUpView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: height ?? 50)
        self.popUpCompactWidthAndHeightConstraints = [widthConstraint, heightConstraint]
        self.popUpInitialConstraints = [x, y, widthConstraint, heightConstraint]
        NSLayoutConstraint.activate(self.popUpInitialConstraints)
        self.prepareFullSizeConstraints()
    }
    
    fileprivate func prepareFullSizeConstraints() {
        var width: NSLayoutConstraint!
        var height: NSLayoutConstraint!
        width = NSLayoutConstraint(item: self.popUpView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: -40)
        if direction == .top {
            height = NSLayoutConstraint(item: self.popUpView, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -70)
        } else {
            height = NSLayoutConstraint(item: self.popUpView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 70)
        }
        self.popUpFullSizeWidthAndHeightConstraints = [width, height]
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
        self.popUpView.layer.shadowColor = UIColor.darkGray.cgColor
        self.popUpView.layer.shadowOffset = .init(width: 0, height: 8)
        self.popUpView.layer.shadowOpacity = 0.25
        self.popUpView.layer.shadowRadius = 17.5
    }
    
    //MARK: - Pop Up
    
    /// Shows toast notification.
    /// - Parameter direction: Sets the direction to display to pop up from.
    /// - Parameter width: Sets the width.
    /// - Parameter height: Sets the height.
    /// - Parameter animationDuration: Sets the animation duration.
    /// - Parameter offset: Sets an offset from the top or bottom according to the direction.
    /// - Parameter expandable: Adds a tap gesture to expand the toast and show the view that was inserted at prep time.
    /// - Parameter autoDismiss: Allows toast to hide/dismiss automatically after a certain time.
    /// - Parameter activeDuration: Sets the time it takes for the toast to hide/dismiss if auto dismiss is true.
    open func show(from direction: HoveringPopUpDirection, width: CGFloat? = nil, height: CGFloat? = nil, animationDuration: TimeInterval? = nil, offset: CGFloat? = nil, expandable: Bool? = nil, autoDismiss: Bool? = nil, activeDuration: TimeInterval? = nil) {
        if self.directionTransform == nil {
            self.addSubview(self.popUpView)
            self.direction = direction
            self.configPopUpFrame(width: width, height: height, offset: offset ?? -5)
            UIView.animate(withDuration: animationDuration ?? 0.45, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: [.preferredFramesPerSecond60, .curveEaseOut]) {
                self.popUpView.transform = .identity
                self.popUpView.layer.cornerRadius = 25
            }
            if expandable ?? true {
                self.popUpView.addGestureRecognizer(self.gesture)
            }
            if autoDismiss ?? false {
                Timer.scheduledTimer(withTimeInterval: activeDuration ?? 2, repeats: false) { (_) in
                    self.hide()
                }
            }
        }
    }
    
    /// Hides toast notification.
    /// - Parameter animationDuration: Sets the animation duration.
    open func hide(animationDuration: TimeInterval? = nil) {
        UIView.animate(withDuration: animationDuration ?? 0.2, delay: 0, options: [.preferredFramesPerSecond60, .curveEaseIn]) {
            if let transform = self.directionTransform {
                self.popUpView.transform = transform
            } else {
                print("Not shown yet.")
            }
        } completion: { (_) in
            self.directionTransform = nil
            self.popUpView.removeFromSuperview()
        }
    }
    
    //MARK: - modes
    
    fileprivate func fullSizeMode() {
        NSLayoutConstraint.deactivate(self.popUpCompactWidthAndHeightConstraints)
        NSLayoutConstraint.activate(self.popUpFullSizeWidthAndHeightConstraints)
        self.popUpView.clipsToBounds = true
        self.popUpView.type = .fullSize
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 2.5, options: [.preferredFramesPerSecond60, .curveEaseInOut]) {
            self.popUpView.transform = .init(translationX: 0, y: 40)
            self.layoutSubviews()
        }
    }
    
    fileprivate func compactMode() {
        NSLayoutConstraint.deactivate(self.popUpFullSizeWidthAndHeightConstraints)
        NSLayoutConstraint.activate(self.popUpCompactWidthAndHeightConstraints)
        self.popUpView.type = .compact
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.preferredFramesPerSecond60, .curveEaseInOut]) {
            self.popUpView.transform = .identity
            self.layoutSubviews()
        } completion: { (_) in
            self.popUpView.clipsToBounds = false
        }
    }
    
    //MARK: - objc
    
    @objc fileprivate func changeMode(_ target: UITapGestureRecognizer) {
        if let _ = self.directionTransform {
            switch self.popUpView.type {
            case .compact:
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.09) {
                        self.popUpView.transform = .init(scaleX: 0.96, y: 0.96)
                    } completion: { (_) in
                        UIView.animate(withDuration: 0.09) {
                            self.popUpView.transform = .identity
                        } completion: { (_) in
                            self.fullSizeMode()
                        }
                    }
                }
            case .fullSize:
                self.compactMode()
            }
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
