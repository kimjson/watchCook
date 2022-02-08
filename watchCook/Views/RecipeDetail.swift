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
    
    func handleAddStep() {
        
    }

    var body: some View {
        List {
            ForEach(steps) { step in
                HStack {
                    Text(step.text)
                    Spacer()
                    Button("수정", action: noop)
                }
            }
        }
        .navigationTitle(title)
        .toolbar {
            Button("단계 추가", action: handleAddStep)
        }
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetail(recipe: ModelData().recipes[0])
    }
}
