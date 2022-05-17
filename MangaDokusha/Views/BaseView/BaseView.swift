//
//  BaseView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 11/05/22.
//

import SwiftUI

struct BaseView<Content>: View where Content: View {
    @Environment(\.presentationMode) var presentationMode
    
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body : some View {
        content
            .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .local)
                .onEnded({ value in
                    if value.translation.width > 0 {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                    
                })
            )
    }
}

struct firstView: View {
    var body: some View {
        NavigationView {
            BaseView {
                NavigationLink {
                    secondView()
                } label: {
                    Text("FIRST VIEW")
                }
            }
        }
    }
}

struct secondView: View {
    var body: some View {
        BaseView {
            NavigationLink {
                thirdView()
            } label: {
                Text("SECOND VIEW")
            }
        }
    }
}

struct thirdView: View {
    var body: some View {
        BaseView {
//            NavigationLink {
//                thirdView()
//            } label: {
                Text("SECOND VIEW")
//            }
        }
    }
}



struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        Text("DUMMY")
    }
}
