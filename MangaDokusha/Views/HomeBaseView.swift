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
            MangaListView()
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
    "efb4278c-a761-406b-9d69-19603c5e4c8b",
    "a04d4899-54c7-4f2e-a0a9-2338999ad6ac",
    "f4b350ca-3f00-4f0f-8dce-a3b80e593200",
    "1c5f98e8-9516-468f-8b64-2bac7e257709",
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
    "06e14068-6e11-42a0-91f6-558dcd4b1be7",
    "a735af58-f032-425d-9bc2-c197e4b9b691",
    "728f965a-a0c1-4b10-b598-289d5f94131a",
    "c124d291-8f21-485e-aa07-44e5d1081a78",
    "4380f51f-99de-46ce-94dc-1b72faf1631f",
    "4141c5dc-c525-4df5-afd7-cc7d192a832f"
]
