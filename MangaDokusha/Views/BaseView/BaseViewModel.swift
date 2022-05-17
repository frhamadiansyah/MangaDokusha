//
//  BaseViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 27/04/22.
//

import Foundation
import Combine

class BaseViewModel: ObservableObject {
    
    var cancel = Set<AnyCancellable>()
    
    @Published var showError: Bool = false
    @Published var error: MangaDokushaError? 
    
    init() {
        
    }
    
    func basicHandleCompletionError(error: Subscribers.Completion<MangaDokushaError>) {
        switch error {
        case .failure(let err):
            self.error = err
            self.showError = true
        case .finished:
            print("finished")
        }
    }
    
    func basicHandleError(_ error: Error) {
        if let err = error as? MangaDokushaError {
            self.error = err
        } else {
            self.error = MangaDokushaError.otherError(error)
        }
        self.showError = true
    }
    
    
}
