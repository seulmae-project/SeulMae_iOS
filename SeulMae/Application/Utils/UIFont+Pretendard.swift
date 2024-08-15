//
//  UIFont+Pretendard.swift
//  SeulMae
//
//  Created by 조기열 on 8/15/24.
//

import UIKit

extension UIFont {
    //        Pretendard Variable
    //        ====> PretendardVariable-Regular
    //        ====> PretendardVariable-Thin
    //        ====> PretendardVariable-ExtraLight
    //        ====> PretendardVariable-Light
    //        ====> PretendardVariable-Medium
    //        ====> PretendardVariable-SemiBold
    //        ====> PretendardVariable-Bold
    //        ====> PretendardVariable-ExtraBold
    //        ====> PretendardVariable-Black
    
    class func pretendard(size: CGFloat, weight: PretendardWeight) -> UIFont {
        return UIFont(name: "PretendardVariable-\(weight.description)", size: size) ?? UIFont()
    }
    
    enum PretendardWeight: CustomStringConvertible {
        case thin, extraLight, light, regular, medium, semibold, bold, extraBold, black
        
        var description: String {
            switch self {
            case .thin: return "Thin"
            case .extraLight: return "ExtraLight"
            case .light: return  "Light"
            case .regular: return "Regular"
            case .medium: return  "Medium"
            case .semibold: return "SemiBold"
            case .bold: return "Bold"
            case .extraBold: return "ExtraBold"
            case .black: return "Black"
            }
        }
    }
}
