//
//  RecipeRow.swift
//  watchCook
//
//  Created by jaeseong on 2022/02/03.
//

import SwiftUI

struct RecipeRow: View {
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
                .lineLimit(1)
        }
    }
}

struct RecipeRow_Previews: PreviewProvider {
    static var previews: some View {
        RecipeRow(text: "7분김치찌개")
    }
}
