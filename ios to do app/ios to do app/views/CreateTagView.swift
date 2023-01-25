//
//  CreateTagView.swift
//  ios to do app
//
//  Created by Amit Kumar Shaw on 25.01.23.
//

import SwiftUI

struct CreateTagView: View {
    @Environment(\.presentationMode) var presentation
    
    @State private var tag = ""
    private var todo: String?
    @ObservedObject private var viewModel: TagViewModel
    
    init() {
        viewModel = TagViewModel()
    }
    
    init(todoId: String) {
        viewModel = TagViewModel()
        self.todo = todoId
    }
    
    var body: some View {
        VStack{
            TextField("Tag", text: self.$tag)
            Button(action:  {
                
                self.viewModel.addTag(tag: self.tag, todo: self.todo)
                self.presentation.wrappedValue.dismiss()
                
            }  )
            {
                Text("Add")
            }
            .disabled(self.tag.isEmpty)
            .alert("Error add tag", isPresented: $viewModel.showAlert, actions: {
                    Button("Ok", action: { self.viewModel.showAlert = false })
                }, message: { Text(self.viewModel.error?.localizedDescription ?? "Unknown error") })
        }
    }
}

struct CreateTagView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTagView()
    }
}
