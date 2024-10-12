//
//  AsImage.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/7.
//

import SwiftUI

struct AsyncImageView: View {
    let imageURL: String
    let imageCornerRadius: CGFloat
    let onImageLoaded: (Bool) -> Void
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty, .failure:
                // 图片加载中或加载失败时显示
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(imageCornerRadius)
                    .onAppear { onImageLoaded(false) }
            case .success(let image):
                // 图片加载成功时显示
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
                    .cornerRadius(imageCornerRadius)
                    .onAppear { onImageLoaded(true) }
            @unknown default:
                EmptyView()
            }
        }
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageView(imageURL: "https://example.com/image.jpg", imageCornerRadius: 12, onImageLoaded: { _ in })
            .frame(height: 200)
            .padding()
    }
}
