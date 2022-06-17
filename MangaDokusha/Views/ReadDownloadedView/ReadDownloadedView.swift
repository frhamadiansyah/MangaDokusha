//
//  ReadDownloadedView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 14/05/22.
//

import SwiftUI
import Introspect

struct ReadDownloadedView: View {
    @StateObject var vm: ReadDownloadedViewModel
    @State var uiTabarController: UITabBarController?
    
    init(entity: ChapterEntity) {
        _vm = StateObject(wrappedValue: ReadDownloadedViewModel(entity: entity))
    }
    var body: some View {
        GeometryReader { geometry in
            if !vm.images.isEmpty {
//                if geometry.size.height > geometry.size.width {
                    LongStripView(vm: vm)
//                } else {
//                    LandscapeView(vm: vm)
//                        .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
//                }
            }
        }
        .onAppear {
            vm.getPages()
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
            uiTabarController = UITabBarController
        }
        .onDisappear{
            uiTabarController?.tabBar.isHidden = false
        }
        .navigationTitle(vm.pageTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReadDownloadedView_Previews: PreviewProvider {
    static var previews: some View {
        ReadDownloadedView(entity: ChapterEntity())
    }
}
