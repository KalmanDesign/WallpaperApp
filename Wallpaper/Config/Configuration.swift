//
//  Configuration.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/15.
//

// 文件作用：此文件用于获取应用程序的版本号和构建号，并提供一个包含版本号和构建号的字符串。


import Foundation

struct Configuration {
    static let version: String = {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            fatalError("CFBundleShortVersionString should not be missing from info.plist")
        }
        return version
    }()
    
    static let build: String = {
        guard let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            fatalError("CFBundleVersion should not be missing from info.plist")
        }
        return build
    }()
    
    static var versionAndBuild: String {
        return "\(version) (\(build))"
    }
}

