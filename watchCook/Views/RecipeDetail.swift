//
//  RecipeDetail.swift
//  watchCook
//
//  Created by jaeseong on 2022/02/07.
//

import SwiftUI

struct RecipeDetail: View {
    var recipe: Recipe
    
    var title: String {
        recipe.title
    }
    var steps: [Step] {
        recipe.steps
    }
    
    @State var editedStep: Step? = nil
    
    func createButtonAction(step: Step) -> () -> Void {
        func action() {
            editedStep = step
        }
        return action
    }
    
    func handleSheetDismiss() {
        editedStep = nil
    }

    var body: some View {
        List {
            ForEach(steps) { step in
                HStack {
                    Text(step.text)
                    Spacer()
                    Button("수정", action: createButtonAction(step: step))
                }
            }
        }
        .navigationTitle(title)
        .toolbar {
            NavigationLink("단계 추가", destination: Text("추가된 단계"))
        }
        .sheet(item: $editedStep, onDismiss: handleSheetDismiss) { item in
            StepEditSheet()
        }
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetail(recipe: ModelData().recipes[0])
    }
}
