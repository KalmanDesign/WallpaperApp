//
//  AuthorDetailView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/7.
//

import SwiftUI

// 定义 AuthorDetailView 结构体，遵循 View 协议
struct AuthorDetailView: View {
    // 定义 wallpaper 属性，类型为 any WallpaperItem
    let wallpaper: any WallpaperItem
    
    // 定义 body 属性，返回一个 View
    var body: some View {
        // 使用 GeometryReader 获取屏幕尺寸
        GeometryReader { geo in
            // 创建一个 ScrollView
            ScrollView {
                // 创建一个 VStack，用于布局视图
                VStack(spacing: 0) {
                    // 图片视图
                    AsyncImageView(imageURL: wallpaper.wallpaperUser.profileImageLarge ?? "", imageCornerRadius: 0) { _ in }
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.width * 0.62)
                        .clipped()
                    
                    // 作者信息视图
                    VStack(alignment: .leading, spacing: 8) {
                        Text(wallpaper.wallpaperUser.name)
                            .font(.title)
                            .bold()
                        Text(wallpaper.wallpaperUser.bio ?? "The author has not yet filled in his personal profile")
                            .font(.body)
                            .padding(.bottom, 12)
                        
                        // 社交媒体图标
//                        HStack(spacing: 16) {
//                            socialMediaIcons
//                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .padding(.top, 12)
                }
            }
            .frame(width: geo.size.width)
        }
        .preferredColorScheme(.dark)
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    AuthorDetailView(wallpaper: WallpaperModel.sampleWallpaper)
}
