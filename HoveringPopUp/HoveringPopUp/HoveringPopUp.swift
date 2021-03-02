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
    
    open var compactTitleString: String? {
        didSet {
            
        }
    }
    
    fileprivate var viewConstraints : [NSLayoutConstraint] = []
    
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
    
    //MARK: - Pop Up
    
    open func popFrom(direction: HoveringPopUpDirection) {
        
    }
    
    
    
}
