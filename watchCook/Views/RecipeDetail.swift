//
//  RecipeDetail.swift
//  watchCook
//
//  Created by jaeseong on 2022/02/07.
//

import SwiftUI

class StepInput: ObservableObject, Identifiable {
    var id: Int32 = 1
    @Published var text: String = ""
}

class FormData: ObservableObject {
    @Published var title: String = ""
    @Published var steps: [StepInput] = []
}

struct RecipeTitle: View {
    @ObservedObject var formData: FormData
    @ObservedObject var recipe: Recipe
    
    var body: some View {
        TextField("레시피의 이름", text: $formData.title)
            .font(.title)
            .padding(.bottom, 8)
    }
}

struct RecipeDetail: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var recipe: Recipe
    
    @StateObject private var formData: FormData = FormData()
    
    func initFormData() {
        formData.title = recipe.safeTitle
        formData.steps = recipe.stepArray.map {
            let step = StepInput()
            step.id = $0.order
            step.text = $0.safeText
            return step
        }
        print(formData.steps)
    }

    var body: some View {
        RecipeTitle(formData: formData, recipe: recipe)
            .padding([.top, .leading], 16)
        
        List {
            ForEach(0..<formData.steps.count, id: \.self) { i in
                TextField(
                    "단계를 입력하세요",
                    text: $formData.steps[i].text
                )
            }
            Button("단계 추가") {
                let step = StepInput()
                step.id = (formData.steps.last?.id ?? 0) + 1
                step.text = ""
                formData.steps = formData.steps + [step]
            }
            
        }
        .onAppear(perform: initFormData)
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        Text("No previews yet")
//        RecipeDetail()
    }
}
