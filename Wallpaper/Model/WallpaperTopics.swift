//
//  WallpaperTopics.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/9.
//

import Foundation

// 主题模型
struct WallpaperTopics: Identifiable, Codable {
    let id: String
    let slug: String
    let description: String
    let previewPhotos: [PreviewPhoto]
    
    enum CodingKeys: String, CodingKey {
        case id, slug, description
        case previewPhotos = "preview_photos"
    }
}

struct PreviewPhoto: Codable, Identifiable {
    let id: String
    let urls: PreviewPhotoURLs

    enum CodingKeys: String, CodingKey {
        case id, urls
    }
}

struct PreviewPhotoURLs: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}


// MARK: - 新增 WallpaperTopicsPhotos 结构体
struct WallpaperTopicsPhotos: Codable, Identifiable { // 主题下的所有图片
    let id: String // 图片的唯一标识符
    let urls: TopicPhotoURLs // 图片的URLs
    let description: String?  // 图片的描述，可能为空
    let user: TopicPhotoUser // 图片的上传用户信息
    
    enum CodingKeys: String, CodingKey {
        case id, urls, description, user
    }
}

struct TopicPhotoURLs: Codable {
    let raw: String // 原始图片的URL
    let full: String // 完整图片的URL
    let regular: String // 正常大小图片的URL
    let small: String // 小型图片的URL
    let thumb: String // 缩略图的URL
}

struct TopicPhotoUser: Codable {
    let id: String // 用户的唯一标识符
    let username: String // 用户名
    let name: String // 用户的姓名
    let portfolioURL: String? // 用户的作品集URL，可能为空
    let bio: String? // 用户的简介，可能为空
    let location: String? // 用户的所在地，可能为空
    let profileImage: TopicPhotoUserProfileImage?  // 用户的个人头像，可能为空
    
    enum CodingKeys: String, CodingKey {
        case id, username, name, bio, location
        case portfolioURL = "portfolio_url" // JSON中的键名
        case profileImage = "profile_image" // JSON中的键名
    }
}

// 新增 TopicPhotoUserProfileImage 结构体
struct TopicPhotoUserProfileImage: Codable {
    let small: String // 小型头像的URL
    let medium: String // 中型头像的URL
    let large: String // 大型头像的URL
}




// 添加这个扩展
extension WallpaperTopics {
    static var samples: [WallpaperTopics] {
        [
            WallpaperTopics(
                id: "1",
                slug: "nature",
                description: "The natural world and its beauty.",
                previewPhotos: [
                    PreviewPhoto(id: "photo1", urls: PreviewPhotoURLs(
                        raw: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                        full: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                        regular: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                        small: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                        thumb: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max"
                    ))
                ]
            ),
            WallpaperTopics(
                id: "2",
                slug: "travel",
                description: "Explore the world through photography.",
                previewPhotos: [
                    PreviewPhoto(id: "photo2", urls: PreviewPhotoURLs(
                        raw: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                        full: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                        regular: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                        small: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                        thumb: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max"
                    ))
                ]
            ),
            WallpaperTopics(
                id: "3",
                slug: "architecture",
                description: "Capturing the beauty of buildings and structures.",
                previewPhotos: [
                    PreviewPhoto(id: "photo3", urls: PreviewPhotoURLs(
                        raw: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                        full: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                        regular: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                        small: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                        thumb: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max"
                    ))
                ]
            )
        ]
    }
}


extension WallpaperTopicsPhotos {
    static var samplePhoto: WallpaperTopicsPhotos {
        WallpaperTopicsPhotos(
            id: "sample",
            urls: TopicPhotoURLs(
                raw: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                full: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                regular: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                small: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                thumb: "https://plus.unsplash.com/premium_photo-1719889519521-f4406137c609?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max"
            ),
            description: "Sample photo description",
            user: TopicPhotoUser(
                id: "user1",
                username: "sampleuser",
                name: "Sample User",
                portfolioURL: nil,
                bio: nil,
                location: nil,
                profileImage: nil
            )
        )
    }
}
