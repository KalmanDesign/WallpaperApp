//
//  LazyWaterFallGrid.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/11.
//

import SwiftUI

struct LazyWaterFallGrid<Content: View, T: Identifiable>: View {
    let columns: Int
    let items: [T]
    let content: (T) -> Content
    let spacing: CGFloat
    let horizontalPadding: CGFloat
    
    init(columns: Int, items: [T], spacing: CGFloat = 10, horizontalPadding: CGFloat = 10, @ViewBuilder content: @escaping (T) -> Content) {
        self.columns = columns
        self.items = items
        self.content = content
        self.spacing = spacing
        self.horizontalPadding = horizontalPadding
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: spacing) {
                ForEach(0..<rows, id: \.self) { rowIndex in
                    HStack(spacing: spacing) {
                        ForEach(0..<columns, id: \.self) { columnIndex in
                            if let item = itemAt(row: rowIndex, column: columnIndex) {
                                content(item)
                            } else {
                                Color.clear
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
        }
    }
    
    private var rows: Int {
        (items.count + columns - 1) / columns
    }
    
    private func itemAt(row: Int, column: Int) -> T? {
        let index = row * columns + column
        return index < items.count ? items[index] : nil
    }
}
