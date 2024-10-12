//
//  SettingsView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/9.
//
import SwiftUI

struct WallpaperTopicsView: View {
    @EnvironmentObject var vm:WallpaperViewModel
    @State private var hasLoaded: Bool = false  // 避免首次加载时出现空白
    var body: some View {
        NavigationStack{
            if vm.topics.isEmpty{
                ProgressView()
            }else{
                ScrollView(.vertical,showsIndicators: false){
                    ForEach(vm.topics,id: \.id){topic in
                        NavigationLink(destination: TopicsDetailView(slug: topic.slug)) {
                            TopicCard(topic: topic)
                        }
                    }
                }
                .padding(.bottom,24)
                .navigationTitle("Topics")
            }
        }
        .preferredColorScheme(.dark)
        .onAppear(){
            if !hasLoaded{
                Task{
                    await vm.fetchAllTopics()
                    hasLoaded = true
                }
            }
        }
    }
}
struct TopicCard:View {
    let topic:WallpaperTopics
    var body: some View {
        ZStack{
            AsyncImageView(imageURL: topic.previewPhotos.first?.urls.small ?? "", imageCornerRadius: 24){_ in}
                .aspectRatio(2/3,contentMode: .fill)
                .overlay(alignment:.bottom){
                    VStack(alignment:.leading,spacing:12){
                        Text(topic.slug.capitalized)
                            .font(.title2)
                            .bold()
                        Text(topic.description)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.ultraThinMaterial)  // 使用系统提供的磨砂玻璃效果
                    .foregroundColor(.white)
                    .cornerRadius(24)
                }
                .padding(.top,12)
                .padding(.horizontal,16)
        }
    }
}

#Preview {
    WallpaperTopicsView()
        .environmentObject(WallpaperViewModel()) // 添加这一行
}
