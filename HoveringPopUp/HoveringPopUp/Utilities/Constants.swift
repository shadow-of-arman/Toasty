//
//  Constants.swift
//  HoveringPopUp
//
//  Created by Arman Zoghi on 3/3/21.
//

import Foundation
import UIKit

enum Main {
    static let bundle = Bundle.init(identifier: "shadow.co.HoveringPopUp")
}

enum Color {
    static let background = UIColor(named: "Background", in: Main.bundle, compatibleWith: nil)
    static let title      = UIColor(named: "Title"     , in: Main.bundle, compatibleWith: nil)
    static let subtitle   = UIColor(named: "Subtitle"  , in: Main.bundle, compatibleWith: nil)
}

enum Warning {
    static let noFullViewEntered        = "Warning: toast was shown as expandable but no full view was entered, therefore expandability is being removed automatically!"
    static let autoViewOffAndNoFullView = "Warning: toast is not expandable and auto dismiss is off, you have to hide/dismiss the toast manually. are you sure this is the behavior you intended?"
    
}
