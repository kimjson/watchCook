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
            List(recipes) { recipe in
                NavigationLink(recipe.safeTitle) {
                    RecipeDetail(recipe: recipe)
                }
            }
            .navigationTitle("레시피 목록")
            .toolbar {
                Button("레시피 추가") {
                    newRecipe = Recipe(context: moc)
                }
//                NavigationLink("레시피 추가", destination: RecipeDetail(recipe: Recipe(context: moc)))
            }
            .sheet(item: $newRecipe, onDismiss: {newRecipe = nil}) { item in
                HStack {
                    // 저장 로직이 RecipeDetail 에 있기 때문에, 여기서 save 해봐야 의미가 없다(formData -> recipe 동기화가 이루어지지 않기 때문에).
                    // TODO: 저장 시점을 RecipeDetail의 저장 버튼 탭이 아니라, 각 텍스트 필드의 onSubmit 을 활용해야 한다.
                    Button("취소") {
                        guard let deleteTarget = newRecipe else {
                            return
                        }
                        moc.delete(deleteTarget)
                        newRecipe = nil
                    }
                    Spacer()
                    Button("완료") {
                        guard let saveTarget = newRecipe else {
                            return
                        }
                        if saveTarget.title != nil {
                            try? moc.save()
                        } else {
                            moc.delete(saveTarget)
                        }
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
