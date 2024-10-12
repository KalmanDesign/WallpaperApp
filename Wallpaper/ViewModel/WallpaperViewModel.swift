//
//  WallpaperViewModel.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/7.
//

//收藏列表暂无法展示 topic 的收藏内容

import Foundation

class WallpaperViewModel:ObservableObject{
    @Published var wallpaper: WallpaperModel? // 当前壁纸
    @Published var wallpaperList: [WallpaperModel] = [] // 壁纸列表
    @Published var topics: [WallpaperTopics] = [] // 主题列表
    @Published var topicPhotos: [WallpaperTopicsPhotos] = [] // 主题的照片列表
    
    
    @Published var isLoading = false // 是否正在加载
    @Published var errorMassage: String? // 错误信息
    @Published var favoriteWallpapers: [String] = [] // 收藏的壁纸id
    @Published var favoriteItems: [any WallpaperItem] = []
    
    private let wallpaperAPI = APIService() // 壁纸API
    
    
    func fetchRandomPhotos(num: Int) async{
        self.isLoading = true
        self.errorMassage = nil
        do{
            let result = try await wallpaperAPI.fetchRandomPhotos(count: num)
            await MainActor.run {
                self.wallpaperList = result
            }
        }catch{
            errorMassage = "Failed to fetch wallpapers"
            print("Failed to fetch wallpapers")
        }
        self.isLoading = false
    }
    
    func fetchTopics()async{ // 获取主题列表
        do{
            let result = try await wallpaperAPI.fetchTopicList()
            // print("获取到的主题: \(result)")  // 添加这行
            await MainActor.run {
                self.topics = result
            }
        }catch{
            errorMassage = "Failed to fetch wallpapers"
            print("Failed to fetch wallpapers")
            print("错误: \(error)")  // 添加这行
            
        }
    }
    
    func fetchAllTopics(startPage: Int = 1, endPage: Int = 10)async{ // 获取所有主题列表
        do{
            var allTopics: [WallpaperTopics] = []
            for page in startPage...endPage {
                let pageTopics = try await wallpaperAPI.fetchTopicList(page: page)
                allTopics.append(contentsOf: pageTopics)
            }
            
            self.topics = allTopics
            
        }catch{
            await MainActor.run {
                self.errorMassage = "获取主题列表时出错：\(error.localizedDescription)"
            }
        }
    }
    
    func fetchPhotosForTopic(slug: String) async {  // 获取主题的照片
        isLoading = true
        do {
            let photos = try await wallpaperAPI.fetchPhotosForTopic(slug: slug)
            await MainActor.run {
                self.topicPhotos = photos
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMassage = "获取主题照片时出错：\(error.localizedDescription)"
                self.isLoading = false
            }
            print("Failed to fetch photos for topic")
            print("错误: \(error)")
        }
    }
    
    
    // 切换壁纸的收藏状态
    func toogleFavorite(for item: any WallpaperItem){
        // 检查是否已经收藏了该壁纸
        if favoriteWallpapers.contains(item.id) {
            // 如果已经收藏，则移除
            favoriteWallpapers.removeAll { $0 == item.id }
        } else {
            // 如果未收藏，则添加
            favoriteWallpapers.append(item.id)
        }
        // 每次调用都打印出favoriteWallpapers列表的内容
        print("当前收藏的壁纸ID列表: \(favoriteWallpapers)")
        
        // 更新收藏列表
        getFavoriteList()
    }
    
    // 检查壁纸是否已收藏
    func isFavorite(_ item: any WallpaperItem) -> Bool{
        // 通过检查收藏列表中是否包含该壁纸的id来判断是否收藏
        return favoriteWallpapers.contains(item.id)
    }
    
    
    
    // 获取收藏的壁纸
    func getFavoriteWallpapers()->[any WallpaperItem]{
        // 使用filter函数过滤出收藏的壁纸
//        return wallpaperList.filter{favoriteWallpapers.contains($0.id)}
        return favoriteItems
    }
    
    
    
    //MARK:  获取收藏列表
    func getFavoriteList() {
        var newFavoriteItems: [any WallpaperItem] = []
        
        // 遍历所有的壁纸列表，添加已收藏的项
        for wallpaper in wallpaperList where favoriteWallpapers.contains(wallpaper.id) {
            newFavoriteItems.append(wallpaper)
        }
        
        // 遍历所有的主题照片列表，添加已收藏的项
        for photo in topicPhotos where favoriteWallpapers.contains(photo.id) {
            newFavoriteItems.append(photo)
        }
        
        // 遍历所有的主题列表，添加已收藏的项
        for topic in topics where favoriteWallpapers.contains(topic.id) {
            newFavoriteItems.append(topic)
        }
        
        // 更新 favoriteItems 属性
        DispatchQueue.main.async {
            self.favoriteItems = newFavoriteItems
        }
    }
}
