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
    @State private var isShowingSplash = true
    
    var body: some View {
        ZStack{
            if isShowingSplash{
                SplashView()
            }else{
                TabView {
                    NavigationStack {
                        WallpaperListView()
                    }
                    .tabItem {
                        Label("home page", systemImage: "square.filled.on.square")
                    }
                    NavigationStack {
                        WallpaperTopicsView()
                    }
                    .tabItem {
                        Label("Topic", systemImage: "heart.text.square.fill")
                    }
                    
                    
                    NavigationStack {
                        FavoritesView()
                    }
                    .tabItem {
                        Label("Favorites", systemImage: "heart")
                    }
                    
                    NavigationStack {
                        SettingView()
                    }
                    .tabItem {
                        Label("Favorites", systemImage: "tray.fill")
                    }
                }
                .opacity(showTabView ? 1 : 0)  // 控制 TabView 的可见性
            }
        }
        .environmentObject(vm)
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                withAnimation {
                    isShowingSplash = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
