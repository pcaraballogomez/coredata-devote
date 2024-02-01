//
//  BlankView.swift
//  Devote
//
//  Created by Pablo Caraballo Gómez on 1/2/24.
//

import SwiftUI

struct BlankView: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(minWidth: .zero,
                       maxWidth: .infinity,
                       minHeight: .zero,
                       maxHeight: .infinity,
                       alignment: .center)
                .background(.black)
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct BlankView_Previews: PreviewProvider {
    static var previews: some View {
        BlankView()
    }
}
