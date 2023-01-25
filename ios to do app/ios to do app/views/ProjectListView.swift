//
//  ProjectListView.swift
//  ios to do app
//
//  Created by Cristi Conecini on 24.01.23.
//

import SwiftUI

struct ProjectListView: View {
    
    @ObservedObject var viewModel: ProjectListViewModel
    var projectId: String
    
    @State var selectedFilter: FilterType = .all
    
    init(projectId: String){
        self.projectId = projectId
        viewModel = ProjectListViewModel(projectId: projectId)
    }
    
    var body: some View {
        VStack {
            List{
                Section(header: header){
                    ForEach($viewModel.todoList, id: \.0, editActions: .all){
                        $item in
                        NavigationLink(destination: TodoDetail(entityId: item.0)){
                            HStack {
                                Text(item.1.task)
                                Spacer()
                                Checkbox(isChecked: $item.1.isCompleted, onToggle: {
                                    viewModel.saveTodo(entityId: item.0, Todo: item.1)
                                }
                                )
                            }
                        }
                    }
                }
            }
            .overlay(content: emptyView)
            
            //TodoList(selectedFilter, self.project.0).listStyle(.inset)
            
            HStack {
                Picker(selection: $viewModel.filter, label: Text("Filter"), content: {
                    ForEach(FilterType.allCases, id: \.self) { v in
                        Text(v.localizedName).tag(v)
                    }
                }).onChange(of: viewModel.filter) { newFilter in
                    viewModel.loadList(filter: newFilter)
                }
                NavigationLink {
                    TodoEditor(entityId: nil, projectId :projectId)
                } label: {
                    Text("Add").padding()
                }
            }
            .padding()
        }.alert("Error: \(self.viewModel.error?.localizedDescription ?? "")", isPresented: $viewModel.showAlert) {
            Button("Ok", role: .cancel){
                self.viewModel.showAlert = false;
                self.viewModel.error = nil
            }
        }.toolbar {
            EditButton()
        }
    }
    
    var header: some View {
        HStack(alignment: .bottom) {
            if let projectName = viewModel.project?.projectName {
                Text(projectName)
                    .font(.system(size: 50, weight: .ultraLight, design: .rounded))
                    .frame(width: UIScreen.main.bounds.width * 0.6)
            }
            VStack {
                Text("\(Int(viewModel.progress * 100))%")
                    .font(.system(size: 50, weight: .ultraLight, design: .rounded))
                Text("completed")
                    .font(.system(size: 18, design: .rounded))
            }
            .frame(width: UIScreen.main.bounds.width * 0.3)
        }.padding(.top, 100)
    }
    
    func emptyView()-> AnyView {
        
        if viewModel.todoList.isEmpty {
                switch(viewModel.filter){
                case .all: return AnyView(VStack{
                    
                    NavigationLink {
                        TodoEditor(entityId: nil, projectId: self.projectId)
                    } label: {
                        Label("New Todo", systemImage: "plus")
                    }.buttonStyle(.bordered)
                })
                case .incomplete: return AnyView(Text("No incomplete todos"))
                case .completed: return AnyView(Text("No completed todos"))
                }
        }
        return AnyView(EmptyView())
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView(projectId: "")
    }
}
