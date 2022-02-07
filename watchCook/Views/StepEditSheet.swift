//
//  StepEditSheet.swift
//  watchCook
//
//  Created by jaeseong on 2022/02/08.
//

import SwiftUI

struct StepEditSheet: View {
    @State private var newText: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button("취소", action: noop)
                    .padding(8)
                Spacer()
                Text("레시피 단계 수정")
                    .font(.title3)
                    .bold()
                Spacer()
                Button("저장", action: noop)
                    .padding(8)
            }
            Form {
                TextField(text: $newText, prompt: Text("이 단계에선 무엇을 해야 하나요?")) {
                    Text("NewText")
                }
            }
        }
    }
}

struct StepEditSheet_Previews: PreviewProvider {
    static var previews: some View {
        StepEditSheet()
    }
}
