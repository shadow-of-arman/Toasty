//
//  popUpView.swift
//  HoveringPopUp
//
//  Created by Arman Zoghi on 3/2/21.
//

import Foundation
import UIKit

class popUpView: UIView {
    
    //MARK: ----- Constants -----
    
    fileprivate let label : UILabel = UILabel()
    
    //MARK: ----- Variables -----
    
    /// Sets the current type of the popUpView
    internal var type : HoveringPopUpState = .compact {
        didSet {
            switch type {
            case .compact:
                print("compact")
            case .fullSize:
                print("fullSize")
            }
        }
    }
    
    /// The view to show when in full size mode.
    internal var view : UIView? {
        didSet {
            guard let _ = self.view else { return }
            self.addView()
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
    
    //MARK: - Label
    
    //config
    fileprivate func labelConfig() {
        self.addSubview(self.label)
        self.labelConstraints()
    }
    
    //constraints
    fileprivate func labelConstraints() {
        self.label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    //MARK: - Add View
    
    //config
    fileprivate func addView() {
        self.addSubview(self.view!)
        self.viewConstraints()
    }
    
    //constraints
    fileprivate func viewConstraints() {
        self.view!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.view!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.view!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.view!, attribute: .width  , relatedBy: .equal, toItem: self, attribute: .width  , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.view!, attribute: .height , relatedBy: .equal, toItem: self, attribute: .height , multiplier: 1, constant: 0).isActive = true
    }
    
}
