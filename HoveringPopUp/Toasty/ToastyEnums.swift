//
//  ToastyEnums.swift
//  Toasty
//
//  Created by Arman Zoghi on 3/2/21.
//

import Foundation

/// The state of the toast.
public enum ToastyState {
    /// The normal, compact form of the toast.
    case compact
    /// The expanded state of the toast.
    case expanded
}

/// The direction at which the toast will show from.
public enum ToastyDirection {
    /// Toast will arrive from the top.
    case top
    /// Toast will arrive from the bottom.
    case bottom
}

/// The  position of the icon used in toasty view.
public enum ToastyIconPosition {
    /// The icon will show on the left of the title.
    case left
    /// The icon will show on the right of the title.
    case right
}
