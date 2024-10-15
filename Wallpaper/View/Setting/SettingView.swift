//
//  SettingView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/13.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var vm:WallpaperViewModel
    @State private var cacheSize: String = NSLocalizedString("Calculating...", comment: "")
    @State private var isClearing: Bool = false
    @State private var showAlert: Bool = false
    @State private var showAlbumNameAlert: Bool = false
    @State private var newAlbumName: String = ""
    
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("下载选项"), footer: Text("开启原图开关后，将依据设置尺寸下载图片。")){
                    Toggle("原图",isOn: $vm.shouldCropImage)
                    
                    Toggle("使用自定义相册",isOn: $vm.useCustomAlbum)
                    if vm.useCustomAlbum {
                        HStack {
                            Text("自定义相册名称:")
                            Text("\(vm.customAlbumName)")
                        }
                        HStack{
                            Button("点击更改自定义相册名") {
                                newAlbumName = vm.customAlbumName
                                showAlbumNameAlert = true
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                
                // 设置列表的第一个部分
                Section {
                    // 评分按钮
                    Text(NSLocalizedString("Give Rating", comment: ""))
                    // FAQ按钮
                    Text(NSLocalizedString("FAQ", comment: ""))
                    // 清除缓存按钮
                    Button(action: {
                        self.showAlert = true
                    }) {
                        HStack {
                            Text(NSLocalizedString("Clear Cache", comment: ""))
                            Spacer()
                            // 根据是否正在清除缓存显示进度条或缓存大小
                            if isClearing {
                                ProgressView()
                            } else {
                                Text(cacheSize)
                            }
                        }
                    }
                    .disabled(isClearing) // 如果正在清除缓存，禁用按钮
                    // 反馈按钮
                    Text(NSLocalizedString("Feedback", comment: ""))
                }
                // 设置列表的第二个部分
                Section("关注我"){
                    // 跳转到X的按钮
                    Button(action: {
                        if let url = URL(string: "https://x.com") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text(NSLocalizedString("X", comment: ""))
                    }
                    // 跳转到Telegram的按钮
                    Button(action: {
                        if let url = URL(string: "https://x.com") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text(NSLocalizedString("Telegram", comment: ""))
                    }
                    // 跳转到Email的按钮
                    Button(action: {
                        if let url = URL(string: "https://x.com") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack{
                            Text(NSLocalizedString("Email", comment: ""))
                            Spacer()
                            Text("Kalman0715@gmail.com")
                        }
                    }
                }
            }
            // 显示应用版本号
            Text("build version:\(Configuration.build)")
                .padding(.bottom,16)
                .navigationTitle("Setting")
                .font(.caption)
                .foregroundColor(.white.opacity(0.24))
        }
        .preferredColorScheme(.dark)
        .onAppear {
            updateCacheSize()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(NSLocalizedString("Clear Cache Alert Title", comment: "")),
                message: Text(NSLocalizedString("Clear Cache Alert Message", comment: "")),
                primaryButton: .destructive(Text(NSLocalizedString("Clear", comment: ""))) {
                    clearCache()
                },
                secondaryButton: .cancel(Text(NSLocalizedString("Cancel", comment: "")))
            )
        }
        .alert("更改自定义相册名", isPresented: $showAlbumNameAlert) {
            TextField("新相册名", text: $newAlbumName)
            Button("取消", role: .cancel) { }
            Button("确定") {
                if !newAlbumName.isEmpty {
                    vm.customAlbumName = newAlbumName
                    // 创建新的相册
                    vm.createCustomAlbum(named: newAlbumName)
                }
            }
        } message: {
            Text("请输入新的相册名称")
        }
    }
    
    // MARK: - 更新缓存大小
    private func updateCacheSize() {
        cacheSize = CacheManager.shared.getCacheSize()
    }
    
    // MARK: - 清除缓存
    private func clearCache() {
        isClearing = true
        CacheManager.shared.clearCache { success in
            DispatchQueue.main.async {
                self.isClearing = false
                if success {
                    self.updateCacheSize()
                }
            }
        }
    }
}

#Preview {
    SettingView()
        .environmentObject(WallpaperViewModel())
}
