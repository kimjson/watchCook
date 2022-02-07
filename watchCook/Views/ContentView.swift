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
    @EnvironmentObject var modelData: ModelData
    var recipes: [Recipe] {
        modelData.recipes
    }

    
    var body: some View {
        NavigationView {
            List {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        RecipeDetail()
                    } label: {
                        RecipeRow(text: recipe.title)
                    }
                }
            }
            .navigationTitle("레시피 목록")
            .toolbar {
                NavigationLink("레시피 추가", destination: RecipeDetail())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
