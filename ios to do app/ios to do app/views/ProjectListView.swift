//
//  ProjectListView.swift
//  ios to do app
//
//  Created by Cristi Conecini on 24.01.23.
//

import SwiftUI

struct ProjectListView: View {
    @Environment(\.tintColor) var tintColor
    
    @Environment(\.editMode) var editMode
    
    @ObservedObject var viewModel: ProjectListViewModel
    var projectId: String
    @State private var showModal = false
    @State var selectedFilter: FilterType = .all
    
    init(projectId: String){
        self.projectId = projectId
        viewModel = ProjectListViewModel(projectId: projectId)
    }
    
    var body: some View {
        VStack {
            List(selection: $viewModel.selection){
                Section{
                    header
                }
                Section{
                    ForEach($viewModel.todoList, id: \.0, editActions: .delete){
                        $item in
                            TodoRow(item: $item).onChange(of: item.1.isCompleted) { newValue in
                                viewModel.saveTodo(entityId: item.0, todo: item.1)
                                viewModel.cloneRecurringTodoIfNecessary(entityId: item.0, todo: item.1)
                            }
                    }
                    if showModal {
                        CreateQuickTodoView(projectId: self.projectId, show: $showModal)
                        
                    } else {
                        Label("Add Quick Todo", systemImage: "plus")
                            .foregroundColor(tintColor)
                            .onTapGesture {
                                showModal = true
                            }
                    }
                }
            }
            
            
            HStack {
                
                if editMode?.wrappedValue == EditMode.active {
                    Spacer()
                    VerticalLabelButton("Project", systemImage: "folder.fill", action: {
                        viewModel.showMoveToProject = true
                    }).sheet(isPresented: $viewModel.showMoveToProject) {
                        SelectProjectView { projectId, _ in
                            viewModel.selectionMoveToProject(projectId: projectId)
                        }
                    }.disabled(viewModel.selection.count == 0)
                    Spacer()
                    VerticalLabelButton("Priority", systemImage: "exclamationmark.circle.fill") {
                        viewModel.showChangePriority = true
                    }.sheet(isPresented: $viewModel.showChangePriority) {
                        SelectPriorityView(priority: .medium) { newPriority in
                            viewModel.selectionChangePriority(newPriority: newPriority)
                        }
                    }.disabled(viewModel.selection.count == 0)
                    Spacer()
                    VerticalLabelButton("Due date", systemImage: "calendar.badge.clock") {
                        viewModel.showChangeDueDate = true
                    }.sheet(isPresented: $viewModel.showChangeDueDate) {
                        SelectDueDateView(date: Date()) { newDate in
                            viewModel.selectionChangeDueDate(newDueDate: newDate)
                        }
                    }.disabled(viewModel.selection.count == 0)
                    Spacer()
                } else {
                    Picker(selection: $viewModel.filter, label: Text("Filter"), content: {
                        ForEach(FilterType.allCases, id: \.self) { v in
                            Text(v.localizedName).tag(v)
                        }
                    }).onChange(of: viewModel.filter) { newFilter in
                        viewModel.loadList(filter: newFilter)
                    }
                    NavigationLink {
                        CreateTodoView(projectId: projectId)
                    } label: {
                        Text("Add").padding()
                    }
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
        }.navigationTitle(viewModel.project?.projectName ?? "Project")
    }
    
    var header: some View {
        VStack(alignment: .center) {
                Text("\(Int(viewModel.progress * 100))%")
                    .font(.system(size: 50, weight: .ultraLight, design: .rounded))
                Text("completed")
                    .font(.system(size: 18, design: .rounded))
            }.frame(width: UIScreen.main.bounds.width)
    }
    
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView(projectId: "")
    }
}
