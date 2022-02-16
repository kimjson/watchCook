//
//  ContentView.swift
//  watchCook
//
//  Created by 김재성 on 2022/01/30.
//

import SwiftUI

func noop() {
    
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var recipes: FetchedResults<Recipe>
    @State private var newRecipe: Recipe?
    @State private var searchText = ""
    
    func closeSheet() {
        newRecipe = nil
    }
    
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
                .onDelete { indexSet in
                    for index in indexSet {
                        moc.delete(recipes[index])
                    }
                    try? moc.save()
                }
            }
            .navigationTitle("레시피 목록")
            .searchable(text: $searchText, prompt: "제목으로 검색")
            .disableAutocorrection(true)
            .toolbar {
                Button("레시피 추가") {
                    newRecipe = Recipe(context: moc)
                }
            }
            .sheet(item: $newRecipe) { item in
                VStack {
                    HStack {
                        Button("취소") {
                            if let deleteTarget = newRecipe {
                                moc.delete(deleteTarget)
                            }
                            
                            closeSheet()
                        }
                        Spacer()
                        Button("저장", action: closeSheet)
                    }
                    .padding([.top, .leading, .trailing], 16)
                    RecipeDetail(recipe: item)
                }
                .interactiveDismissDisabled()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, DataController.preview.container.viewContext)
    }
}
