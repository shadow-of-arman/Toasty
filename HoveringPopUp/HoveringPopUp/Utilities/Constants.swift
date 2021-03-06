//
//  Constants.swift
//  HoveringPopUp
//
//  Created by Arman Zoghi on 3/3/21.
//

import Foundation
import UIKit

/// The enum used to access main, commonly used values or functions.
enum Main {
    /// The bundle identifier of the framework.
    static let bundle = Bundle.init(identifier: "shadow.co.HoveringPopUp")
}

/// The enum used to access common colors throughout the framework.
enum Color {
    /// The background color.
    static let background = UIColor(named: "Background", in: Main.bundle, compatibleWith: nil)
    /// The color of the title text.
    static let title      = UIColor(named: "Title"     , in: Main.bundle, compatibleWith: nil)
    /// The color of the subtitle text.
    static let subtitle   = UIColor(named: "Subtitle"  , in: Main.bundle, compatibleWith: nil)
}

/// The enum used to display warnings throughout to the framework.
enum Warning {
    /// The warning to show when there is no full view entered even though expandable was set to true upon showing the toast.
    static let noFullViewEntered        = "Warning: toast was shown as expandable but no full view was entered, therefore expandability is being removed automatically!"
    /// The warning to show when the toast is shown with auto dismiss off and the toast isn't expandable either.
    static let autoViewOffAndNoFullView = "Warning: toast is not expandable and auto dismiss is off, you have to hide/dismiss the toast manually. are you sure this is the behavior you intended?"
    
}
