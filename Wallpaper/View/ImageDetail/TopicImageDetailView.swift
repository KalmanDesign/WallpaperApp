//
//  TopicImageDetailView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/11.
//

import SwiftUI

// MARK: - ImageDetailView
struct TopicImageDetailView: View {
    let topicWallpaper: any WallpaperItem
    @EnvironmentObject var vm: WallpaperViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isImageLoaded = false
    @State private var isShowSheet = false
    @State private var showToast = false // 新增：控制 toast 显示的状态
    @State private var toastOffset: CGFloat = UIScreen.main.bounds.height * 1.3 + 100 // 初始位置在屏幕外
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                AsyncImageView(
                    imageURL:(topicWallpaper as? WallpaperTopicsPhotos)?.urls.full ?? "",
                    imageCornerRadius: 0
                ) { loaded in
                    isImageLoaded = loaded
                }
                // .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    HStack {
                        backButton
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }
                .opacity(isImageLoaded ? 1 : 0)
                if !showToast {
                    ToastView(message: "收藏成功", item: topicWallpaper)
                        .zIndex(1)
                        .transition(.identity)
                        .position(x:UIScreen.main.bounds.width / 2)
                        .offset(y: toastOffset)
                        .animation(.spring(response: 0.6, dampingFraction: 0.6), value: toastOffset)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $isShowSheet) {
            if let topicSheet = topicWallpaper as? WallpaperTopicsPhotos{
                AuthorDetailView(wallpaper: topicSheet)
                    .presentationDetents([.medium])
            }
        }
    }
    
    // MARK: - backButton
    private var backButton: some View {
        HStack{
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .frame(width: 40,height: 40)
                    .background(.black.opacity(0.4))
                    .cornerRadius(360)
            }
            
            
            Button{
                isShowSheet.toggle()
            }label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.white)
                    .frame(width: 40,height: 40)
                    .background(.black.opacity(0.4))
                    .cornerRadius(360)
            }
            
            
            Button{
                vm.toogleFavorite(for: topicWallpaper)
                let impact = UIImpactFeedbackGenerator(style: .rigid)
                impact.impactOccurred()
                
                withAnimation {
                    toastOffset = UIScreen.main.bounds.height * 0.8
                    print("显示 Toast")
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    print("隐藏 Toast")
                    withAnimation {
                        toastOffset = UIScreen.main.bounds.height * 1.3 + 100 // 回到屏幕外
                    }
                }
                
            }label: {
                Image(systemName: vm.isFavorite(topicWallpaper) ? "heart.fill" : "heart")
                    .foregroundColor(vm.isFavorite(topicWallpaper) ? .red : .white)
                    .frame(width: 40, height: 40)
                    .background(.black.opacity(0.4))
                    .cornerRadius(20)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    TopicImageDetailView(topicWallpaper: WallpaperTopicsPhotos.samplePhoto)
        .environmentObject(WallpaperViewModel()) // 添加这一行
}
