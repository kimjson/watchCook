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
    @FetchRequest(sortDescriptors: []) var recipes: FetchedResults<Recipe>
    @State private var newRecipe: Recipe?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(recipes, id: \.self) { recipe in
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
            .toolbar {
                Button("레시피 추가") {
                    newRecipe = Recipe(context: moc)
                }
            }
            .sheet(item: $newRecipe, onDismiss: {newRecipe = nil}) { item in
                HStack {
                    Button("취소") {
                        if let deleteTarget = newRecipe {
                            moc.delete(deleteTarget)
                        }
                        
                        newRecipe = nil
                    }
                    Spacer()
                    Button("저장") {
                        newRecipe = nil
                    }
                }
                .padding([.top, .leading, .trailing], 16)
                RecipeDetail(recipe: item)
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
