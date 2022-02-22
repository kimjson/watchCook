//
//  SwiftUIView.swift
//  watchCook WatchKit Extension
//
//  Created by jaeseong on 2022/02/22.
//

import SwiftUI

struct TimerSheet: View {
    var isOpen: Binding<Bool>
    
    func closeTimerSheet() {
        isOpen.wrappedValue = false
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("5분 30초")
                    .font(.title)
                Spacer()
                HStack {
                    Button("시작") {
                        
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("타이머 닫기", action: closeTimerSheet)
                }
            }
            
                
        }
    }
}

struct TimerSheet_Previews: PreviewProvider {
    static var previews: some View {
        TimerSheet(isOpen: .constant(true))
    }
}
