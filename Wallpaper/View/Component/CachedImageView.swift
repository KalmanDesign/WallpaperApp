//
//  CachedImageView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/9.
//

import SwiftUI

struct CachedImageView: View {
    let wallpaper: any WallpaperItem
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ProgressView()
            }
        }
        .aspectRatio(contentMode: .fit)
        .clipped()
        .cornerRadius(8)
        .onAppear(perform: loadImage)
    }
    
    private func loadImage() {
        guard let imageUrl = getImageUrl() else { return }
        
        if let cachedImage = ImageCache.shared.get(forKey: imageUrl) {
            self.image = cachedImage
        } else {
            downloadImage(from: imageUrl)
        }
    }
    
    private func getImageUrl() -> String? {
        switch wallpaper {
        case let model as WallpaperModel:
            return model.urls.small
        case let photo as WallpaperTopicsPhotos:
            return photo.urls.small
        case let topic as WallpaperTopics:
            return topic.previewPhotos.first?.urls.small
        default:
            return nil
        }
    }
    
    private func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let downloadedImage = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.image = downloadedImage
                ImageCache.shared.set(downloadedImage, forKey: urlString)
            }
        }.resume()
    }
}
