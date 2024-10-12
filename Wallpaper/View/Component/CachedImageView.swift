//
//  CachedImageView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/9.
//

import SwiftUI

struct CachedImageView: View {
    // 存储壁纸模型和显示宽度
    let wallpaper: WallpaperModel
    // 使用@State来管理图片的加载状态
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                // 如果图片已加载，显示图片
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                // 如果图片未加载，显示加载指示器
                ProgressView()
            }
        }
        // 设置图片框架大小，保持原始宽高比
        .aspectRatio(CGFloat(wallpaper.width) / CGFloat(wallpaper.height), contentMode: .fit)
        .clipped() // 裁剪超出边界的部分
        .cornerRadius(8) // 添加圆角
        .onAppear(perform: loadImage) // 视图出现时加载图片
    }
    // 加载图片的函数
    private func loadImage() {
        // 步骤1: 尝试从缓存中获取图片
        if let cachedImage = ImageCache.shared.get(forKey: wallpaper.urls.small) {
            // 如果缓存中有图片，直接使用
            self.image = cachedImage
        } else {
            // 如果缓存中没有，下载图片
            downloadImage()
        }
    }
    
    // 下载图片的函数
    private func downloadImage() {
        // 步骤2: 创建URL对象
        guard let url = URL(string: wallpaper.urls.small) else { return }
        
        // 步骤3: 使用URLSession下载图片
        URLSession.shared.dataTask(with: url) { data, response, error in
            // 步骤4: 检查下载的数据并创建UIImage对象
            guard let data = data, let downloadedImage = UIImage(data: data) else { return }
            
            // 步骤5: 在主线程更新UI和缓存
            DispatchQueue.main.async {
                // 更新@State属性，触发UI刷新
                self.image = downloadedImage
                // 将下载的图片存入缓存
                ImageCache.shared.set(downloadedImage, forKey: self.wallpaper.urls.small)
            }
        }.resume() // 开始下载任务
    }
}
