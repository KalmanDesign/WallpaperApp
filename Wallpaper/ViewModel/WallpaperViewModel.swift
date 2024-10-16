//
//  WallpaperViewModel.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/7.
//

//收藏列表暂无法展示 topic 的收藏内容

import Foundation
import UIKit
import Photos

@MainActor
class WallpaperViewModel:ObservableObject{
    // 当前壁纸
    @Published var wallpaper: WallpaperModel?
    // 壁纸列表
    @Published var wallpaperList: [WallpaperModel] = []
    // 主题列表
    @Published var topics: [WallpaperTopics] = []
    // 主题的照片列表
    @Published var topicPhotos: [WallpaperTopicsPhotos] = []
    // 新增：存储所有获取过的壁纸
    @Published var allWallpapers: [WallpaperModel] = []
    // 是否正在加载
    @Published var isLoading = false
    // 错误信息
    @Published var errorMassage: String?
    // 收藏的壁纸id
    @Published var favoriteWallpapers: [String] = []
    // 收藏的壁纸项目
    @Published var favoriteItems: [any WallpaperItem] = []
    // 是否正在保存图片
    @Published var isSavingImage = false
    // 保存图片的错误信息
    @Published var saveImageError: String?
    // 用户设置，是否裁剪图片
    @Published var shouldCropImage: Bool = false
    // 是否使用自定义相册
    @Published var useCustomAlbum: Bool = false
    // 自定义相册名称
    @Published var customAlbumName: String = "Kwallpaper"

    // 壁纸API
    private let wallpaperAPI = APIService()
    
    // MARK: - 获取随机照片
    func fetchRandomPhotos(num: Int) async{
        isLoading = true
        errorMassage = nil
        let maxRetries = 3 // 最大重试次数
        var retries = 0 // 当前重试次数
        while retries < maxRetries {
            do{
                let result = try await wallpaperAPI.fetchRandomPhotos(count: num)
                await MainActor.run {
                    self.wallpaperList.append(contentsOf: result)
                    self.allWallpapers.append(contentsOf: result)
                    self.allWallpapers = Array(NSOrderedSet(array: self.allWallpapers)) as! [WallpaperModel]
                }
                break // 成功获取后退出循环
            }catch let error as NSError{
                retries += 1 // 每次失败都增加重试次数
                errorMassage = "获取壁纸失败, 错误信息: \(error.localizedDescription)"
                if retries == maxRetries {
                    print("达到最大重试次数，停止重试")
                    break // 达到最大重试次数后退出循环
                }
            }
        }
        self.isLoading = false
    }
    
    // MARK: - 获取主题列表
    func fetchTopics()async{
        do{
            let result = try await wallpaperAPI.fetchTopicList()
            await MainActor.run {
                self.topics = result
            }
        }catch{
            errorMassage = "Failed to fetch wallpapers"
            print("Failed to fetch wallpapers")
            print("错误: \(error)")
        }
    }
    
