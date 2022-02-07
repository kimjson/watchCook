//
//  RecipeDetail.swift
//  watchCook
//
//  Created by jaeseong on 2022/02/07.
//

import SwiftUI

struct RecipeDetail: View {
    var recipe: Recipe?
    
    var title: String {
        recipe?.title ?? "이름없는 레시피"
    }
    var steps: [Step] {
        recipe?.steps ?? []
    }


    var body: some View {
        NavigationView {
            List {
                ForEach((0..<steps.count)) { i in
                    NavigationLink {
                        Text(steps[i].text)
                    } label: {
                        Text(steps[i].text)
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                NavigationLink("단계 추가", destination: Text("추가된 단계"))
            }
        }
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetail()
    }
}
