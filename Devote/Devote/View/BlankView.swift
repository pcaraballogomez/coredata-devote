//
//  BlankView.swift
//  Devote
//
//  Created by Pablo Caraballo Gómez on 1/2/24.
//

import SwiftUI

struct BlankView: View {

    // MARK: - Properties
    let backgroundColor: Color
    let backgroundOpacity: Double

    // MARK: - Body
    var body: some View {
        VStack {
            Spacer()
                .frame(minWidth: .zero,
                       maxWidth: .infinity,
                       minHeight: .zero,
                       maxHeight: .infinity,
                       alignment: .center)
                .background(backgroundColor)
                .opacity(backgroundOpacity)
                .blendMode(.overlay)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

// MARK: - Preview
struct BlankView_Previews: PreviewProvider {
    static var previews: some View {
        BlankView(backgroundColor: .black,
                  backgroundOpacity: 0.3)
            .background(BackgroundImageView())
            .background(backgroundGradient.ignoresSafeArea())
    }
}
