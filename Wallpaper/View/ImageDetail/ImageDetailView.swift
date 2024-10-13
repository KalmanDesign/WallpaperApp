//
//  NormalImage.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/12.
//

import SwiftUI

// MARK: - 图片详细视图
// 定义 NormalImage 结构体，遵循 View 协议
struct ImageDetailView: View {
    // 定义 wallpaper 属性，类型为 any WallpaperItem
    let wallpaper: any WallpaperItem
    // 使用 @EnvironmentObject 获取 WallpaperViewModel 实例
    @EnvironmentObject var vm: WallpaperViewModel
    // 使用 @Environment 获取 presentationMode
    @Environment(\.presentationMode) var presentationMode
    // 定义状态变量，用于控制图片加载、sheet 显示、toast 显示和滑块显示
    @State private var isImageLoaded = false
    @State private var isShowSheet = false
    @State private var showFavoriteToast = false // 新增：控制 toast 显示的状态
    @State private var toastOffset: CGFloat = UIScreen.main.bounds.height * 1.3 + 100 // 初始位置在屏幕外
    @State private var showSlide = false
    @State private var blurValue: Double = 0
    @State private var showSaveToast = false
    
    var body: some View {
        // 使用 GeometryReader 获取屏幕尺寸
        GeometryReader { geo in
            ZStack {
                // 设置背景颜色
                Color.black.edgesIgnoringSafeArea(.all)
                // 使用 AsyncImageView 加载图片
                AsyncImageView(
                    imageURL: imageURL,
                    imageCornerRadius: 0
                ) { loaded in
                    // 更新图片加载状态
                    isImageLoaded = loaded
                }
                // 设置图片模糊效果
                .blur(radius: blurValue)
                .edgesIgnoringSafeArea(.all)
                // 设置按钮和滑块的视图
                VStack {
                    Spacer()
                    VStack(spacing:24){
                        // 根据 showSlide 状态显示或隐藏滑块
                        if showSlide{
                            Slider(value:$blurValue,in: 1...20)
                        }
                        HStack {
                            // 显示返回按钮
                            buttonGroup
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }   
            }
        }
        .overlay(alignment:.top){
            // 显示 收藏toast
            NormalToastView(isShow: showFavoriteToast,
                            message: vm.isFavorite(wallpaper) ? "Favorite successfully" : "Collection failed",
                            iconImage: vm.isFavorite(wallpaper) ? "heart.fill" :"heart.slash.fill",
                            contentColor: vm.isFavorite(wallpaper) ? .red : .white)
            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0), value: showFavoriteToast)

            // 显示 保存toast
            NormalToastView(isShow: showSaveToast, message: "Save Success", iconImage: "checkmark", contentColor: .green)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0), value: showFavoriteToast)

        }
        // 隐藏导航栏
        .navigationBarHidden(true)
        // 设置 sheet，用于显示作者详细信息
        .sheet(isPresented: $isShowSheet) {
            AuthorDetailView(wallpaper: wallpaper)
                .presentationDetents([.fraction(0.32), .medium])
        }
    }
    
    // 计算图片 URL
    private var imageURL:String{
        // 根据 wallpaper 类型返回不同的 URL
        if let wallpaperModel = wallpaper as? WallpaperModel{
            return wallpaperModel.urls.full
        }else if let topicPhots = wallpaper as? WallpaperTopicsPhotos{
            return topicPhots.urls.full
        }
        return ""
    }
    
    // MARK: - 按钮组
    // 定义返回按钮、信息按钮、收藏按钮和滑块按钮
    private var buttonGroup: some View {
        HStack{
            // 显示返回按钮
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
            

            // 显示信息按钮
            Button{
                isShowSheet.toggle()
            }label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.white)
                    .frame(width: 40,height: 40)
                    .background(.black.opacity(0.4))
                    .cornerRadius(360)
            }
            
            // 显示收藏按钮
            Button{
                vm.toogleFavorite(for: wallpaper)
                let impact = UIImpactFeedbackGenerator(style: .rigid)
                impact.impactOccurred()
                withAnimation {
                    showFavoriteToast = true // 直接设置 showToast 为 true，而不是 toggle
                    // print("显示 Toast")
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showFavoriteToast = false
                        // print("隐藏 Toast")                    
                        }
                }
            }label: {
                Image(systemName: vm.isFavorite(wallpaper) ? "heart.fill" : "heart")
                    .foregroundColor(vm.isFavorite(wallpaper) ? .red : .white)
                    .frame(width: 40, height: 40)
                    .background(.black.opacity(0.4))
                    .cornerRadius(20)
            }
            
            // 显示滑块按钮
            Button{
                withAnimation {
                    showSlide.toggle()
                }
            }label: {
                Image(systemName:showSlide ? "heart.fill" : "heart")
                    .foregroundColor(showSlide ? .red : .white)
                    .frame(width: 40, height: 40)
                    .background(.black.opacity(0.4))
                    .cornerRadius(20)
            }
            
            // 显示保存按钮
            Button {
                vm.saveImage(from: imageURL) {_ in}
                let impact = UIImpactFeedbackGenerator(style: .rigid)
                impact.impactOccurred()
                withAnimation {
                    showSaveToast = true 
                    print("下载完成，显示 Toast")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showSaveToast = false
                        print("隐藏 Toast")                    
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
    // 预览 NormalImage，传入样本壁纸
    ImageDetailView(wallpaper: WallpaperModel.sampleWallpaper)
        .environmentObject(WallpaperViewModel()) // 添加这一行
}
