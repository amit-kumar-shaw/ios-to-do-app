//
//  ContentView.swift
//  ios to do app
//
//  Created by Cristi Conecini on 04.01.23.
//

import SwiftUI
import CoreData
import FirebaseAuth

struct HomeView: View {
    @State private var offset: CGFloat = 0
    @State private var searchTerm = ""
    @State private var projectName = ""
    @State private var projectColor = Color.white
    @State private var  showModal = false
    @ObservedObject var viewModel = ProjectViewModel()
    @ObservedObject var todoViewModel = TodoListViewModel()

    @State private var showEnableRemindersModal : Bool = false

    var body: some View {
        
        NavigationView {
            
            
            VStack(alignment: .leading,spacing: 0){
                
                if offset > 0 {
                        HStack {
                            TextField("Search", text: $todoViewModel.searchTerm)

                            Image(systemName: "magnifyingglass")
                        }
                    
                    .cornerRadius(10)
                        .padding(20)
                        
                }
                
                Text("Welcome")
                    .font(.system(size: 32))
                    .padding(.leading,20)
                    .font(.title)
                
                
                List{
                        
                        HStack{
                            NavigationLink(destination: UpcomingView(), label: {
                                Image(systemName: "hourglass.circle.fill")
                                Text("Upcoming")
                            })
                        }
                        
                        HStack{
                            NavigationLink(destination: TodoView(project:("todayId",Project(projectName: "Today", projectColor: Color.white )) )
                                           , label: {
                                Image(systemName: "calendar.badge.exclamationmark")
                                Text("Today")
                            })
                        }
                        
                        HStack{
                            NavigationLink(destination: SettingsView(), label: {
                                Image(systemName: "gearshape")
                                Text("Setting")
                            })
                        }
                        
                    }
                    .frame(height: 180)
                    //.scrollDisabled(true)
                    .scrollContentBackground(.hidden)
                    
                ScrollView(showsIndicators: false) {
                    List {
                        if searchTerm != ""{
                            ForEach($todoViewModel.todoList, id: \.0){
                                $item in
                                NavigationLink(destination: TodoDetail(entityId: item.0)){
                                    HStack {
                                        Text(item.1.task)
                                        Spacer()
                                        Button(action: {}) {
                                            Checkbox(isChecked: $item.1.isCompleted, onToggle: {
                                                todoViewModel.saveTodo(entityId: item.0, todo: item.1)
                                            })
                                        }
                                    }
                                }
                            }
                            .onDelete { indexSet in
                                let index = indexSet.first!
                                self.viewModel.deleteProject(at: index)
                            }
                            
                        }else{
                            ForEach($viewModel.projects, id: \.0){ $item in
                                NavigationLink(destination: TodoView( project: (item.0,item.1!))){ // init with Project id
                                    HStack {
                                        
                                        Text(nameText(item: item.1))
                                        
                                    }
                                }
                                
                            }
                            .onDelete { indexSet in
                                let index = indexSet.first!
                                self.viewModel.deleteProject(at: index)
                            }
                        }
                        
                    }
                    .scrollContentBackground(.hidden)
                    .overlay(content: {if viewModel.projects.isEmpty {
                        VStack{
                            Text("Creat a new project!")
                        }
                    }})
                    .toolbar {
                        ToolbarItem(placement: .automatic) {
                            EditButton()
                        }
                        ToolbarItem (placement: .automatic){
                            self.addButton
                        }
                    }}.gesture(
                        DragGesture()
                            .onChanged { value in
                                self.offset = value.translation.height
                            }
                    )
                }.padding(.zero)
                .background(Color(hex:"#FFF9DA"))
            
            
        }.onAppear{
            NotificationUtility.hasPermissions(completion: {hasPermissions in
                if !hasPermissions, !NotificationUtility.getDontShowRemindersModal() {
                    self.showEnableRemindersModal = true
                }
            })
        }
        .fullScreenCover(isPresented: $showEnableRemindersModal) {
            EnableRemindersModalView()
        }
        .padding(.zero)

}
    
        
        
    private var addButton: some View {
            
            return AnyView(
                Button(action:{ self.showModal = true}) {
                    Label("Add Item", systemImage: "plus")
                }.sheet(isPresented: $showModal) {
                    VStack {
                        Text("Creat a Project!")
                            .font(.title)
                        
                        TextField("Project Name", text: self.$projectName)
                        ColorPicker("Project Color", selection: self.$projectColor)
                        
                        Button(action:   {
                            
                            self.viewModel.addProject(name: self.projectName, color: self.projectColor.toHex())
                            self.showModal = false
                            
                        }  ) {
                            Text("Add")
                        } .disabled(self.projectName.isEmpty)
                            .alert("Error add project", isPresented: $viewModel.showAlert, actions: {
                                Button("Ok", action: { self.viewModel.showAlert = false })
                            }, message: { Text(self.viewModel.error?.localizedDescription ?? "Unknown error") })
                        
                    }.padding(.all,50)
                    
                }
            )
        }
        
        private func nameText(item : Project?) -> String {
            
            if let item = item {
                
                if let name = item.projectName {
                    return name
                }
                
            }
            
            return "Untitled"
        }
        
        
        private let itemFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .medium
            return formatter
        }()
        
        
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
