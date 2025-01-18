//
//  DisplayContentView.swift
//  VideoOnScroll
//
//  Created by Brad Angliss on 18/01/2025.
//

import SwiftUI

struct DisplayContentView: View {
    var content: DisplayContent

    var body: some View {
        VStack(alignment: .leading) {
            Text(content.text)
                .font(.title)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: content.alignment)
    }
}

#Preview {
    DisplayContentView(content: .arrange())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
}
