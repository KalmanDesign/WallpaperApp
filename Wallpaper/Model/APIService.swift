//
//  APIService.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/7.
//

import Foundation

class APIService:ObservableObject {
    private let baseURL = "https://api.unsplash.com"
    private let apiKey = "RW4fsgPCUblljbtt8qULox3p1_N9njB2uYlw6CFow4g"
    
    func fetchRandomPhotos(count: Int) async throws -> [WallpaperModel] {
        let urlString = "\(baseURL)/photos/random?count=\(count)"
        guard let url = URL(string: urlString) else {
            throw APIError.badRequest
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([WallpaperModel].self, from: data)
        } catch {
            print("解码错误: \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("收到的JSON数据: \(jsonString)")
            }
            throw APIError.decodingError
        }
    }
    
    //获取主题列表
    func fetchTopicList(page: Int = 1, perPage: Int = 10) async throws -> [WallpaperTopics] {
        let urlString = "\(baseURL)/topics?page=\(page)&per_page=\(perPage)&order_by=position"
        guard let url = URL(string: urlString) else {
            print("URL解析错误: \(urlString)")
            throw APIError.badRequest
        }
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            print("HTTP响应错误: \(response)")
            throw APIError.serverError
        }
        do {
            let decoder = JSONDecoder()
            let topics = try decoder.decode([WallpaperTopics].self, from: data)
            return topics
        } catch {
            print("解码错误: \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("收到的JSON数据: \(jsonString)")
            }
            throw APIError.decodingError
        }
    }
    
    
    //
    func fetchPhotosForTopic(slug: String) async throws -> [WallpaperTopicsPhotos]{
        let urlString = "\(baseURL)/topics/\(slug)/photos?per_page=100"
        guard let url = URL(string: urlString) else {
            throw APIError.badRequest
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([WallpaperTopicsPhotos].self, from: data)
        } catch {
            print("解码错误: \(error)")
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("未找到键 \(key): \(context)")
                case .typeMismatch(let type, let context):
                    print("类型不匹配 \(type): \(context)")
                case .valueNotFound(let type, let context):
                    print("未找到值 \(type): \(context)")
                case .dataCorrupted(let context):
                    print("数据损坏: \(context)")
                @unknown default:
                    print("未知解码错误")
                }
            }
            throw APIError.decodingError
        }
    }
    
    
    
}
enum APIError: Error, CustomStringConvertible {
    case badRequest, unauthorized, forbidden, notFound, serverError, decodingError, unknown
    
    var description: String {
        switch self {
        case .badRequest: return "请求不可接受，通常是缺少必需参数"
        case .unauthorized: return "无效的访问令牌"
        case .forbidden: return "缺少执行请求的权限"
        case .notFound: return "请求的资源不存在"
        case .serverError: return "服务器出现问题"
        case .decodingError: return "解码响应数据时出错"
        case .unknown: return "发生未知错误"
        }
    }
}
