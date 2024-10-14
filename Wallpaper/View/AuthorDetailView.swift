//
//  AuthorDetailView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/7.
//

import SwiftUI
import SDWebImageSwiftUI

struct AuthorDetailView: View {
    let wallpaper: any WallpaperItem
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 0) {
                    ProfileImageView(imageUrl: wallpaper.wallpaperUser.profileImageLarge ?? "", size: 100)
                    VStack(spacing: 8) {
                        Text(wallpaper.wallpaperUser.name)
                            .font(.title)
                            .bold()
                        Text(wallpaper.wallpaperUser.bio ?? "The author has not yet filled in his personal profile")
                            .font(.body)
                            .padding(.bottom, 12)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 12)
                    .padding(.top, 12)
                }
                .padding(.top, 24)
                .frame(maxWidth: .infinity)
            }
            .frame(width: geo.size.width)
        }
        .preferredColorScheme(.dark)
        .edgesIgnoringSafeArea(.top)
    }
}

struct ProfileImageView:View {
    let imageUrl: String?
    let size:CGFloat
    var body: some View {
         if let imageUrl = imageUrl,
            let url = URL(string: imageUrl) {
             WebImage(url: url)
                 .resizable()
                 .aspectRatio(contentMode: .fill)
                 .frame(width: size, height: size)
                 .background(Color.white) // 添加默认白色背景
                 .clipShape(Circle())
         } else {
             defaultImage
         }
     }
     
     private var placeholderImage: some View {
         Image(systemName: "person.crop.circle.fill")
             .resizable()
             .aspectRatio(contentMode: .fit)
             .foregroundColor(.gray)
             .background(Color.white) // 添加默认白色背景
             .clipShape(Circle())
     }
     
     private var defaultImage: some View {
         Image(systemName: "person.fill")
             .resizable()
             .aspectRatio(contentMode: .fit)
             .frame(width: size, height: size)
             .foregroundColor(.gray)
             .background(Color.white) // 添加默认白色背景
             .clipShape(Circle())
     }
 }





#Preview {
    AuthorDetailView(wallpaper: WallpaperModel.sampleWallpaper)
}
