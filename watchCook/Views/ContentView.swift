//
//  ContentView.swift
//  watchCook
//
//  Created by 김재성 on 2022/01/30.
//

import SwiftUI

func noop() {
    
}

class FormData: ObservableObject {
    @Published var title: String = ""
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var recipes: FetchedResults<Recipe>
    @State private var selectedRecipe: Recipe?
    @State private var isScreenCovered: Bool = false
    
    // MARK: form data
    @StateObject private var formData: FormData = FormData()
    
    func selectRecipe(recipe: Recipe) {
        selectedRecipe = recipe
        formData.title = recipe.safeTitle
        isScreenCovered = true
    }
    
    func unselectRecipe() {
        isScreenCovered = false
        formData.title = ""
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
            .fullScreenCover(isPresented: $isScreenCovered) {
                // 이하를 RecipeDetail 로 집어넣고, FormData 상태도 RecipeDetail 에서 관리해야 함. onSubmit 시에 selectedRecipe의 속성값을 formData의 값으로 대치하는 식으로.
                Spacer()
                HStack {
                    TextField("제목", text: $formData.title)
//                    Text(item.safeTitle).font(.title).bold()
                    Spacer()
                    Button("완료") {
                        unselectRecipe()
                    }
                }
                .padding([.leading, .trailing], 16)
                // steps only (title is not used)
                RecipeDetail(recipe: selectedRecipe!)
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
