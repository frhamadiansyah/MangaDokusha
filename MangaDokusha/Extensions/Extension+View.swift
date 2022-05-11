//
//  Extension+View.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 12/04/22.
//

import Foundation
import SwiftUI


extension View {
    
    @ViewBuilder
    func errorHandling(error: MangaDokushaError?, showError: Binding<Bool>, completion: @escaping () -> Void) -> some View {
        
        switch error {
        case .networkError(let networkError):
            return AnyView(handlingNetworkError(networkError: networkError, showError: showError, completion: completion))
        case .backendError(let backendError):
            return AnyView(handlingBackendError(backendError: backendError, showError: showError, completion: completion))
        case .noChapter:
            return AnyView(handlingDefaultError(title: "No Chapter Found", message: "Sorry, no chapter found. please return to chapter selection view",showError: showError, completion: completion))
        case .noMangaFound:
            return AnyView(handlingDefaultError(title: "No Manga Found", message: "Sorry, no Manga found. please search other keyword",showError: showError, completion: completion))
        default:
            return AnyView(handlingDefaultError(showError: showError, completion: completion))
        }
        
        
    }
    
    @ViewBuilder
    func handlingNetworkError(networkError: Error, showError: Binding<Bool>, completion: @escaping () -> Void) -> some View {
        EmptyView()
            .alert("Network Error", isPresented: showError) {
                Button(action: completion) {
                    Text("OK")
                }
                
            } message: {
                Text(networkError.localizedDescription)
            }
    }
    
    @ViewBuilder
    func handlingBackendError(backendError: MangaDexErrorStruct, showError: Binding<Bool>, completion: @escaping () -> Void) -> some View {
        EmptyView()
            .alert(backendError.title, isPresented: showError) {
                Button(action: completion) {
                    Text("OK")
                }
                
            } message: {
                Text(backendError.localizedDescription)
            }
    }
    
    @ViewBuilder
    func handlingDefaultError(title: String = "ERROR", message: String = "Sorry, there's a disturbance right now", showError: Binding<Bool>, completion: @escaping () -> Void) -> some View {
        EmptyView()
            .alert(title, isPresented: showError) {
                Button(action: completion) {
                    Text("OK")
                }
                
            } message: {
                Text(message)
            }
    }
    
    @ViewBuilder
    func customAsyncImage(url: String) -> some View {
        AsyncImage(
            url: URL(string: url)
        ) { phase in
            switch phase {
            case .empty:
                ZStack{
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    ProgressView()
                }
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            case .failure:
                AsyncImage(url: URL(string: url)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else if phase.error != nil {
                        AsyncImage(url: URL(string: url)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ZStack{
                                Image(systemName: "arrow.clockwise")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                ProgressView()
                            }
                        }
                    }
                }
                
            @unknown default:
                EmptyView()
            }
        }
    }
    
}
