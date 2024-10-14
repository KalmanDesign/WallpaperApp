//
//  SettingView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/13.
//

import SwiftUI

struct SettingView: View {
    @State private var cacheSize: String = NSLocalizedString("Calculating...", comment: "")
    @State private var isClearing: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(NSLocalizedString("Give Rating", comment: ""))
                    Text(NSLocalizedString("FAQ", comment: ""))
                    Button(action: {
                        self.showAlert = true
                    }) {
                        HStack {
                            Text(NSLocalizedString("Clear Cache", comment: ""))
                            .foregroundColor(.white)
                            Spacer()
                            if isClearing {
                                ProgressView()
                            } else {
                                Text(cacheSize)
                                 .foregroundColor(.white)
                            }
                        }
                    }
                    .disabled(isClearing)
                    Text(NSLocalizedString("Feedback", comment: ""))
                    HStack {
                        Text(NSLocalizedString("Version", comment: ""))
                        Spacer()
                        Text("V 0.0.1")
                    }
                    Text(NSLocalizedString("Follow Me", comment: ""))
                }
            }
            .navigationTitle("Setting")
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
    }
    
    private func updateCacheSize() {
        cacheSize = CacheManager.shared.getCacheSize()
    }
    
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
}
