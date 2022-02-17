//
//  RecipeDetail.swift
//  watchCook
//
//  Created by jaeseong on 2022/02/07.
//

import SwiftUI

class StepInput: ObservableObject {
    @Published var text: String = ""
    @Published var seconds: Int32 = 0
}

class FormData: ObservableObject {
    @Published var title: String = ""
    @Published var steps: [StepInput] = []
}

struct TextFieldClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            
            if !text.isEmpty {
                Button(
                    action: { self.text = "" },
                    label: {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(Color(UIColor.opaqueSeparator))
                    }
                )
                    .padding(.trailing, 16)
            }
        }
    }
}

struct RecipeTitle: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var formData: FormData
    @ObservedObject var recipe: Recipe
    
    @FocusState private var titleFieldIsFocused: Bool
    
    var body: some View {
        TextField("레시피의 이름", text: $formData.title)
            .font(Font.title.bold())
            .focused($titleFieldIsFocused)
            .onChange(of: titleFieldIsFocused) { titleFieldIsFocused in
                if !titleFieldIsFocused && recipe.title != formData.title {
                    recipe.title = formData.title
                    try? moc.save()
                }
            }
            .disableAutocorrection(true)
            .modifier(TextFieldClearButton(text: $formData.title))
    }
}

struct RecipeDetail: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var recipe: Recipe
    
    @StateObject private var formData: FormData = FormData()
    
    @FocusState private var focusedIndex: Int?
    
    func initFormData() {
        formData.title = recipe.safeTitle
        formData.steps = recipe.stepArray.map {
            let step = StepInput()
            step.text = $0.safeText
            step.seconds = $0.seconds
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
    
    func zeroPad(number: Int32) -> String {
        if number == 0 {
            return "00"
        } else {
            return "\(number)"
        }
    }
    
    func stepTimerText(step: StepInput) -> String {
        if step.seconds > 0 {
            let minutes: Int32 = step.seconds / 60
            let seconds: Int32 = step.seconds % 60
            return "\(zeroPad(number: minutes)):\(zeroPad(number: seconds))"
        } else {
            return "타이머 추가"
        }
    }

    var body: some View {
        RecipeTitle(formData: formData, recipe: recipe)
            .padding([.top, .leading], 16)
        
        List {
            ForEach(0..<formData.steps.count, id: \.self) { i in
                VStack {
                    TextEditor(
                        text: $formData.steps[i].text
                    )
                        .focused($focusedIndex, equals: i)
                        .onChange(of: focusedIndex) { focusedIndex in
                            print("inside on change: \(recipe.stepArray.count)")
                            if recipe.stepArray[i].text != formData.steps[i].text {
                                recipe.stepArray[i].text = formData.steps[i].text
                                try? moc.save()
                            }
                        }
                        .disableAutocorrection(true)
                        .frame(minHeight: 40)
                    HStack {
                        Spacer()
                        Button(stepTimerText(step: formData.steps[i])) {
                            
                        }
                    }
                    
                }
            }
            Button(action: {
                let step = Step(context: moc)
                step.text = ""
                step.order = recipe.lastStepOrder + 1
                recipe.addToSteps(step)
                
                print("after add step click: \(recipe.stepArray.count)")
                
                let stepInput = StepInput()
                stepInput.text = ""
                formData.steps = formData.steps + [stepInput]
                
                focusedIndex = formData.steps.count - 1
            }, label: {Text("단계 추가").bold()})
        }
        .navigationTitle("레시피 상세")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: initFormData)
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        Text("No previews yet")
//        RecipeDetail()
    }
}
