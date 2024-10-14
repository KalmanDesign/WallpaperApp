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
    
    var body: some View {
        NavigationStack {
            Group {
                if vm.favoriteItems.isEmpty {
                    VStack {
                        Spacer()
                        Text("暂时没有收藏")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        WaterfallGrid(vm.favoriteItems, id: \.id) { wallpaper in
                        NavigationLink(destination: ImageDetailView(wallpaper: wallpaper).toolbar(.hidden,for: .tabBar)) {
                            WebImage(url: URL(string: getImageUrl(wallpaper)))
                                // .resizable()
                                // .scaledToFill()
                                .transition(.fade(duration: 0.5))
                                .cornerRadius(12)
                                // .aspectRatio(contentMode: .fill)
                                .aspectRatio(3/4, contentMode: .fill) // 设置宽高比为 3:4
                             
                        }
                        }
                        .gridStyle(
                            columnsInPortrait: 1,
                            columnsInLandscape: 3,
                            spacing: 16,
                            animation: .easeInOut(duration: 0.5)
                        )
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                    }
                }
            }
            .navigationTitle("我的收藏")
            .toolbar {
                ToolbarItem {
                        Button(action: {
                            Task{
                                vm.deleteFavorite()
                            }
                        }) {
                            Image(systemName: "trash.fill")
                        }
                        
                       
                    
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            vm.getFavoriteList()
        }
    }
    
   private func getImageUrl(_ item: any WallpaperItem) -> String {
    let url: String
    switch item {
    case let model as WallpaperModel:
        url = model.urls.small
        print("获取壁纸模型的图片 URL: \(url)")
    case let photo as WallpaperTopicsPhotos:
        url = photo.urls.small
        print("获取主题照片的图片 URL: \(url)")
    case let topic as WallpaperTopics:
        url = topic.previewPhotos.first?.urls.small ?? ""
        print("获取主题预览照片的图片 URL: \(url)")
    default:
        url = ""
        print("未知的壁纸项类型，返回空 URL")
    }
    print("Image URL for item \(item.id): \(url)")
    return url
}
}

#Preview {
    FavoritesView()
        .environmentObject(WallpaperViewModel())
}
