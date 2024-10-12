//
//  ToastView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/9.
//







import SwiftUI

struct ToastView: View {
    let message: String
    let item: any WallpaperItem
    //   let wallpaper:WallpaperModel
    @EnvironmentObject var vm:WallpaperViewModel
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: vm.isFavorite(item) ? "heart.fill" : "heart.slash.fill")
                .foregroundColor(vm.isFavorite(item) ? .red : .white)
            Text(vm.isFavorite(item) ? "收藏成功" : "取消收藏")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.7))
        .foregroundColor(.white)
        .cornerRadius(20)
    }
}

#Preview {
    ToastView(message: "收藏成功", item: WallpaperModel.sampleWallpaper)
}





//
//import SwiftUI
//
//struct ToastView: View {
//   let message: String
//   let wallpaper:WallpaperModel
//   @EnvironmentObject var vm:WallpaperViewModel
//
//   var body: some View {
//       HStack(spacing: 8) {
//           Image(systemName: vm.isFavorite(wallpaper) ? "heart.fill" : "heart.slash.fill")
//                           .foregroundColor(vm.isFavorite(wallpaper) ? .red : .white)
//                       Text(vm.isFavorite(wallpaper) ? "收藏成功" : "取消收藏")
//       }
//       .padding(.horizontal, 16)
//       .padding(.vertical, 12)
//       .background(Color.black.opacity(0.7))
//       .foregroundColor(.white)
//       .cornerRadius(20)
//   }
//}
//
//#Preview {
//   ToastView(message: "收藏成功", wallpaper: WallpaperModel.sampleWallpaper)
//}
