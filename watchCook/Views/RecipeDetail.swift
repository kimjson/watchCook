//
//  RecipeDetail.swift
//  watchCook
//
//  Created by jaeseong on 2022/02/07.
//

import SwiftUI

class StepInput: ObservableObject {
    @Published var text: String = ""
}

class FormData: ObservableObject {
    @Published var title: String = ""
    @Published var steps: [StepInput] = []
}

struct RecipeTitle: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var formData: FormData
    @ObservedObject var recipe: Recipe
    
    var body: some View {
        TextField("레시피의 이름", text: $formData.title)
            .font(.title)
            .onSubmit {
                if recipe.title != formData.title {
                    recipe.title = formData.title
                    try? moc.save()
                }
            }
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
            step.text = $0.safeText
            return step
        }
    }
    
    var isDirty: Bool {
        if formData.title != recipe.title {
            return true
        } else if formData.steps.count != recipe.stepArray.count {
            return true
        } else {
            for i in 0..<formData.steps.count {
                if formData.steps[i].text != recipe.stepArray[i].text {
                    return true
                }
            }
            return false
        }
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
                    .onSubmit {
                        if recipe.stepArray[i].text != formData.steps[i].text {
                            recipe.stepArray[i].text = formData.steps[i].text
                            try? moc.save()
                        }
                    }
            }
            Button("단계 추가") {
                let step = Step(context: moc)
                step.text = ""
                step.order = recipe.lastStepOrder + 1
                recipe.addToSteps(step)
                
                let stepInput = StepInput()
                stepInput.text = ""
                formData.steps = formData.steps + [stepInput]
            }
        }
        .navigationTitle("레시피 상세")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: initFormData)
    }
}

struct RecipeCreate: View {
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        RecipeDetail(recipe: Recipe(context: moc))
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        Text("No previews yet")
//        RecipeDetail()
    }
}
