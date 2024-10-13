//
//  WallpaperListView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/7.
//

import SwiftUI
import WaterfallGrid
import SDWebImageSwiftUI

struct WallpaperListView: View {
    @EnvironmentObject var vm: WallpaperViewModel
    @State private var isGrid = true
    @State private var hasLoaded: Bool = false  // 避免首次加载时出现空白
    @State private var selectedWallpaper: WallpaperModel?
    @State private var scrollToTop = false
    
    var body: some View {
        NavigationStack{
            if vm.wallpaperList.isEmpty {
                ProgressView()
            } else {
                ScrollView(showsIndicators: false) {
                    WallpaperGridView(wallpapers: vm.allWallpapers, isGrid: isGrid)
                    Button(action: {
                        Task {
                            await vm.fetchRandomPhotos(num: 10)
                            scrollToTop = true
                        }
                    }, label: {
                        Text("随机生成")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(360)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                    })
                }
                
            }
            
        }
        .navigationTitle("Wallpaper")
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
        .preferredColorScheme(.dark)
        .onAppear {
            if !hasLoaded {
                Task {
                    await vm.fetchRandomPhotos(num: 30)
                    hasLoaded = true
                }
            }
        }
    }
}

struct WallpaperGridView: View {
    let wallpapers: [WallpaperModel]
    let isGrid: Bool
//    let onTapWallpaper: (WallpaperModel) -> Void
    
    var body: some View {
        WaterfallGrid(wallpapers) { wallpaper in
            NavigationLink(destination: ImageDetailView(wallpaper: wallpaper).toolbar(.hidden,for: .tabBar)){
                WebImage(url: URL(string: wallpaper.urls.smallS3))
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
                  
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

#Preview {
    WallpaperListView()
        .environmentObject(WallpaperViewModel())
}
