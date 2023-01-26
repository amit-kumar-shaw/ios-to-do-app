//
//  SearchView.swift
//  ios to do app
//
//  Created by Cristi Conecini on 25.01.23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SearchView: View {
    
    let searchText = "index"

    
    var body: some View {
        Text("Search for todos and projects!").onAppear{
            Firestore.firestore().collection("projects").whereField("indexData", arrayContains: searchText).getDocuments { qs, err in
                    if err == nil {
                        let docs = qs?.documents.map({ docSnap in
                            return docSnap.data()
                        })
                        
                        print("results: \(docs)")
                    }
                }
        }
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView(searchText: "")
//    }
//}
