//
//  PickerViewModel.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/13.
//

import SwiftUI

class PickerViewModel: ObservableObject {
    //MARK: - Propeties
    @Published var currentType: ClothCategory = .hat
    @Published var currentPresets: [String] = []
    @Published var currentItems: [String] = []
    @Published var selectedItems: [Cloth] = []

    
    // presets 이차원 배열 key : ClothCategory , value -> [String]
    var presets: [ClothCategory : [String]] = [
        .hat : ["FFFFFF", "000000", "325593", "2E614E", "AD5139", "DF002B"],
        .top : ["FFFFFF", "000000", "BAD2F5", "C5C5C7", "23293F", "00914E", "3F2D24", "32323B", ""],
        .bottom : ["FFFFFF", "C5C5C7", "ACC8E0", "1D2433", "FAF3E6", "CBAF86", "6D7A3B"],
        .socks : ["FFFFFF", "000000"],
        .shoes : ["FFFFFF", "000000", "8D8983", "AC9F80"]
    ]
    
    var items: [ClothCategory: [String]] = [
        .hat : ["cap", "suncap"],
        .top : [ "short", "long",  "shirts", "shirtslong", "sleeveless", "pkshirts", "onepiece", "pkonepiece"],
        .bottom : ["shorts", "skirtshort", "skirtsa", "long", "skirtlong", "bottom"],
        .socks : [],
        .shoes : ["sandals", "sneakers", "socks", "women"]
    ]
    
    //MARK: - LifeCycle
    init() {
        changeCategory(with: .hat)
    }
    
    //MARK: - Methods
    func addPreset(hex: String) {
        if currentPresets.contains(hex) {
            print("DEBUG: 중복된 hexcode preset")
            return
        }
    }
    
    func changeCategory(with category: ClothCategory) {
        currentType = category
        currentPresets = presets[category]!
        //옷 아이템도 변경해주기.
        currentItems = items[category]!
    }
}

