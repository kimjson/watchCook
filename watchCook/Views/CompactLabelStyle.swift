//
//  CompactLabelStyle.swift
//  watchCook
//
//  Created by jaeseong on 2022/03/05.
//
import SwiftUI

struct CompactLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 4) {
            configuration.icon
            configuration.title
        }
    }
}
