//
//  HomeViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 12/04/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var error: MangaDokushaError?
    @Published var showError: Bool = false
    
    @Published var mangaList: [MangaDetailModel] = []
}
