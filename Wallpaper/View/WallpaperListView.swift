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
    @State private var scrollToTop = false
    
    
    
    var body: some View {
        NavigationStack{
            
            Group{
                if vm.wallpaperList.isEmpty{
                    ProgressView()
                }else{
                    ScrollView{
                       LazyWaterFallGrid(columns: isGrid ? 2 : 1,
                                          items: vm.allWallpapers) { wallpaper in
                           CachedImageView(wallpaper:wallpaper)
                                .onTapGesture {
                                    selectedWallpaper = wallpaper
                                }
                                .aspectRatio(contentMode: .fit)
                                .animation(.easeInOut, value: isGrid)
                                .transition(.opacity)
                        }
                        
                        Button(action: {
                            Task{
                                await vm.fetchRandomPhotos(num: 30)
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
        }
        .preferredColorScheme(.dark)
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
                    await vm.fetchRandomPhotos(num: 24)
                    hasLoaded = true //
                }
            }
        }
        .fullScreenCover(item: $selectedWallpaper){wallpaper in
            ImageDetailView(wallpaper: wallpaper)
        }
    }
}



#Preview {
    WallpaperListView()
        .environmentObject(WallpaperViewModel())
}
