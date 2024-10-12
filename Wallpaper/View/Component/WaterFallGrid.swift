//
//  WaterfallGrid.swift
//  Pokemon
//
//  Created by Kalman on 2024/10/4.
//







import SwiftUI

struct WaterFallGrid<Content: View, T: Identifiable>: View {
    let columns: Int
    let items: [T]
    let content: (T, CGFloat) -> Content
    
    init(columns: Int, items: [T], @ViewBuilder content: @escaping (T, CGFloat) -> Content) {
        self.columns = columns
        self.items = items
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            // 修改宽度计算，考虑到边距和列间距
            let width = (geometry.size.width - CGFloat(columns - 1) * 10 - 20) / CGFloat(columns)
            ScrollView {
                HStack(alignment: .top, spacing: 10) {
                    ForEach(0..<columns, id: \.self) { columnIndex in
                        LazyVStack(spacing: 10) {
                            ForEach(Array(items.enumerated().filter { $0.offset % columns == columnIndex }), id: \.element.id) { _, item in
                                content(item, width)
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
        }
    }
}








// import SwiftUI

// struct WaterFallGrid<Content: View, T: Identifiable>: View {
//     let columns: Int
//     let list: [T]
//     let content: (T, CGFloat) -> Content
//     let spacing: CGFloat
//     let padding: EdgeInsets
    
//     init(
//         columns: Int,
//         list: [T],
//         spacing: CGFloat = 16,
//         padding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
//         @ViewBuilder content: @escaping (T, CGFloat) -> Content
//     ) {
//         self.columns = columns
//         self.list = list
//         self.spacing = spacing
//         self.padding = padding
//         self.content = content
//     }
    
//     var body: some View {
//         GeometryReader { geometry in
//             let width = (geometry.size.width - padding.leading - padding.trailing - (CGFloat(columns - 1) * spacing)) / CGFloat(columns)
            
//             ScrollView {
//                 HStack(alignment: .top, spacing: spacing) {
//                     ForEach(0..<columns, id: \.self) { columnIndex in
//                         LazyVStack(spacing: spacing) {
//                             ForEach(Array(list.enumerated().filter { $0.offset % columns == columnIndex }), id: \.element.id) { _, item in
//                                 content(item, width)
//                             }
//                         }
//                     }
//                 }
//                 .padding(padding)
//             }
//         }
//     }
// }

// //#Preview {
// //    WaterfallGrid()
// //}
