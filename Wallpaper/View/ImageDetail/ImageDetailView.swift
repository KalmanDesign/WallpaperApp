//
//  NormalImage.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/12.
//

import SwiftUI
import SDWebImageSwiftUI



// MARK: - 视图定义
struct ImageDetailView: View {
    let wallpaper: any WallpaperItem
    @EnvironmentObject var vm: WallpaperViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isImageLoaded = false
    @State private var isShowSheet = false
    @State private var showFavoriteToast = false
    @State private var showSaveToast = false
    @State private var overlayState: Int = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                WebImage(url: URL(string: imageURL))
                    .resizable()
                    .scaledToFill()
                    .blur(radius: overlayState == 1 ? 10 : 0)
                    .scaleEffect(overlayState == 1 ? 1.2 : 1)
            }
        }
        .edgesIgnoringSafeArea(.all)
       
        .overlay(alignment:.top){
            NormalToastView(isShow: showFavoriteToast,
                            message: vm.isFavorite(wallpaper) ? "Favorite successfully" : "Collection failed",
                            iconImage: vm.isFavorite(wallpaper) ? "heart.fill" :"heart.slash.fill",
                            contentColor: vm.isFavorite(wallpaper) ? .red : .white)
            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0), value: showFavoriteToast)
            
            NormalToastView(isShow: showSaveToast, message: "Save Success", iconImage: "checkmark", contentColor: .green)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0), value: showFavoriteToast)
            
        }
        .overlay(alignment:.bottom){
            if overlayState == 1 {
                IconGirdView()
                    .zIndex(0)
                
            }
            if overlayState == 2 {
                ZStack {
                    Color.black.opacity(0.3)
                    LockScreenView()
                        .scaledToFit()
                }
                .edgesIgnoringSafeArea(.all)
                .zIndex(0)
            }
        }
         .overlay(alignment:.bottom) {
            buttonGroup
                .padding(.horizontal,16)
                .zIndex(100)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $isShowSheet) {
            AuthorDetailView(wallpaper: wallpaper)
                .presentationDetents([.fraction(0.32), .medium])
                .presentationCornerRadius(32)
                .presentationBackground(.ultraThinMaterial)
        }
    }
    
    // MARK: - 图片URL获取
    private var imageURL:String{
        if let wallpaperModel = wallpaper as? WallpaperModel{
            return wallpaperModel.urls.full
        }else if let topicPhots = wallpaper as? WallpaperTopicsPhotos{
            return topicPhots.urls.full
        }
        return ""
    }
    
    // MARK: - 覆盖状态图标
    private var overlayStateIcon: String {
        switch overlayState {
        case 0:
            return "square.grid.2x2"
        case 1:
            return "lock"
        case 2:
            return "xmark.circle"
        default:
            return "square.grid.2x2"
        }
    }
    
    
    // MARK: - 按钮组
    private var buttonGroup: some View {
        HStack{
            // 返回按钮
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .frame(width: 40,height: 40)
                    .background(.black.opacity(0.4))
                    .cornerRadius(360)
            }
            Spacer()
            
            // 信息按钮
            Button{
                isShowSheet.toggle()
            }label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.white)
                    .frame(width: 40,height: 40)
                    .background(.black.opacity(0.4))
                    .cornerRadius(360)
            }
            
            // 收藏按钮
            Button{
                vm.toogleFavorite(for: wallpaper)
                let impact = UIImpactFeedbackGenerator(style: .rigid)
                impact.impactOccurred()
                withAnimation {
                    showFavoriteToast = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showFavoriteToast = false
                    }
                }
            }label: {
                Image(systemName: vm.isFavorite(wallpaper) ? "heart.fill" : "heart")
                    .foregroundColor(vm.isFavorite(wallpaper) ? .red : .white)
                    .frame(width: 40, height: 40)
                    .background(.black.opacity(0.4))
                    .cornerRadius(20)
            }
            
            // 覆盖状态按钮
            Button{
                withAnimation {
                    overlayState = (overlayState + 1) % 3
                }
            }label: {
                Image(systemName:overlayStateIcon)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(.black.opacity(0.4))
                    .cornerRadius(20)
            }
            
            // 保存按钮
            Button {
                
                vm.saveImage(from: imageURL) {_ in}
                let impact = UIImpactFeedbackGenerator(style: .rigid)
                impact.impactOccurred()
                withAnimation {
                    showSaveToast = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showSaveToast = false
                    }
                }
            } label: {
                Image(systemName: "arrow.down.to.line")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(.black.opacity(0.4))
                    .cornerRadius(20)
            }
        }
    }
}

// MARK: - 预览
#Preview {
    ImageDetailView(wallpaper: WallpaperModel.sampleWallpaper)
        .environmentObject(WallpaperViewModel())
}
