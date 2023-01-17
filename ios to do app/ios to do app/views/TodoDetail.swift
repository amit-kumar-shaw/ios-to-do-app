//
//  TodoDetail.swift
//  ios to do app
//
//  Created by Cristi Conecini on 17.01.23.
//

import SwiftUI
import Combine

struct TodoDetail: View {
    
    private var entityId: String
    @ObservedObject var viewModel: TodoEditorViewModel
    
    init(entityId: String) {
        self.entityId = entityId
        viewModel = TodoEditorViewModel(id: entityId)
    }
    
    
    var body: some View {
        if(viewModel.error != nil){
            Text(viewModel.error?.localizedDescription ?? "")
        }else{
            VStack {
                Text(viewModel.todo.task).font(.title)
                Text(viewModel.todo.description).font(.caption)
                
                
            }
        }
    }
}

struct TodoDetail_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetail(entityId: "FnrWh38iEZ32MNTm3904")
    }
}
