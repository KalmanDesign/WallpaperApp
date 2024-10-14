//
//  SettingView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/13.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationStack{
            List{
                Section{
                    Text("给个好评")
                    Text("常见问题")
                    HStack{
                        Text("清除缓存")
                        Spacer()
                        Text("103.35 MB")
                    }
                    Text("问题反馈")
                    HStack{
                        Text("版本型号")
                        Spacer()
                        Text("V 0.0.1")
                    }
                    Text("关注我")
                }
            }
            .navigationTitle("KALMAN")
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    SettingView()
}
