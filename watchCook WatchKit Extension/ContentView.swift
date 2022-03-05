//
//  ContentView.swift
//  watchCook WatchKit Extension
//
//  Created by 김재성 on 2022/01/30.
//

import SwiftUI

struct ContentView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var recipes: FetchedResults<Recipe>
    
    @State private var searchText = ""
    
    var searchResults: [Recipe] {
        if searchText.isEmpty {
            return recipes.map {$0}
        } else {
            return recipes.filter {
                $0.isSafeTitleMatches(searchText: searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.self) { recipe in
                    NavigationLink(recipe.safeTitle) {
                        RecipeDetail(recipe: recipe)
                    }
                }
            }
            .navigationTitle("레시피 목록")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "제목으로 검색")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("Apple Watch Series 5 - 40mm") // 왠지 모르겠는데 inherted device, apple watch series 6 로 하면 안됨 ㅡㅡ;;
            .environment(\.managedObjectContext, DataController.preview.container.viewContext)
    }
}
