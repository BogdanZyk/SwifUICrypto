//
//  SwifrUICryptoApp.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 19.04.2022.
//

import SwiftUI

@main
struct SwifrUICryptoApp: App {
    @StateObject private var vm = HomeViewModel()
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    }
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
