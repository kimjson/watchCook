//
//  RecipeDetail.swift
//  watchCook
//
//  Created by jaeseong on 2022/02/07.
//

import SwiftUI

struct RecipeDetail: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var recipe: Recipe
    
    @State private var isEditing: Bool = false
    
    var isEditingInitially: Bool = false
    
    func setIsEditing() {
        isEditing = isEditingInitially
    }

    var body: some View {
        List(recipe.stepArray) { step in
            HStack {
                Text(step.text ?? "")
                Spacer()
                Button("수정", action: noop)
            }
        }
//        .navigationTitle(Text(recipe.safeTitle))
//        .toolbar {
//            Button("단계 추가") {
//                _ = Recipe.randomInstance(context: moc)
//                try? moc.save()
//            }
//        }
        .onAppear(perform: setIsEditing)
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        Text("No previews yet")
//        RecipeDetail()
    }
}
