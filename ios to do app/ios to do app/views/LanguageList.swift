//
//  LanguageList.swift
//  ios to do app
//
//  Created by Cristi Conecini on 15.01.23.
//

import SwiftUI

struct LanguageList: View {
    @State var languages: [Language] = Language.getAllLanguages()
    
    var body: some View {
        ForEach(languages, id: \.id) { language in
                Text(language.name)
            }
    }
}

struct LanguageList_Previews: PreviewProvider {
    static var previews: some View {
        LanguageList()
    }
}
