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
    
    var body: some View {
        NavigationView {
            List(recipes) { recipe in
                NavigationLink {
                    RecipeDetail(recipe: recipe)
                } label: {
                    RecipeRow(text: recipe.title ?? "이름 없는 레시피")
                }
            }
            .navigationTitle("레시피 목록")
            .toolbar {
//                NavigationLink("레시피 추가", destination: RecipeDetail(recipe: Recipe()))
                Button("레시피 추가") {
                    let titles = ["7분김치찌개", "홍합양송이파스타", "들기름막국수", "들깨칼국수"]
                    let recipe = Recipe(context: moc)
                    recipe.title = titles.randomElement()!
                    
                    try? moc.save()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
