import Foundation

// 定义一个结构体来表示壁纸用户
struct WallpaperUser {
    let name: String // 用户名
    let bio: String? // 用户简介（可选）
    let profileImageLarge: String? // 用户大型头像URL（可选）
}

// 定义一个协议，表示壁纸项
protocol WallpaperItem: Identifiable {
    var id: String { get } // 每个壁纸项都需要一个唯一的标识符
    var wallpaperUser: WallpaperUser { get } // 每个壁纸项都需要一个壁纸用户
}

// 扩展WallpaperModel，使其符合WallpaperItem协议
extension WallpaperModel: WallpaperItem {
    // 实现wallpaperUser属性，返回一个WallpaperUser实例
    var wallpaperUser: WallpaperUser {
        WallpaperUser(
            name: self.user.name, // 使用当前模型的用户姓名
            bio: self.user.bio, // 使用当前模型的用户简介
            profileImageLarge: self.user.profileImage.large // 使用当前模型的用户大型头像URL
        )
    }
}

// 扩展WallpaperTopics，使其符合WallpaperItem协议
extension WallpaperTopics: WallpaperItem {
    // 实现wallpaperUser属性，返回一个默认的WallpaperUser实例
    var wallpaperUser: WallpaperUser {
        WallpaperUser(
            name: "默认用户名", // 设置默认用户名
            bio: nil, // 默认简介为空
            profileImageLarge: nil // 默认头像URL为空
        )
    }
}

// 扩展WallpaperTopicsPhotos，使其符合WallpaperItem协议
extension WallpaperTopicsPhotos: WallpaperItem {
    // 实现wallpaperUser属性，返回一个WallpaperUser实例
    var wallpaperUser: WallpaperUser {
        WallpaperUser(
            name: self.user.name, // 使用当前模型的用户姓名
            bio: self.user.bio, // 使用当前模型的用户简介
            profileImageLarge: self.user.profileImage?.large // 使用当前模型的用户大型头像URL，如果有的话
        )
    }
}
