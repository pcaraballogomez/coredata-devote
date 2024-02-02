//
//  NavButtonStyle.swift
//  Devote
//
//  Created by Pablo Caraballo Gómez on 1/2/24.
//

import SwiftUI

struct NavButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .frame(minWidth: 70, minHeight: 24)
            .background(.clear)
            .overlay(
                Capsule()
                    .stroke(Color.white, lineWidth: 2)
            )
    }
}

struct NavButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Button {
                //
            } label: {
                Text("Placeholder")
            }
            .previewLayout(.sizeThatFits)
            .padding()
            .buttonStyle(NavButtonStyle())
        }
        .background(.gray)
    }
}
