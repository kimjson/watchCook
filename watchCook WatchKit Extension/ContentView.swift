//
//  ContentView.swift
//  watchCook WatchKit Extension
//
//  Created by 김재성 on 2022/01/30.
//

import SwiftUI

struct ContentView: View {
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
