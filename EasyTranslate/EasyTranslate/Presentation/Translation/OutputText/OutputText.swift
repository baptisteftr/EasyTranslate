//
//  OutputText.swift
//  EasyTranslate
//
//  Created by Baptiste Fortier on 24/01/2023.
//

import SwiftUI

struct OutputText: View {
    @State var output: String
    var body: some View {
        Text(output)
            .frame(maxWidth: UIScreen.screenWidth/2)
    }
}

struct OutputText_Previews: PreviewProvider {
    static var previews: some View {
        OutputText(output: "")
    }
}
