//
//  FavoritesView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/9.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var vm: WallpaperViewModel
    @State private var isGrid = true
    @State private var selectedWallpaper: WallpaperModel?  // 改回 WallpaperModel
    
    var body: some View {
        NavigationStack {
            Group {
                if vm.getFavoriteWallpapers().isEmpty {
                    VStack {
                        Spacer()
                        Text("暂时没有收藏")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                } else {
                    LazyWaterFallGrid(columns: 2, items: vm.getFavoriteWallpapers().compactMap { $0 as? WallpaperModel }) { wallpaper in
                        CachedImageView(wallpaper: wallpaper)
                            .onTapGesture {
                                selectedWallpaper = wallpaper
                            }
                    }
                }
            }
        }
        .navigationTitle("My Favorite")
        .toolbar {
            if !vm.getFavoriteWallpapers().isEmpty{
                ToolbarItem {
                    Image(systemName: isGrid ? "rectangle.grid.2x2.fill" : "rectangle.grid.1x2.fill")
                        .onTapGesture {
                            withAnimation {
                                isGrid.toggle()
                            }
                        }
                }
            }
        }
        .fullScreenCover(item: $selectedWallpaper){wallpaper in
            NormalImage(wallpaper: wallpaper)
        }
    }
}


#Preview {
    FavoritesView()
        .environmentObject(WallpaperViewModel())
}