    // MARK: - 获取所有主题列表
    func fetchAllTopics(startPage: Int = 1, endPage: Int = 10)async{
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
    
    // MARK: - 获取主题的照片
    func fetchPhotosForTopic(slug: String, retries: Int = 3) async {
        isLoading = true
        var currentRetry = 0
        
        while currentRetry < retries {
            do {
                let photos = try await wallpaperAPI.fetchPhotosForTopic(slug: slug)
                await MainActor.run {
                    self.topicPhotos = photos
                    self.isLoading = false
                }
                return
            } catch {
                currentRetry += 1
                if currentRetry == retries {
                    await MainActor.run {
                        self.errorMassage = "获取主题照片失败，已重试\(retries)次：\(error.localizedDescription)"
                        self.isLoading = false
                        print("获取主题照片最终失败")
                        print("错误详情: \(error)")
                    }
                } else {
                    print("获取主题照片失败，正在进行第\(currentRetry)次重试")
                    do {
                        try await Task.sleep(nanoseconds: 1_000_000_000) // 等待1秒后重试
                    } catch {
                        print("在等待重试时发生错误: \(error)")
                    }
                }
            }
        }
    }
    
    // MARK: - 切换壁纸的收藏状态
    func toogleFavorite(for item: any WallpaperItem) {
        if favoriteWallpapers.contains(item.id) {
            favoriteWallpapers.removeAll { $0 == item.id }
            favoriteItems.removeAll { $0.id == item.id }
        } else {
            favoriteWallpapers.append(item.id)
            favoriteItems.append(item)
        }
        print("当前收藏的壁纸项目数量: \(favoriteItems.count)")
        
        getFavoriteList()
    }
    
    // MARK: - 检查壁纸是否已收藏
    func isFavorite(_ item: any WallpaperItem) -> Bool{
        return favoriteWallpapers.contains(item.id)
    }
    
    // MARK: - 获取收藏的壁纸
    func getFavoriteWallpapers()->[any WallpaperItem]{
        getFavoriteList() // 每次获取收藏列表时都更新
        return favoriteItems
    }
    
    // MARK: - 删除收藏的壁纸
    func deleteFavorite() -> [any WallpaperItem]{
        favoriteWallpapers.removeAll()
        favoriteItems.removeAll()
        return favoriteItems
    }
    
    // MARK:  获取收藏列表
    func getFavoriteList() {
        var newFavoriteItems: [any WallpaperItem] = []
        
        for wallpaper in allWallpapers where favoriteWallpapers.contains(wallpaper.id) {
            newFavoriteItems.append(wallpaper)
        }
        
        for photo in topicPhotos where favoriteWallpapers.contains(photo.id) {
            newFavoriteItems.append(photo)
        }
        
        for topic in topics where favoriteWallpapers.contains(topic.id) {
            newFavoriteItems.append(topic)
        }
        
        DispatchQueue.main.async {
            self.favoriteItems = newFavoriteItems
            print("更新后的收藏项目数量: \(self.favoriteItems.count)")
        }
    }
    
    // MARK:  保存图片的方法
    func saveImage(from urlString: String, completion: @escaping (Bool) -> Void) {
        // 使用 guard 语句检查图片 URL 是否有效
        guard let imageURL = URL(string: urlString) else {
            // 如果图片 URL 无效，设置错误信息并调用 completion 回调
            DispatchQueue.main.async {
                self.saveImageError = "无效的图片 URL"
                print("图片 URL 无效: \(urlString)") // 打印无效的图片 URL
            }
            completion(false)
            return
        }
        
        // 设置正在保存图片的状态为 true
        DispatchQueue.main.async {
            self.isSavingImage = true
        }
        
        // 使用 URLSession 发起数据任务
        URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            // 检查 self 是否存在
            guard let self = self else { return }
            
            // 在任务结束后，设置正在保存图片的状态为 false
            defer {
                DispatchQueue.main.async {
                    self.isSavingImage = false
                }
            }
            
            // 检查是否有错误
            if let error = error {
                // 如果有错误，处理错误并调用 completion 回调
                DispatchQueue.main.async {
                    self.handleSaveError("下载图片失败: \(error.localizedDescription)")
                    print("下载图片失败: \(error.localizedDescription)") // 打印错误信息
                }
                completion(false)
                return
            }
            
            // 检查是否有数据和图片
            guard let data = data, let image = UIImage(data: data) else {
                // 如果没有数据或无法创建图片，处理错误并调用 completion 回调
                DispatchQueue.main.async {
                    self.handleSaveError("无法创建图片")
                    print("无法创建图片") // 打印错误信息
                }
                completion(false)
                return
            }
            
            // 请求访问相册的权限
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                guard let self = self else { return }
                
                switch status {
                case .authorized:
                    // 保持原有的 authorized 代码不变
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAsset(from: image)
                    }) { success, error in
                        DispatchQueue.main.async {
                            if success {
                                self.saveImageError = nil
                                completion(true)
                            } else if let error = error {
                                self.handleSaveError("保存图片失败: \(error.localizedDescription)")
                                completion(false)
                            }
                        }
                    }
                case .denied, .restricted:
                    DispatchQueue.main.async {
                        self.handleSaveError("没有访问相册的权限")
                        completion(false)
                    }
                case .notDetermined:
                    DispatchQueue.main.async {
                        self.handleSaveError("请在设置中允许访问相册")
                        completion(false)
                    }
                case .limited:
                    // 处理有限访问权限的情况
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAsset(from: image)
                    }) { success, error in
                        DispatchQueue.main.async {
                            if success {
                                self.saveImageError = nil
                                completion(true)
                            } else if let error = error {
                                self.handleSaveError("保存图片失败（有限访问权限）: \(error.localizedDescription)")
                                completion(false)
                            }
                        }
                    }
                @unknown default:
                    DispatchQueue.main.async {
                        self.handleSaveError("未知的授权状态")
                        completion(false)
                    }
                }
            }
        }.resume()
    }
    
    // 处理保存图片的错误
    private func handleSaveError(_ message: String) {
        // 在主线程中设置保存图片的错误信息
        DispatchQueue.main.async {
            self.saveImageError = message
        }
    }
    
    // MARK: - 保存图片
    func saveImage(url: URL, completion: @escaping (Bool, String?) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    let finalImage = self.shouldCropImage ? self.cropImageToScreenSize(image) : image
                    self.saveImageToCustomAlbum(finalImage, useCustomAlbum: self.useCustomAlbum, albumName: self.customAlbumName) { success, error in
                        if success {
                            completion(true, "图片成功保存到 \(self.useCustomAlbum ? self.customAlbumName : "相机胶卷") 相册")
                        } else {
                            completion(false, "保存图片失败: \(error?.localizedDescription ?? "未知错误")")
                        }
                    }
                } else {
                    completion(false, "加载图片失败: \(error?.localizedDescription ?? "Failed to load image")")
                }
            }
        }.resume()
    }

    // MARK: - 图像处理
    func cropImageToScreenSize(_ image: UIImage) -> UIImage {
        let screenSize = UIScreen.main.bounds.size
        let imageSize = image.size
        let scale = max(screenSize.width / imageSize.width, screenSize.height / imageSize.height)
        
        let scaledWidth = imageSize.width * scale
        let scaledHeight = imageSize.height * scale
        let xOffset = (scaledWidth - screenSize.width) / 2
        let yOffset = (scaledHeight - screenSize.height) / 2
        
        UIGraphicsBeginImageContextWithOptions(screenSize, false, 0)
        image.draw(in: CGRect(x: -xOffset, y: -yOffset, width: scaledWidth, height: scaledHeight))
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return croppedImage ?? image
    }

    // MARK: - 图像保存
    func saveImageToCustomAlbum(_ image: UIImage, useCustomAlbum: Bool = true, albumName: String = "Kwallpaper", completion: @escaping (Bool, Error?) -> Void) {
        func save() {
            PHPhotoLibrary.shared().performChanges({
                let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                guard let assetPlaceholder = assetRequest.placeholderForCreatedAsset else {
                    return
                }
                
                if useCustomAlbum, let albumAssetCollection = self.getAlbum(albumName: albumName) {
                    let albumChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                    albumChangeRequest?.addAssets([assetPlaceholder] as NSFastEnumeration)
                }
            }, completionHandler: { success, error in
                DispatchQueue.main.async {
                    if success {
                        print("图片成功保存到相册: \(useCustomAlbum ? albumName : "相机胶卷")")
                    } else {
                        print("保存图片失败: \(error?.localizedDescription ?? "未知错误")")
                    }
                    completion(success, error)
                }
            })
        }
        
        if PHPhotoLibrary.authorizationStatus(for: .addOnly) == .authorized {
            save()
        } else {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                if status == .authorized {
                    save()
                } else {
                    DispatchQueue.main.async {
                        completion(false, NSError(domain: "PhotoManagerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "没有权限访问相册"]))
                    }
                }
            }
        }
    }
    
    // MARK: - 相册管理
    private func getAlbum(albumName: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let album = collection.firstObject {
            return album
        } else {
            var albumPlaceholder: PHObjectPlaceholder?
            
            PHPhotoLibrary.shared().performChanges({
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }, completionHandler: { success, error in
                if !success {
                    print("创建相册失败: \(error?.localizedDescription ?? "")")
                }
            })
            
            guard let placeholder = albumPlaceholder else { return nil }
            let collection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
            return collection.firstObject
        }
    }

    func createCustomAlbum(named albumName: String) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
        }) { success, error in
            if success {
                print("成功创建相册: \(albumName)")
            } else {
                print("创建相册失败: \(error?.localizedDescription ?? "未知错误")")
            }
        }
    }
}