//
//  FavoritesView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/9.
//

import SwiftUI
import WaterfallGrid
import SDWebImageSwiftUI

struct FavoritesView: View {
    @EnvironmentObject var vm: WallpaperViewModel
    @State private var selectedWallpaper: (any WallpaperItem)?
    @State private var isGrid = true // 添加这行
    
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
                    ScrollView(showsIndicators: false) {
                        WaterfallGrid(vm.getFavoriteWallpapers(), id: \.id) { wallpaper in
                            WebImage(url: URL(string: getImageUrl(wallpaper)))
                               .resizable()
                                .scaledToFit()
                                .cornerRadius(8)
                                .aspectRatio(contentMode: .fit)
                                .onTapGesture {
                                    selectedWallpaper = wallpaper
                                }
                        }
                        .gridStyle(
                            columnsInPortrait: isGrid ? 2 : 1,
                            columnsInLandscape: 3,
                            spacing: 8,
                            animation: .easeInOut(duration: 0.5)
                        )
                        .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                        
                        
                        
                    }
                    
                }
            }
            .navigationTitle("我的收藏")
            .toolbar {
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
        .preferredColorScheme(.dark)
        //        .fullScreenCover(item: $selectedWallpaper){wallpaper in
        //            ImageDetailView(wallpaper: wallpaper as! WallpaperItem)
        //        }
    }
    private func getImageUrl(_ item: any WallpaperItem) -> String {
        switch item {
        case let model as WallpaperModel:
            return model.urls.small
        case let photo as WallpaperTopicsPhotos:
            return photo.urls.small
        case let topic as WallpaperTopics:
            return topic.previewPhotos.first?.urls.small ?? ""
        default:
            return ""
        }
    }
    
}


#Preview {
    FavoritesView()
        .environmentObject(WallpaperViewModel())
}
