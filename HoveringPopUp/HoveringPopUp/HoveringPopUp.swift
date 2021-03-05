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
    fileprivate var dismissButtonTransform : CGAffineTransform?
    fileprivate var dismissButton          : UIButton?
    
    //MARK: ----- Gestures -----
    
    lazy fileprivate var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.changeMode))
    
    //MARK: Pass Through Touch
    
    /// Allows touch to pass through hidden areas.
    /// - Parameters:
    ///   - point: The point of touch.
    ///   - event: The even that created the touch.
    /// - Returns: If touch should register or pass through.
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden, subview.isUserInteractionEnabled, subview.frame.contains(point) {
                return true
            }
        }
        return false
    }
    
    //MARK: - Create View
    
    fileprivate func createView(with window: UIWindow) {
        if superview != window {
            window.addSubview(self)
            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: window, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: self, attribute: .width  , relatedBy: .equal, toItem: window, attribute: .width  , multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: self, attribute: .height , relatedBy: .equal, toItem: window, attribute: .height , multiplier: 1, constant: 0).isActive = true
            window.bringSubviewToFront(self)
        }
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
    open func preparePopUp(title: String, font: UIFont? = nil, fullView: UIView? = nil, backgroundColor: UIColor? = nil, textColor: UIColor? = nil, shadowColor: UIColor? = nil, shadowOffset: CGSize? = nil, shadowOpacity: Float? = nil, shadowRadius: CGFloat? = nil ,borderWidth: CGFloat? = nil, borderColor: UIColor? = nil) {
        self.removeFromSuperview()
        self.findMainWindow()
        guard let window = self.mainWindow else {
            print("Error: No Window found!")
            return
        }
        self.createView(with: window)
        self.popUpView.view?.removeFromSuperview()
        self.popUpView.view = nil
        if let view = fullView {
            self.popUpView.view = view
        }
        self.popUpView.layer.shadowColor   = (shadowColor  ?? UIColor.darkGray).cgColor
        self.popUpView.layer.shadowOffset  = shadowOffset  ?? .init(width: 0, height: 5)
        self.popUpView.layer.shadowOpacity = shadowOpacity ?? 0.265
        self.popUpView.layer.shadowRadius  = shadowRadius  ?? 20
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
                self.popUpView.addGestureRecognizer(self.tapGesture)
            } else {
                self.popUpView.removeGestureRecognizer(self.tapGesture)
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
                if self.popUpView.type == .fullSize {
                    self.compactMode()
                }
                self.popUpView.transform = transform
            } else {
                print("Not shown yet.")
            }
        } completion: { (_) in
            self.directionTransform = nil
            self.popUpView.removeFromSuperview()
        }
    }
    
    //MARK: - Dismiss Button
    
    //config
    fileprivate func dismissButtonConfig() {
        self.dismissButton = UIButton()
        self.insertSubview(dismissButton!, at: 1)
        self.dismissButtonConstraints()
        self.dismissButton?.layer.cornerRadius = 15
        self.dismissButton?.layer.borderWidth = 0.5
        self.dismissButton?.layer.borderColor = UIColor.lightGray.cgColor
        self.dismissButton?.alpha = 0
        self.dismissButton?.setTitle("X", for: .normal)
        self.dismissButton?.setTitleColor(UIColor.lightGray, for: .normal)
        self.dismissButton?.transform = .init(translationX: 0, y: 40)
        self.dismissButtonTransform = self.dismissButton?.transform
        self.dismissButton?.addTarget(self, action: #selector(self.changeMode), for: .touchUpInside)
        self.layoutSubviews()
    }
    
    //constraints
    fileprivate func dismissButtonConstraints() {
        self.dismissButton?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.dismissButton!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.dismissButton!, attribute: .bottom, relatedBy: .equal, toItem: self.popUpView, attribute: .top, multiplier: 1, constant: -5).isActive = true
        NSLayoutConstraint(item: self.dismissButton!, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 30).isActive = true
        NSLayoutConstraint(item: self.dismissButton!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30).isActive = true
    }
    
    //remove
    fileprivate func dismissButtonRemove() {
        if let button = dismissButton {
            NSLayoutConstraint.deactivate(button.constraints)
            button.removeFromSuperview()
            self.dismissButton = nil
        }
    }
    
    //MARK: - modes
    
    fileprivate func fullSizeMode() {
        self.dismissButtonConfig()
        NSLayoutConstraint.deactivate(self.popUpCompactWidthAndHeightConstraints)
        NSLayoutConstraint.activate(self.popUpFullSizeWidthAndHeightConstraints)
        self.addGestureRecognizer(self.tapGesture)
        self.popUpView.removeGestureRecognizer(self.tapGesture)
        self.popUpView.clipsToBounds = true
        self.popUpView.type = .fullSize
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurView.alpha = 0
        blurView.frame = self.bounds
        self.insertSubview(blurView, at: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 2.5, options: [.preferredFramesPerSecond60, .curveEaseInOut]) {
            blurView.alpha = 1
            self.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            if self.direction == .top {
                self.popUpView.transform = .init(translationX: 0, y: 40)
            } else {
                self.popUpView.transform = .init(translationX: 0, y: -40)
            }
            self.layoutSubviews()
        }
        UIView.transition(with: self.dismissButton!, duration: 0.5, options: .transitionFlipFromTop, animations: {
            self.dismissButton?.alpha = 1
        }, completion: nil)
    }
    
    fileprivate func compactMode() {
        NSLayoutConstraint.deactivate(self.popUpFullSizeWidthAndHeightConstraints)
        NSLayoutConstraint.activate(self.popUpCompactWidthAndHeightConstraints)
        self.removeGestureRecognizer(self.tapGesture)
        self.popUpView.addGestureRecognizer(self.tapGesture)
        let blurView = self.subviews[0]
        self.popUpView.clipsToBounds = false
        self.popUpView.view?.alpha = 0
        self.dismissButtonRemove()
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: [.preferredFramesPerSecond60, .curveEaseIn]) {
            blurView.alpha = 0
            self.popUpView.transform = .identity
            self.backgroundColor = .clear
            self.layoutSubviews()
        } completion: { (_) in
            self.popUpView.type = .compact
            blurView.removeFromSuperview()
        }
    }
    
    //MARK: - objc
    
    @objc fileprivate func changeMode() {
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
                if let button = self.dismissButton {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.09) {
                            button.transform = self.dismissButtonTransform!.scaledBy(x: 0.9, y: 0.9)
                        } completion: { (_) in
                            UIView.animate(withDuration: 0.09) {
                                button.transform = self.dismissButtonTransform!
                            } completion: { (_) in
                                self.compactMode()
                            }
                        }
                    }
                } else {
                    self.compactMode()
                }
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
