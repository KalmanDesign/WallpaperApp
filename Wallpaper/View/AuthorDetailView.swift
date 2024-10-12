//
//  AuthorDetailView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/7.
//

import SwiftUI
struct AuthorDetailView: View {
    let wallpaper: any WallpaperItem
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
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
        .edgesIgnoringSafeArea(.top)
    }
//    
//   private var socialMediaIcons: some View {
//    HStack(spacing: 16) {
//        if let instagram = wallpaper.wallpaperUser.name, !instagram.isEmpty {
//            socialIcon(name: "instagram", url: "https://www.instagram.com/\(instagram)")
//        }
//        if let twitter = wallpaper.wallpaperUser.name, !twitter.isEmpty {
//            socialIcon(name: "X", url: "https://x.com/\(twitter)")
//        }
//        if let paypal = wallpaper.wallpaperUser.name, !paypal.isEmpty {
//            socialIcon(name: "paypal", url: paypal)
//        }
//        if let portfolio = wallpaper.wallpaperUser.name, !portfolio.isEmpty {
//            socialIcon(name: "portfolio", url: portfolio)
//        }
//    }
//}
//    
//    private func socialIcon(name: String, url: String?) -> some View {
//        Image(name)
//            .resizable()
//            .scaledToFit()
////            .frame(width: name == "X" ? 32 : 30)
//            .frame(width: name == "portfolio" ? 28: 32)
//            .onTapGesture {
//                if let urlString = url, let url = URL(string: urlString) {
//                    UIApplication.shared.open(url)
//                }
//            }
//    }
}

#Preview {
    AuthorDetailView(wallpaper: WallpaperModel.sampleWallpaper)
}
