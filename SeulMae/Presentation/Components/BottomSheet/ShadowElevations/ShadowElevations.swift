//
//  File.swift
//  SeulMae
//
//  Created by 조기열 on 6/19/24.
//

import UIKit

@propertyWrapper
public struct ShadowElevation {
    public var wrappedValue: CGFloat

    public init(wrappedValue: CGFloat) {
        self.wrappedValue = wrappedValue
    }
}

public struct ShadowElevations {

    @ShadowElevation public static var appBar: CGFloat = 4.0
    @ShadowElevation public static var bottomAppBar: CGFloat = 8.0
    @ShadowElevation public static var bottomNavigationBar: CGFloat = 8.0
    @ShadowElevation public static var cardPickedUp: CGFloat = 8.0
    @ShadowElevation public static var cardResting: CGFloat = 2.0
    @ShadowElevation public static var dialog: CGFloat = 24.0
    @ShadowElevation public static var fabPressed: CGFloat = 12.0
    @ShadowElevation public static var fabResting: CGFloat = 6.0
    @ShadowElevation public static var menu: CGFloat = 8.0
    @ShadowElevation public static var modalActionSheet: CGFloat = 8.0
    @ShadowElevation public static var modalBottomSheet: CGFloat = 16.0
    @ShadowElevation public static var navDrawer: CGFloat = 16.0
    @ShadowElevation public static var none: CGFloat = 0.0
    @ShadowElevation public static var picker: CGFloat = 24.0
    @ShadowElevation public static var quickEntry: CGFloat = 3.0
    @ShadowElevation public static var quickEntryResting: CGFloat = 2.0
    @ShadowElevation public static var raisedButtonPressed: CGFloat = 8.0
    @ShadowElevation public static var raisedButtonResting: CGFloat = 2.0
    @ShadowElevation public static var refresh: CGFloat = 3.0
    @ShadowElevation public static var rightDrawer: CGFloat = 16.0
    @ShadowElevation public static var searchBarResting: CGFloat = 2.0
    @ShadowElevation public static var searchBarScrolled: CGFloat = 3.0
    @ShadowElevation public static var snackbar: CGFloat = 6.0
    @ShadowElevation public static var subMenu: CGFloat = 9.0
    @ShadowElevation public static var `switch`: CGFloat = 1.0
}
