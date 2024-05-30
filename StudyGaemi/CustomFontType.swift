//
//  CustomFontType.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 5/30/24.
//

import Foundation

enum CustomFontType {
    case thin
    case light
    case regular
    case medium
    case semiBold
    case bold
    case extraLight
    case extraBold
    case black
    
    var name: String {
        switch self {
        case .thin:
            return "Pretendard-Thin"
        case .light:
            return "Pretendard-Light"
        case .regular:
            return "Pretendard-Regular"
        case .medium:
            return "Pretendard-Medium"
        case .semiBold:
            return "Pretendard-SemiBold"
        case .bold:
            return "Pretendard-Bold"
        case .extraLight:
            return "Pretendard-ExtraLight"
        case .extraBold:
            return "Pretendard-ExtraBold"
        case .black:
            return "Pretendard-Black"
        }
    }
}
