//
//  SelectProjectView.swift
//  ios to do app
//
//  Created by Cristi Conecini on 30.01.23.
//

import SwiftUI

///List of projects of the current user allowing selection
struct SelectProjectView: View {
    @ObservedObject private var viewModel = ProjectViewModel()
    
    var onSelect: (_ projectId: String) -> Void
    
    var body: some View {
        List(selection: $viewModel.selection){
            ForEach($viewModel.projects, id: \.0) { $item in
                HStack{
                    Circle().frame(width: 12, height: 12)
                        .overlay(
                            Circle().foregroundColor(Color(hex: item.1?.colorHexString ?? "#FFFFFF"))
                                .frame(width: 10, height: 10)
                        )
                    Text(item.1?.projectName ?? "Untitled")
                    Text(item.1?.selectedLanguage.name ?? "English")
                        .foregroundColor(.gray)
                }
            }
        }.environment(\.editMode, .constant(EditMode.active))
        Button("Move"){
            guard let projectId = viewModel.selection else {
                return
            }
            onSelect(projectId)
        }.disabled(viewModel.selection == nil).padding()
    }
}

struct SelectProjectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectProjectView(onSelect: {projectId in })
    }
}
