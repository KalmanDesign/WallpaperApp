//
//  WallpaperModel.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/7.
//

import Foundation

// 定义一个符合Identifiable和Codable协议的结构体WallpaperModel
struct WallpaperModel: Codable, Identifiable {
    let id: String
    let slug: String
    let createdAt: String
    let updatedAt: String
    let promotedAt: String?
    let width: Int
    let height: Int
    let color: String
    let blurHash: String?
    let description: String?
    let altDescription: String?
    let urls: URLs
    let links: Links
    let likes: Int
    let likedByUser: Bool
    let user: User

    enum CodingKeys: String, CodingKey {
        case id, slug, width, height, color, description, urls, links, likes, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case promotedAt = "promoted_at"
        case blurHash = "blur_hash"
        case altDescription = "alt_description"
        case likedByUser = "liked_by_user"
    }
}

// 定义一个URLs结构体来存储图片的不同尺寸的URL
struct URLs: Codable {
    let raw, full, regular, small, thumb: String
    let smallS3: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}

// 定义一个Links结构体来存储下载链接
struct Links: Codable {
    let html, download, downloadLocation: String

    enum CodingKeys: String, CodingKey {
        case html, download
        case downloadLocation = "download_location"
    }
}

// 定义一个User结构体来存储用户信息
struct User: Codable {
    let id: String
    let username: String
    let name: String
    let firstName: String
    let lastName: String?
    let twitterUsername: String?
    let portfolioUrl: String?
    let bio: String?
    let location: String?
    let links: UserLinks
    let profileImage: ProfileImage
    let instagramUsername: String?
    let totalCollections: Int
    let totalLikes: Int
    let totalPhotos: Int
    let acceptedTos: Bool
    let forHire: Bool
    let social: Social

    enum CodingKeys: String, CodingKey {
        case id, username, name, bio, location, links
        case firstName = "first_name"
        case lastName = "last_name"
        case twitterUsername = "twitter_username"
        case portfolioUrl = "portfolio_url"
        case profileImage = "profile_image"
        case instagramUsername = "instagram_username"
        case totalCollections = "total_collections"
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case acceptedTos = "accepted_tos"
        case forHire = "for_hire"
        case social
    }
}

// 定义一个UserLinks结构体来存储用户的社交媒体链接
struct UserLinks: Codable {
    let html, photos, likes, portfolio: String
    let following, followers: String
}

// 定义一个ProfileImage结构体来存储用户头像的不同尺寸的URL
struct ProfileImage: Codable {
    let small, medium, large: String
}

// 定义一个Social结构体来存储用户的社交媒体信息
struct Social: Codable {
    let instagramUsername: String?
    let portfolioUrl: String?
    let twitterUsername: String?
    let paypalEmail: String?

    enum CodingKeys: String, CodingKey {
        case instagramUsername = "instagram_username"
        case portfolioUrl = "portfolio_url"
        case twitterUsername = "twitter_username"
        case paypalEmail = "paypal_email"
    }
}

// 定义一个静态变量sampleWallpaper来存储一个示例的壁纸模型
extension WallpaperModel {
    static var sampleWallpaper: WallpaperModel {
        WallpaperModel(
            id: "boMKfQkphro",
            slug: "a-close-up-of-a-motherboard-and-a-pen-on-a-table-boMKfQkphro",
            createdAt: "2024-07-18T19:49:40Z",
            updatedAt: "2024-10-02T04:19:55Z",
            promotedAt: nil,
            width: 6989,
            height: 9318,
            color: "#262626",
            blurHash: "L26RZC8w?a%g^+oyxZ%M9a-;tRs9",
            description: nil,
            altDescription: "A close up of a motherboard and a pen on a table",
            urls: URLs(
                raw: "https://images.unsplash.com/photo-1721332149267-ef9b10eaacd9?ixid=M3w2NjE4NTd8MXwxfGFsbHwxfHx8fHx8fHwxNzI4MjMxMzcyfA&ixlib=rb-4.0.3",
                full: "https://images.unsplash.com/photo-1721332149267-ef9b10eaacd9?crop=entropy&cs=srgb&fm=jpg&ixid=M3w2NjE4NTd8MXwxfGFsbHwxfHx8fHx8fHwxNzI4MjMxMzcyfA&ixlib=rb-4.0.3&q=85",
                regular: "https://images.unsplash.com/photo-1721332149267-ef9b10eaacd9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2NjE4NTd8MXwxfGFsbHwxfHx8fHx8fHwxNzI4MjMxMzcyfA&ixlib=rb-4.0.3&q=80&w=1080",
                small: "https://images.unsplash.com/photo-1721332149267-ef9b10eaacd9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2NjE4NTd8MXwxfGFsbHwxfHx8fHx8fHwxNzI4MjMxMzcyfA&ixlib=rb-4.0.3&q=80&w=400",
                thumb: "https://images.unsplash.com/photo-1721332149267-ef9b10eaacd9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2NjE4NTd8MXwxfGFsbHwxfHx8fHx8fHwxNzI4MjMxMzcyfA&ixlib=rb-4.0.3&q=80&w=200",
                smallS3: "https://s3.us-west-2.amazonaws.com/images.unsplash.com/small/photo-1721332149267-ef9b10eaacd9"
            ),
            links: Links(
                html: "https://unsplash.com/photos/a-close-up-of-a-motherboard-and-a-pen-on-a-table-boMKfQkphro",
                download: "https://unsplash.com/photos/boMKfQkphro/download?ixid=M3w2NjE4NTd8MXwxfGFsbHwxfHx8fHx8fHwxNzI4MjMxMzcyfA",
                downloadLocation: "https://api.unsplash.com/photos/boMKfQkphro/download?ixid=M3w2NjE4NTd8MXwxfGFsbHwxfHx8fHx8fHwxNzI4MjMxMzcyfA"
            ),
            likes: 102,
            likedByUser: false,
            user: User(
                id: "eySMK9KwmJU",
                username: "samsungmemory",
                name: "Samsung Memory",
                firstName: "Samsung",
                lastName: "Memory",
                twitterUsername: "SamsungSemiUS",
                portfolioUrl: "http://www.samsung.com/us/computing/memory-storage/",
                bio: "Memory for every endeavor – get fast storage solutions that work seamlessly with your devices.",
                location: nil,
                links: UserLinks(
                    html: "https://unsplash.com/@samsungmemory",
                    photos: "https://api.unsplash.com/users/samsungmemory/photos",
                    likes: "https://api.unsplash.com/users/samsungmemory/likes",
                    portfolio: "https://api.unsplash.com/users/samsungmemory/portfolio",
                    following: "https://api.unsplash.com/users/samsungmemory/following",
                    followers: "https://api.unsplash.com/users/samsungmemory/followers"
                ),
                profileImage: ProfileImage(
                    small: "https://images.unsplash.com/profile-1602741027167-c4d707fcfc85image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32",
                    medium: "https://images.unsplash.com/profile-1602741027167-c4d707fcfc85image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=64&h=64",
                    large: "https://images.unsplash.com/profile-1602741027167-c4d707fcfc85image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=128&h=128"
                ),
                instagramUsername: "samsungsemiconductor",
                totalCollections: 1,
                totalLikes: 0,
                totalPhotos: 880,
                acceptedTos: true,
                forHire: false,
                social: Social(
                    instagramUsername: "samsungsemiconductor",
                    portfolioUrl: "http://www.samsung.com/us/computing/memory-storage/",
                    twitterUsername: "SamsungSemiUS",
                    paypalEmail: nil
                )
            )
        )
    }
}

