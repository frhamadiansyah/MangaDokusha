//
//  DownloadedView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 12/05/22.
//

import SwiftUI

struct DownloadedView: View {
    @State var isLoading: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                
                Text("Hello, World!")
                Spacer()
                Button("LOADING") {
                    isLoading.toggle()
                }

                
            }
            .padding(50)
            .isLoading($isLoading)
        }
        
    }
}

struct DownloadedView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadedView()
    }
}
