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
    @State private var showModal = false
    @State private var searchText = ""
    
    @ObservedObject var viewModel = ProjectViewModel()
    @ObservedObject var todoViewModel = TodoListViewModel()

    @State private var showEnableRemindersModal : Bool = false

    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .leading,spacing: 0){
                
                List{
                    Section("Welcome!")
                    {
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
                    } .headerProminence(.increased)
                }
                .frame(height: 180)
                .scrollDisabled(true)
                
                
                List {
                    Section("Languages"){
                        ForEach($viewModel.projects, id: \.0){ $item in
                            // navigate to Project to do list
                            NavigationLink(destination: ProjectListView(projectId: item.0)){                                     HStack {
                                if let colorString = item.1?.colorHexString {
                                    
                                    Circle().frame(width: 12, height: 12)
                                        .overlay(
                                            Circle().foregroundColor(Color(hex: colorString))
                                                .frame(width: 10, height: 10)
                                            
                                        )
                                }
                                Text(nameText(item: item.1))
                                
                            }
                            }
                            
                        }
                        .onDelete { indexSet in
                            let index = indexSet.first!
                            self.viewModel.deleteProject(at: index)
                        }
                        
                        .onDelete { indexSet in
                            let index = indexSet.first!
                            self.viewModel.deleteProject(at: index)
                        }
                        
                    }.headerProminence(.standard)
                    
                    
                }
                // .scrollContentBackground(.hidden)
                .overlay(content: {if viewModel.projects.isEmpty {
                    VStack{
                        Text("Create a new project!")
                    }
                }})
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        EditButton()
                    }
                    ToolbarItem (placement: .automatic){
                        self.addButton
                    }
                }
                
        }.padding(.zero)
    
        }
        .onAppear{
            NotificationUtility.hasPermissions(completion: {hasPermissions in
                if !hasPermissions, !NotificationUtility.getDontShowRemindersModal() {
                    self.showEnableRemindersModal = true
                }
            })
        }
        .fullScreenCover(isPresented: $showEnableRemindersModal) {
            EnableRemindersModalView()
        }
        //.background(Color(hex:"#FFF9DA"))
        .padding(.zero)
        .searchable(text: $searchText){
            Text("Search for todos and projects!")
        }
        .onSubmit(of: .search, performSearch)

        }
    
    
    private func performSearch(){
        //TODO: implement global search functionality
    }
    
        
        
    private var addButton: some View {
    
            return AnyView(
                Button(action:{ self.showModal = true}) {
                    Label("Add Item", systemImage: "plus")
                }.sheet(isPresented: $showModal) {
                    
                    CreateProjectView(showModal: $showModal)
                                 
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
        
//
//        private let itemFormatter: DateFormatter = {
//            let formatter = DateFormatter()
//            formatter.dateStyle = .short
//            formatter.timeStyle = .medium
//            return formatter
//        }()
//
        

}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
