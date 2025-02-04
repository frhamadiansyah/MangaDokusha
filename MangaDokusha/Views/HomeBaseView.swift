//
//  HomeBaseView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 08/04/22.
//

import SwiftUI

struct HomeBaseView: View {
    var body: some View {
        NavigationView {
            BaseView {
                MangaListView()
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeBaseView_Previews: PreviewProvider {
    static var previews: some View {
        HomeBaseView()
    }
}


let mangaIds = [
    "b73371d4-02dd-4db0-b448-d9afa3d698f1",
    "b5b21ca1-bba5-4b9a-8cd1-6248f731650b",
    "8847f905-550d-4fe6-bcda-ac2b896789c7",
    "4141c5dc-c525-4df5-afd7-cc7d192a832f",
    "6b27cbd8-4cc6-40ca-b010-928da4540be8",
    "32fdfe9b-6e11-4a13-9e36-dcd8ea77b4e4",
    "87ffa375-bd2c-49ba-ba0c-6d78ea07c342",
    "e83c326b-921b-45ff-bc0c-d667bbfe64cc",
    
]
