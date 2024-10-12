//
//  NormalToastView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/12.
//

import SwiftUI

struct NormalToastView: View {
    let isShow:Bool
    let message: String
    let iconImage: String
    let contentColor: Color
    var body: some View {
        if isShow{
            HStack{
                Image(systemName: iconImage)
                    .foregroundStyle(contentColor)
                Text(message)
            }
            .font(.title3)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            // .background(.black.opacity(0.3))
            .background(.ultraThinMaterial)  // 使用系统提供的磨砂玻璃效果
            .cornerRadius(12)
            .padding()
        }
    }
}

#Preview {
    NormalToastView(isShow: true, message: "Save Success", iconImage: "checkmark.seal.fill", contentColor: .white)
}
