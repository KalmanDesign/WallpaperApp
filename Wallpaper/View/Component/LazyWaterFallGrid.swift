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
            HStack(alignment: .top, spacing: spacing) {
                ForEach(0..<columns, id: \.self) { columnIndex in
                    LazyVStack(spacing: spacing) {
                        ForEach(Array(items.enumerated().filter { $0.offset % columns == columnIndex }), id: \.element.id) { _, item in
                            content(item)
                        }
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
        }
    }
}
