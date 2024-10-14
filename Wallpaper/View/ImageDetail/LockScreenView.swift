//
//  LockScreenView.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/14.
//

import SwiftUI

struct LockScreenView: View {
    var body: some View {
        Group{
            Image("LockScreen")
                .resizable()
                .scaledToFill()
        }
    }
}

#Preview {
    LockScreenView()
}
