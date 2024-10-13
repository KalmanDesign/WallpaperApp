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
                    WebImage(url: URL(string: wallpaper.wallpaperUser.profileImageLarge ?? ""))
                        .frame(height: 80)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .clipped()
                    
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

#Preview {
    AuthorDetailView(wallpaper: WallpaperModel.sampleWallpaper)
}
