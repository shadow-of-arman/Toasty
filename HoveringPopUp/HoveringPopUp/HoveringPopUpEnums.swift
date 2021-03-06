//
//  HoveringPopUpEnums.swift
//  HoveringPopUp
//
//  Created by Arman Zoghi on 3/2/21.
//

import Foundation

/// The state of the toast.
public enum HoveringPopUpState {
    /// The normal, compact form of the toast.
    case compact
    /// The full size state of the toast.
    case fullSize
}

/// The direction at which the toast will show from.
public enum HoveringPopUpDirection {
    /// Toast will arrive from the top.
    case top
    /// Toast will arrive from the bottom.
    case bottom
}

/// The direction that is used to change the position of the icon used in hovering pop up.
public enum HoveringPopUpIconDirection {
    /// The icon will show on the left of the title.
    case left
    /// The icon will show on the right of the title.
    case right
}
