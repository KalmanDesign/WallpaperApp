//
//  Text.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/11.
//

import SwiftUI
import WaterfallGrid
import SDWebImageSwiftUI

struct TopicsDetailView: View {
    @EnvironmentObject var vm: WallpaperViewModel
    @State private var currentTopic: WallpaperTopics? // 选中的话题
    @State private var selectedImageURL: String? // 新增：用于存储选中的图片 URL
    @State private var selectedWallpaper: WallpaperTopicsPhotos?
    
    
    let slug: String
    var body: some View {
        ScrollView(.vertical){
            ZStack{
                VStack(spacing:16){
                    //MARK: Pic
                    WebImage(url: URL(string: (vm.topics.first(where: {$0.slug == slug})?.previewPhotos.first?.urls.small ?? "")))
                        .resizable()
                        .aspectRatio(2/2, contentMode: .fill)
                        .overlay(alignment: .bottomLeading) {
                            LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
                                .frame(height: 180) // 调整高度以控制渐变的范围
                            VStack(alignment:.leading,spacing: 12){
                                VStack(alignment:.leading,spacing: 12){
                                    Text(vm.topics.first(where: { $0.slug == slug })?.slug.capitalized ?? "未知主题")
                                        .font(.largeTitle)
                                        .bold()
                                    Text(vm.topics.first(where: { $0.slug == slug })?.description ?? "No Description")
                                        .lineSpacing(8) // 调整行间距
                                }
                                .padding(12)
                            }
                            .foregroundColor(.white)
                        }
                    WaterfallGrid(vm.topicPhotos) { photo in
                        WebImage(url: URL(string: photo.urls.small))
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(8)
                            .onTapGesture {
                                selectedWallpaper = photo
                            }
                    }
                    .gridStyle(columns: 2,animation: .easeInOut(duration: 0.5))
                }
            }
        }
        .preferredColorScheme(.dark)
        .edgesIgnoringSafeArea(.all)
        .onAppear(){
            Task{
                await vm.fetchPhotosForTopic(slug: slug)
                await vm.fetchAllTopics()
                currentTopic = vm.topics.first
            }
        }
        .fullScreenCover(item: $selectedWallpaper){wallpaper in
            ImageDetailView(wallpaper: wallpaper)
        }
    }
    
}

#Preview {
    TopicsDetailView(slug: "architecture-interior")
        .environmentObject(WallpaperViewModel()) // 添加这一行
}
