//
//  CategoryGrid.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/15.
//

import SwiftUI

struct CategoryGrid: View {
    @ObservedObject var vm: PickerViewModel
    @State var offSet: CGFloat = Constant.screenWidth / 2 - 60
    @Binding var currentHex: String
    @Binding var currentCategory: ClothCategory
    let rows = [GridItem(.fixed(44))]
    var body: some View {
        LazyHGrid(rows: rows, spacing: 40) {
            ForEach(ClothCategory.allCases) { category in
                Text(category.koreanSubtitle)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(category == vm.currentType ? Color(hex: "FF5100") : Color(hex: "A0A0A0"))
                    .onTapGesture {
                        // 맥락 바꾸기.
                        vm.changeCategory(with: category)
                        currentHex = vm.currentPresets.first!
                        withAnimation(.spring()) {
                            switch vm.currentType {
                            case .hat:
                                offSet = Constant.screenWidth / 2 - 60
                            case .top:
                                offSet = Constant.screenWidth / 2 - 120
                            case .bottom:
                                offSet = Constant.screenWidth / 2 - 190
                            case .shoes:
                                offSet = Constant.screenWidth / 2 - 265
                            case .accessories:
                                offSet = Constant.screenWidth / 2 - 330
                            }
                        }
                        currentCategory = category
                    }
            }
            .offset(x: offSet, y: 0)
        }
    }
}

