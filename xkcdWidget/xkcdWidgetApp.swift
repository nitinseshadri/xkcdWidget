//
//  xkcdWidgetApp.swift
//  xkcdWidget
//
//  Created by Nitin Seshadri on 3/15/21.
//

import SwiftUI

@main
struct xkcdWidgetApp: App {
    
    @Environment(\.openURL) private var openURL
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    openURL(url)
                }
        }
    }
}
