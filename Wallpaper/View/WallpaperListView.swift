//
//  WallpaperListView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/7.
//

import SwiftUI

struct WallpaperListView: View {
    @EnvironmentObject var vm: WallpaperViewModel
    @State private var isGrid = true
    @State private var hasLoaded: Bool = false  // 避免首次加载时出现空白
    @State private var selectedWallpaper: WallpaperModel?
    
    
    
    var body: some View {
        NavigationStack{
            Group{
                if vm.wallpaperList.isEmpty{
                    ProgressView()
                }else{
                    LazyWaterFallGrid(columns:withAnimation { isGrid ? 2 : 1},
                    items: vm.wallpaperList) { wallpaper in
                        CachedImageView(wallpaper:wallpaper)
                            .onTapGesture {
                                selectedWallpaper = wallpaper
                            }
                            .aspectRatio(contentMode: .fit)
                        
                        
                    }
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
        .onAppear {
            if !hasLoaded {
                Task {
                    await vm.fetchRandomPhotos(num: 30)
                    hasLoaded = true //
                }
            }
        }
        .fullScreenCover(item: $selectedWallpaper){wallpaper in
            NormalImage(wallpaper: wallpaper)
        }
    }
}



#Preview {
    WallpaperListView()
        .environmentObject(WallpaperViewModel())
}
