//
//  Cloth.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/14.
//

import Foundation

struct Cloth: Identifiable {
    var id: String
    var hex: String
    var category: ClothCategory
}

enum ClothCategory: String, CaseIterable, Identifiable {
    case hat
    case top
    case bottom
    case socks
    case shoes
    
    var id: ClothCategory {
        self
    }
    
    var koreanSubtitle: String {
        switch self {
        case .hat:
            return "모자"
        case .top:
            return "상의"
        case .bottom:
            return "하의"
        case .socks:
            return "양말"
        case .shoes:
            return "신발"
        }
    }
}
