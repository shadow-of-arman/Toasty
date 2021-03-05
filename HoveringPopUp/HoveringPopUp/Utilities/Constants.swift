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
    static let title      = UIColor(named: "Title", in: Main.bundle, compatibleWith: nil)
    static let subtitle   = UIColor(named: "Subtitle", in: Main.bundle, compatibleWith: nil)
}
