//
//  ContentView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/7.
//

import SwiftUI



struct ContentView: View {
    @StateObject private var vm = WallpaperViewModel()
    @State private var showTabView = true // 是否显示TabView
    
    var body: some View {
        ZStack{
            
            TabView {
                NavigationStack {
                    WallpaperListView()
                }
                .tabItem {
                    Label("home page", systemImage: "square.filled.on.square")
                }
                
                NavigationStack {
                    FavoritesView()
                }
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
                
                NavigationStack {
                    WallpaperTopicsView()
                }
                .tabItem {
                    Label("Topic", systemImage: "heart.text.square.fill")
                }
            }
            .opacity(showTabView ? 1 : 0)  // 控制 TabView 的可见性
        }
        .environmentObject(vm)
    }
}

#Preview {
    ContentView()
}
