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
            List {
                ForEach(mangaIds, id: \.self) { id in
                    NavigationLink {
                        ContentView(mangaId: id)
                    } label: {
                        Text(id)
                    }
                }

            }
        }
    }
}

struct HomeBaseView_Previews: PreviewProvider {
    static var previews: some View {
        HomeBaseView()
    }
}


let mangaIds = [
    "a04d4899-54c7-4f2e-a0a9-2338999ad6ac",
    "8847f905-550d-4fe6-bcda-ac2b896789c7",
    "c196dcc8-d942-4abf-987f-bfa244650585",
    "8a1ca2e4-d83b-4ce6-a074-4102231bebb5",
    "801513ba-a712-498c-8f57-cae55b38cc92",
    "b9b2fbc4-e351-406c-a468-799be14033df",
    "fffbfac3-b7ad-41ee-9581-b4d90ecec941",
    "32d76d19-8a05-4db0-9fc2-e0b0648fe9d0",
    "32fdfe9b-6e11-4a13-9e36-dcd8ea77b4e4",
    "d422ddc8-eea3-4b0a-82a4-291bbd8c9285",
    "b5b21ca1-bba5-4b9a-8cd1-6248f731650b",
    "b73371d4-02dd-4db0-b448-d9afa3d698f1",
    "cbf174ca-af25-4410-82fa-498a6df9ad3c",
    "090319a9-58b6-42b5-9962-26db2595ca63", //nsfw
    "4141c5dc-c525-4df5-afd7-cc7d192a832f"
]
