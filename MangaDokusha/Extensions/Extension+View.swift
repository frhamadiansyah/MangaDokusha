//
//  Extension+View.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 12/04/22.
//

import Foundation
import SwiftUI

extension View {
    
    func handleError(error: MangaDokushaError?, showError: Binding<Bool>, completion: @escaping () -> Void) -> some View {
        modifier(ErrorHandle(showError: showError, error: error, completion: completion))
    }
    
    func isLoading(_ isLoading: Binding<Bool>) -> some View {
        modifier(LoadingHandle(isLoading: isLoading))
    }
    
    
}
