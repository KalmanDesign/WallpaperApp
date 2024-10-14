//
//  CacheManager.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/14.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    
    private init() {}
    
    func getCacheSize() -> String {
        let size = calculateSize(for: .cachesDirectory) + calculateSize(for: .documentDirectory)
        return ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }
    
    private func calculateSize(for directory: FileManager.SearchPathDirectory) -> Int64 {
        let fileManager = FileManager.default
        guard let url = fileManager.urls(for: directory, in: .userDomainMask).first else {
            return 0
        }
        
        guard let enumerator = fileManager.enumerator(at: url, includingPropertiesForKeys: [.fileSizeKey], options: []) else {
            return 0
        }
        
        var size: Int64 = 0
        for case let fileURL as URL in enumerator {
            guard let attributes = try? fileURL.resourceValues(forKeys: [.fileSizeKey]),
                  let fileSize = attributes.fileSize else {
                continue
            }
            size += Int64(fileSize)
        }
        
        return size
    }
    
    func clearCache(completion: @escaping (Bool) -> Void) {
        let group = DispatchGroup()
        var success = true
        
        group.enter()
        clearDirectory(.cachesDirectory) { result in
            success = success && result
            group.leave()
        }
        
        group.enter()
        clearDirectory(.documentDirectory) { result in
            success = success && result
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion(success)
        }
    }
    
    private func clearDirectory(_ directory: FileManager.SearchPathDirectory, completion: @escaping (Bool) -> Void) {
        let fileManager = FileManager.default
        guard let url = fileManager.urls(for: directory, in: .userDomainMask).first else {
            completion(false)
            return
        }
        
        do {
            let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for fileUrl in contents {
                try fileManager.removeItem(at: fileUrl)
            }
            completion(true)
        } catch {
            print("Error clearing \(directory): \(error)")
            completion(false)
        }
    }
}
