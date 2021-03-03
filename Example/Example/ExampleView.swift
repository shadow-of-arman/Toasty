//
//  exampleView.swift
//  Example
//
//  Created by Arman Zoghi on 3/3/21.
//

import Foundation
import UIKit

class ExampleView: UIView {
    
    
    //MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
}
