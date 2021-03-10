//
//  Toasty.swift
//  Toasty
//
//  Created by Arman Zoghi on 3/2/21.
//

import Foundation
import UIKit

/// A toast notification view.
open class Toasty: UIView {
    
    //MARK: ----- Constants -----
    
    fileprivate let compactLabel : UILabel   = UILabel()
    fileprivate let toastView    : ToastView = ToastView()
    
    //MARK: ----- Variables -----
    
    /// Used to identify when the toast is on screen.
    open private(set) var isVisible : Bool = false
    
    fileprivate var toastInitialConstraints                : [NSLayoutConstraint] = []
    fileprivate var toastCompactWidthAndHeightConstraints  : [NSLayoutConstraint] = []
    fileprivate var toastExpandedWidthAndHeightConstraints : [NSLayoutConstraint] = []
    fileprivate var mainWindow             : UIWindow?
    fileprivate var direction              : ToastyDirection = .top
    fileprivate var directionTransform     : CGAffineTransform?
    fileprivate var dismissButtonTransform : CGAffineTransform?
    fileprivate var dismissButton          : UIButton?
    fileprivate var fullSizeWidth          : CGFloat?
    fileprivate var fullSizeHeight         : CGFloat?
    
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
    
    //MARK: - Toast frame
    
    fileprivate func configToastFrame(width: CGFloat?, height: CGFloat?, offset: CGFloat?) {
        self.toastView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivate(self.toastInitialConstraints)
        var y: NSLayoutConstraint!
        switch self.direction {
        case .top:
            y = NSLayoutConstraint(item: self.toastView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: offset ?? -5)
            self.toastView.transform = .init(translationX: 0, y: -(height ?? 50) - abs(offset ?? -5) - 100)
            self.directionTransform = self.toastView.transform
        case .bottom:
            y = NSLayoutConstraint(item: self.toastView, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: offset ?? -5)
            self.toastView.transform = .init(translationX: 0, y: +(height ?? 50) + abs(offset ?? -5) + 100)
            self.directionTransform = self.toastView.transform
        }
        let x = NSLayoutConstraint(item: self.toastView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: self.toastView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: width ?? 190)
        let heightConstraint = NSLayoutConstraint(item: self.toastView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: height ?? 50)
        self.toastCompactWidthAndHeightConstraints = [widthConstraint, heightConstraint]
        self.toastInitialConstraints = [x, y, widthConstraint, heightConstraint]
        NSLayoutConstraint.activate(self.toastInitialConstraints)
        self.prepareFullSizeConstraints()
    }
    
    fileprivate func prepareFullSizeConstraints() {
        var width: NSLayoutConstraint!
        var height: NSLayoutConstraint!
        if let widthConstraint = self.fullSizeWidth {
            width = NSLayoutConstraint(item: self.toastView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: widthConstraint)
        } else {
            width = NSLayoutConstraint(item: self.toastView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: -40)
        }
        if let heightConstraint = self.fullSizeHeight {
            height = NSLayoutConstraint(item: self.toastView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: heightConstraint)
        } else {
            if direction == .top {
                height = NSLayoutConstraint(item: self.toastView, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -70)
            } else {
                height = NSLayoutConstraint(item: self.toastView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 70)
            }            
        }
        self.toastExpandedWidthAndHeightConstraints = [width, height]
    }
    
    //MARK: - Preparation
    
