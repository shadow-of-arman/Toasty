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
    
    fileprivate var subtitleLabel : UILabel?
    
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
        self.backgroundColor = Color.background
    }
    
    //MARK: - Label
    
    //config
    fileprivate func labelConfig() {
        self.addSubview(self.titleLabel)
        self.titleLabel.textAlignment = .center
        titleLabel.text = "Silent Mode"
        self.titleLabel.textColor = Color.title
        self.titleLabel.font = .monospacedDigitSystemFont(ofSize: 13.5, weight: .medium)
        self.labelConstraints()
    }
    
    //constraints
    fileprivate func labelConstraints() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
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
            self.view?.alpha          = 0
            UIView.animate(withDuration: 0.4) {
                self.titleLabel.alpha     = 1
                self.subtitleLabel?.alpha = 1
            }
        case .fullSize:
            UIView.animate(withDuration: 0.4) {
                self.view?.alpha          = 1
                self.titleLabel.alpha     = 0
                self.subtitleLabel?.alpha = 0
            }
        }
    }
    
}
