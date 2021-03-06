//
//  PopUpView.swift
//  HoveringPopUp
//
//  Created by Arman Zoghi on 3/2/21.
//

import Foundation
import UIKit

class PopUpView: UIView {
    
    //MARK: ----- Constants -----
    
    fileprivate let titleLabel    : UILabel = UILabel()
    
    //MARK: ----- Variables -----
    
    fileprivate var titleCenterYConstraint : NSLayoutConstraint?
    fileprivate var titleCenterXConstraint : NSLayoutConstraint?
    fileprivate var subtitleLabel : UILabel?
    fileprivate var iconImageView : UIImageView?
    
    /// Sets the current type of the popUpView
    internal var type : HoveringPopUpState = .compact {
        didSet {
            self.changeMode()
        }
    }
    
    /// The view to show when in full size mode.
    internal var view : UIView? {
        didSet {
            guard let _ = self.view else { return }
            self.addView()
        }
    }
    
    /// Sets the title.
    internal var title : String? {
        didSet {
            self.titleLabel.text = self.title            
        }
    }
    
    /// Sets the title color.
    internal var titleColor : UIColor? {
        didSet {
            self.titleLabel.textColor = self.titleColor
        }
    }
    
    /// Sets the font.
    internal var titleFont : UIFont? {
        didSet {
            self.titleLabel.font = self.titleFont
        }
    }
    
    /// Configs subtitle view and sets the subtitle text.
    internal var subtitle : String? {
        didSet {
            if let text = self.subtitle {
                if self.subtitleLabel == nil {
                    self.subTitleLabelConfig(text: text)
                } else {
                    self.subtitleLabel?.text = text
                }
            }
        }
    }
    
    /// Sets the subtitle font.
    internal var subtitleFont : UIFont? {
        didSet {
            if let label = self.subtitleLabel {
                label.font = self.subtitleFont
            }
        }
    }
    
    /// Sets the subtitle color.
    internal var subTitleColor : UIColor? {
        didSet {
            if let label = self.subtitleLabel {
                label.textColor = self.subTitleColor
            }
        }
    }
    
    /// Decides where to put the icon.
    internal var iconDirection: HoveringPopUpIconDirection? = .left
    
    /// Configures the icon image view and sets the icon as it's image.
    internal var icon: UIImage? {
        didSet {
            if let icon = self.icon {
                if self.iconImageView == nil {
                    self.iconImageViewConfig(image: icon)
                } else {
                    self.iconImageView?.image = icon
                }
            }
        }
    }
    
    internal var iconColor: UIColor? {
        didSet {
            if let color = iconColor {
                self.iconImageView?.image?.withRenderingMode(.alwaysTemplate)
                self.iconImageView?.tintColor = color
            }
        }
    }
        
    //MARK: - View Lifecycle
    
    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    /// - Parameter frame: The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the `center` and `bounds` properties accordingly.
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initialConfig()
    }
    
    /// Returns an object initialized from data in a given unarchiver.
    /// - Parameter coder: An unarchiver object.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialConfig()
    }
    
    //MARK: - Initial Config
    
    fileprivate func initialConfig() {
        self.labelConfig()
    }
    
    //MARK: - Title
    
    //config
    fileprivate func labelConfig() {
        self.addSubview(self.titleLabel)
        self.titleLabel.textAlignment = .center
        self.labelConstraints()
    }
    
    //constraints
    fileprivate func labelConstraints() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleCenterYConstraint =  NSLayoutConstraint(item: self.titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        self.titleCenterXConstraint =  NSLayoutConstraint(item: self.titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([self.titleCenterYConstraint!, self.titleCenterXConstraint!])
    }
    
    //MARK: - Subtitle
    
    //config
    fileprivate func subTitleLabelConfig(text: String) {
        self.subtitleLabel = UILabel()
        self.addSubview(self.subtitleLabel!)
        self.subtitleLabelConstraints()
        self.subtitleLabel?.text = text
    }
    
    //constraints
    fileprivate func subtitleLabelConstraints() {
        self.subtitleLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.titleCenterYConstraint?.constant = -8.5
        NSLayoutConstraint(item: self.subtitleLabel!, attribute: .top, relatedBy: .equal, toItem: self.titleLabel, attribute: .bottom, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: self.subtitleLabel!, attribute: .centerX, relatedBy: .equal, toItem: self.titleLabel, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    //MARK: - Icon
    
    //config
    fileprivate func iconImageViewConfig(image: UIImage) {
        self.iconImageView = UIImageView(image: image)
        self.iconImageView?.contentMode = .scaleAspectFit
        self.addSubview(self.iconImageView!)
        self.iconImageView?.tintColor = Color.title
        self.iconImageViewConstraints()
    }
    
    //constraints
    fileprivate func iconImageViewConstraints() {
        self.iconImageView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.iconImageView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 7.5).isActive = true
        if self.iconDirection == .left {
            NSLayoutConstraint(item: self.iconImageView!, attribute: .right, relatedBy: .equal, toItem: self.titleLabel, attribute: .left, multiplier: 1, constant: -15).isActive = true
        } else {
            NSLayoutConstraint(item: self.iconImageView!, attribute: .left, relatedBy: .equal, toItem: self.titleLabel, attribute: .right, multiplier: 1, constant: 15).isActive = true
        }
        NSLayoutConstraint(item: self.iconImageView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -7.5).isActive = true
        NSLayoutConstraint(item: self.iconImageView!, attribute: .width, relatedBy: .equal, toItem: self.iconImageView!, attribute: .height, multiplier: 1, constant: 0).isActive = true
        self.layoutSubviews()
        if self.iconDirection == .left {
            self.titleCenterXConstraint?.constant = (self.iconImageView?.frame.width)! / 1.2
        } else {
            self.titleCenterXConstraint?.constant = -(self.iconImageView?.frame.width)! / 1.2
        }
    }
    
    //MARK: - Add View
    
    //config
    fileprivate func addView() {
        self.addSubview(self.view!)
        self.viewConstraints()
        self.view?.alpha = 0
    }
    
    //constraints
    fileprivate func viewConstraints() {
        self.view!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.view!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.view!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.view!, attribute: .width  , relatedBy: .equal, toItem: self, attribute: .width  , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.view!, attribute: .height , relatedBy: .equal, toItem: self, attribute: .height , multiplier: 1, constant: 0).isActive = true
    }
    
    fileprivate func changeMode() {
        switch type {
        case .compact:
            self.view?.alpha = 0
            UIView.animate(withDuration: 0.15) {
                self.titleLabel.alpha     = 1
                self.subtitleLabel?.alpha = 1
                self.iconImageView?.alpha = 1
            }
        case .fullSize:
            self.titleLabel.alpha     = 0
            self.subtitleLabel?.alpha = 0
            self.iconImageView?.alpha = 0
            UIView.animate(withDuration: 0.4) {
                self.view?.alpha = 1
            }
        }
    }
    
}