    /// Prepares Toasty by turning on the toaster.
    /// - Parameters:
    ///   - expandedView: Sets the view to show when in expanded view.
    ///   - title: Sets the title to show when in compact mode.
    ///   - titleFont: Sets the Font to use for the title inside the compact mode.
    ///   - subtitle: Sets a subtitle with the string as text.
    ///   - subtitleFont: Sets the subtitle font if it exists.
    ///   - icon: Sets an icon with the given image.
    ///   - iconDirection: Sets the position of the icon.
    ///   - backgroundColor: Sets the background color to use for the compact mode.
    ///   - titleColor: Sets the color of the title in compact mode.
    ///   - subtitleColor: Sets the color of the subtitle.
    ///   - iconColor: Sets the color of the icon.
    ///   - shadowColor: Sets the shadow color of the toast view.
    ///   - borderWidth: Sets the border width of the toast view.
    ///   - borderColor: Sets the border color of the toast view.
    ///   - shadowOffset: Sets the shadow offset of the toast view.
    ///   - shadowOpacity: Sets the shadow opacity of the toast view.
    ///   - shadowRadius: Sets the shadow radius of the toast view.
    open func prepareToast(title: String, titleFont: UIFont? = nil, subtitle: String? = nil, subtitleFont: UIFont? = nil, icon: UIImage? = nil, iconDirection: ToastyIconPosition? = nil, expandedView: UIView? = nil, backgroundColor: UIColor? = nil, titleColor: UIColor? = nil, subtitleColor: UIColor? = nil, iconColor: UIColor? = nil, shadowColor: UIColor? = nil, shadowOffset: CGSize? = nil, shadowOpacity: Float? = nil, shadowRadius: CGFloat? = nil ,borderWidth: CGFloat? = nil, borderColor: UIColor? = nil) {
        self.removeFromSuperview()
        self.findMainWindow()
        guard let window = self.mainWindow else {
            print("Error: No Window found!")
            return
        }
        self.createView(with: window)
        self.toastView.view?.removeFromSuperview()
        self.toastView.view = nil
        if let view = expandedView {
            self.toastView.view = view
        }
        //Customize
          // - title
        self.toastView.title           = title
        self.toastView.titleFont       = titleFont       ?? .monospacedDigitSystemFont(ofSize: 13.25, weight: .medium)
        self.toastView.backgroundColor = backgroundColor ?? Color.background
        self.toastView.titleColor      = titleColor      ?? Color.title
          // - subtitle
        self.toastView.subtitle      = subtitle
        self.toastView.subtitleFont  = subtitleFont  ?? .monospacedDigitSystemFont(ofSize: 13, weight: .medium)
        self.toastView.subTitleColor = subtitleColor ?? Color.subtitle
          // - icon
        self.toastView.iconDirection = iconDirection ?? .left
        self.toastView.icon          = icon
        self.toastView.iconColor     = iconColor     ?? Color.title
        
        //Shadow
        self.toastView.layer.shadowColor   = (shadowColor  ?? UIColor.darkGray).cgColor
        self.toastView.layer.shadowOffset  = shadowOffset  ?? .init(width: 0, height: 6)
        self.toastView.layer.shadowOpacity = shadowOpacity ?? 0.25
        self.toastView.layer.shadowRadius  = shadowRadius  ?? 20
        
        //Border
        self.toastView.layer.borderWidth = borderWidth ?? 0.0
        self.toastView.layer.borderColor = borderColor?.cgColor
    }
    
    //MARK: - Full size frame
    
    /// Sets pre determined width and height constant constraints for the full size mode.
    /// - Parameters:
    ///   - width: Sets the constant width constraint.
    ///   - height: Sets the constant height constraint.
    open func fullSizeFrameConstraints(width: CGFloat?, height: CGFloat?) {
        self.fullSizeWidth = width
        self.fullSizeHeight = height
    }
    
    //MARK: - Show / Hide / Dismiss
    
    /// Shows toast notification.
    /// - Parameter direction: Sets the direction to display to toast from.
    /// - Parameter changeSubtitle: Changes the subtitle to a new string with a cross fade transition.
    /// - Parameter changeIcon: Changes the icon to a new image with a cross fade transition.
    /// - Parameter changeIconColor: Changes the icon color if it exists with a cross fade transition.
    /// - Parameter width: Sets the width of the toast.
    /// - Parameter height: Sets the height of the toast.
    /// - Parameter animationDuration: Sets the animation duration.
    /// - Parameter offset: Sets an offset from the top or bottom according to the direction.
    /// - Parameter cornerRadius: Sets the corner radius of the toast.
    /// - Parameter expandable: Adds a tap gesture to expand the toast and show the view that was inserted at prep time.
    /// - Parameter autoDismiss: Allows toast to hide/dismiss automatically after a certain time.
    /// - Parameter activeDuration: Sets the time it takes for the toast to hide/dismiss if auto dismiss is true.
    open func show(from direction: ToastyDirection, changeSubtitle: String? = nil, changeIcon: UIImage? = nil, changeIconColor: UIColor? = nil, width: CGFloat? = nil, height: CGFloat? = nil, animationDuration: TimeInterval? = nil, offset: CGFloat? = nil, cornerRadius: CGFloat? = nil, expandable: Bool? = nil, autoDismiss: Bool? = nil, activeDuration: TimeInterval? = nil) {
        DispatchQueue.main.async {
            UIView.transition(with: self.toastView, duration: 0.25, options: .transitionCrossDissolve) {
                if let text = changeSubtitle {
                    self.toastView.subtitle = text
                }
                if let icon = changeIcon {
                    self.toastView.icon = icon
                }
                if let color = changeIconColor {
                    self.toastView.iconColor = color
                }
            }
        }
        //since `directionTransform` is always set after showing, it is used to determine if it's being shown already thereby eliminating the need to show again.
        if self.directionTransform == nil {
            self.isVisible = true
            self.addSubview(self.toastView)
            self.direction = direction
            self.configToastFrame(width: width, height: height, offset: offset ?? -5)
            DispatchQueue.main.async {
                UIView.animate(withDuration: animationDuration ?? 0.45, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: [.preferredFramesPerSecond60, .curveEaseOut]) {
                    self.toastView.transform = .identity
                    self.toastView.layer.cornerRadius = cornerRadius ?? 25.0
                }
                expandability: if expandable ?? true {
                    if self.toastView.view == nil {
                        print(Warning.noFullViewEntered)
                        self.toastView.removeGestureRecognizer(self.tapGesture)
                        break expandability
                    }
                    self.toastView.addGestureRecognizer(self.tapGesture)
                } else {
                    self.toastView.removeGestureRecognizer(self.tapGesture)
                }
                if autoDismiss ?? false {
                    Timer.scheduledTimer(withTimeInterval: activeDuration ?? 2, repeats: false) { (_) in
                        self.hide()
                    }
                } else if self.toastView.view == nil && !(autoDismiss ?? false) { print(Warning.autoViewOffAndNoFullView) }                
            }
        }
    }
    
