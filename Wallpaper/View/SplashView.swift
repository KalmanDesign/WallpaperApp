//
//  SplashView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/14.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var vm: WallpaperViewModel
    var body: some View {
        ZStack {
            Color.blue // 或者使用您的品牌颜色
        }
        .ignoresSafeArea()
        .onAppear(){
            Task {
                await vm.fetchRandomPhotos(num: 30)
                await vm.fetchAllTopics()
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(WallpaperViewModel())
}
