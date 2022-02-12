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
    @State private var selectedRecipe: Recipe?
    @State private var isScreenCovered: Bool = false
    
    func selectRecipe(recipe: Recipe) {
        selectedRecipe = recipe
    }
    
    func unselectRecipe() {
        selectedRecipe = nil
    }
    
    var body: some View {
        NavigationView {
            List(recipes) { recipe in
                Button(recipe.safeTitle) {
                    selectRecipe(recipe: recipe)
                }
            }
            .navigationTitle("레시피 목록")
            .toolbar {
                NavigationLink("레시피 추가", destination: RecipeDetail(recipe: Recipe()))
            }
            .fullScreenCover(item: $selectedRecipe, onDismiss: unselectRecipe) { item in
                Spacer()
                HStack {
                    Button("닫기") {
                        unselectRecipe()
                    }
                    Spacer()
                    Button("저장") {
                        unselectRecipe()
                    }
                }
                .padding([.leading, .trailing], 16)
                // steps only (title is not used)
                Spacer()
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
