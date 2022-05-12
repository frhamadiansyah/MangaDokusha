//
//  ErrorHandle.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 11/05/22.
//

import Foundation
import SwiftUI

struct ErrorHandle: ViewModifier {
    @Binding var showError: Bool
    var error: MangaDokushaError?
    let completion: () -> Void
    
    func body(content: Content) -> some View {
        switch error {
        case .networkError(let networkError):
            handleNetworkError(networkError: networkError, content: content)
        case .backendError(let backendError):
            handleBackendError(backendError: backendError)
        case .noChapter:
            handleDefaultError(title: "No Chapter Found", message: "Sorry, no chapter found. please return to chapter selection view", content: content)
        case .noMangaFound:
            handleDefaultError(title: "No Manga Found", message: "Sorry, no Manga found. please search other keyword", content: content)
        default:
            handleDefaultError(content: content)
        }
    }
    
    func handleNetworkError(networkError: Error, content: Content) -> some View {
        content
            .alert("Network Error", isPresented: $showError) {
                Button(action: completion) {
                    Text("OK")
                }
            } message: {
                Text(networkError.localizedDescription)
            }
    }
    
    func handleBackendError(backendError: MangaDexErrorStruct) -> some View {
        EmptyView()
            .alert(backendError.title, isPresented: $showError) {
                Button(action: completion) {
                    Text("OK")
                }
                
            } message: {
                Text(backendError.localizedDescription)
            }
    }
    
    func handleDefaultError(title: String = "ERROR", message: String = "Sorry, there's a disturbance right now", content: Content) -> some View {
        content
            .alert(title, isPresented: $showError) {
                Button(action: completion) {
                    Text("OK")
                }
                
            } message: {
                Text(message)
            }
    }
}
