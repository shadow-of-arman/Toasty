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
    
    /// Label used to show the title when in compact mode.
    fileprivate let compactLabel : UILabel = UILabel()
    
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
    
    //MARK: - View Lifecycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    //MARK: - Create View
    
    fileprivate func createView() {
        
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
                }
            }
        } else {
            if let window = UIApplication.shared.keyWindow {
                self.mainWindow = window
            }
        }
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
    open func preparePopUp(fullView: UIView, title: String, font: UIFont?, backgroundColor: UIColor?, textColor: UIColor?, shadowColor: UIColor?, borderWidth: CGFloat?, borderColor: UIColor?) {

        self.findMainWindow()
        
    }
    
    //MARK: - Pop Up
    
    /// Pops up!
    /// - Parameter direction: Sets the direction to display to pop up from.
    open func popFrom(direction: HoveringPopUpDirection) {
        
    }
    
    
    
}