    /// Hides / dismisses toast notification.
    /// - Parameter animationDuration: Sets the animation duration.
    open func hide(animationDuration: TimeInterval? = nil) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: animationDuration ?? 0.2, delay: 0, options: [.preferredFramesPerSecond60, .curveEaseIn]) {
                if let transform = self.directionTransform {
                    if self.toastView.type == .expanded {
                        self.compactMode()
                    }
                    self.toastView.transform = transform
                } else {
                    print("Toast is not yet shown.")
                }
            } completion: { (_) in
                self.isVisible = false
                self.directionTransform = nil
                self.toastView.removeFromSuperview()
            }
        }
    }
    
    /// Hides / dismisses toast notification.
    /// - Parameter animationDuration: Sets the animation duration.
    open func dismiss(animationDuration: TimeInterval? = nil) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: animationDuration ?? 0.2, delay: 0, options: [.preferredFramesPerSecond60, .curveEaseIn]) {
                if let transform = self.directionTransform {
                    if self.toastView.type == .expanded {
                        self.compactMode()
                    }
                    self.toastView.transform = transform
                } else {
                    print("Toast is not yet shown.")
                }
            } completion: { (_) in
                self.isVisible = false
                self.directionTransform = nil
                self.toastView.removeFromSuperview()
            }
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
        switch direction {
        case .top:
            self.dismissButton?.transform = .init(translationX: 0, y: 40)
        case .bottom:
            self.dismissButton?.transform = .init(translationX: 0, y: -40)
        }
        self.dismissButtonTransform = self.dismissButton?.transform
        self.dismissButton?.addTarget(self, action: #selector(self.changeMode), for: .touchUpInside)
        self.layoutSubviews()
    }
    
    //constraints
    fileprivate func dismissButtonConstraints() {
        self.dismissButton?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.dismissButton!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        switch direction {
        case .top:
            NSLayoutConstraint(item: self.dismissButton!, attribute: .bottom, relatedBy: .equal, toItem: self.toastView, attribute: .top, multiplier: 1, constant: -5).isActive = true
        case .bottom:
            NSLayoutConstraint(item: self.dismissButton!, attribute: .top, relatedBy: .equal, toItem: self.toastView, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        }
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
    
    //MARK: - Modes
    
    fileprivate func fullSizeMode() {
        DispatchQueue.main.async {
            self.dismissButtonConfig()
            NSLayoutConstraint.deactivate(self.toastCompactWidthAndHeightConstraints)
            NSLayoutConstraint.activate(self.toastExpandedWidthAndHeightConstraints)
            self.toastView.removeGestureRecognizer(self.tapGesture)
            self.toastView.clipsToBounds = true
            self.toastView.type = .expanded
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
            blurView.alpha = 0
            blurView.addGestureRecognizer(self.tapGesture)
            blurView.frame = self.bounds
            self.insertSubview(blurView, at: 0)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 2.5, options: [.preferredFramesPerSecond60, .curveEaseInOut]) {
                blurView.alpha = 1
                self.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
                if self.direction == .top {
                    self.toastView.transform = .init(translationX: 0, y: 40)
                } else {
                    self.toastView.transform = .init(translationX: 0, y: -40)
                }
                self.layoutSubviews()
            }
            UIView.transition(with: self.dismissButton!, duration: 0.5, options: .transitionFlipFromTop, animations: {
                self.dismissButton?.alpha = 1
            }, completion: nil)
        }
    }
    
    fileprivate func compactMode() {
        DispatchQueue.main.async {
            NSLayoutConstraint.deactivate(self.toastExpandedWidthAndHeightConstraints)
            NSLayoutConstraint.activate(self.toastCompactWidthAndHeightConstraints)
            self.toastView.addGestureRecognizer(self.tapGesture)
            let blurView = self.subviews[0]
            blurView.removeGestureRecognizer(self.tapGesture)
            self.toastView.clipsToBounds = false
            self.toastView.view?.alpha = 0
            self.dismissButtonRemove()
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: [.preferredFramesPerSecond60, .curveEaseIn]) {
                blurView.alpha = 0
                self.toastView.transform = .identity
                self.backgroundColor = .clear
                self.layoutSubviews()
            } completion: { (_) in
                self.toastView.type = .compact
                blurView.removeFromSuperview()
            }
        }
    }
    
    //MARK: - objc
    
    @objc fileprivate func changeMode() {
        if let _ = self.directionTransform {
            switch self.toastView.type {
            case .compact:
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.09) {
                        self.toastView.transform = .init(scaleX: 0.96, y: 0.96)
                    } completion: { (_) in
                        UIView.animate(withDuration: 0.09) {
                            self.toastView.transform = .identity
                        } completion: { (_) in
                            self.fullSizeMode()
                        }
                    }
                }
            case .expanded:
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

private extension Toasty {
    
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
