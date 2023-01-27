//
//  ContentView.swift
//  ios to do app
//
//  Created by Cristi Conecini on 04.01.23.
//

import CoreData
import FirebaseAuth
import SwiftUI

struct HomeView: View {
    @Environment(\.tintColor) var tintColor
    @State private var offset: CGFloat = 0
    @State private var searchTerm = ""
    @State private var projectName = ""
    @State private var projectColor = Color.white
    @State private var showModal = false
    @State private var searchText = ""
    
    @ObservedObject var viewModel = ProjectViewModel()
    @ObservedObject var todoViewModel = TodoListViewModel()
    
    @State private var showEnableRemindersModal : Bool = false

    
  
    
    fileprivate func upcomingList() -> some View {
        return HStack {
            NavigationLink(destination: UpcomingView(), label: {
                Image(systemName: "hourglass.circle.fill")
                Text("Upcoming")
            })
        }
    }
    
    fileprivate func todayList() -> some View{
        return HStack {
            NavigationLink(destination: TodayView(),
                           label: {
                Image(systemName: "calendar.badge.exclamationmark")
                Text("Today")
            })
        }
    }
    
    fileprivate func settingList() -> some View {
        return HStack {
            NavigationLink(destination: SettingsView(), label: {
                Image(systemName: "gearshape")
                Text("Setting")
            })
        }
    }
    
    fileprivate func projectList() -> some View {
        return ForEach($viewModel.projects, id: \.0) { $item in
            // navigate to Project to do list
            NavigationLink(destination: ProjectListView(projectId: item.0)) {
               
                //show a project list
                ProjectListRow(project: (item.0, $item.1))
                
            }
        }
        .onDelete { indexSet in
            let index = indexSet.first!
            self.viewModel.deleteProject(at: index)
        }
        .headerProminence(.standard)
    }
    
    var body: some View {
        NavigationView {
            List {
                
                //Home View Lists
                upcomingList()
                
                todayList()
                
                settingList()
                
                
                // Projects Section
                Section {
                    
                    if viewModel.projects.isEmpty {
                        addButton
                    } else {
                        
                        projectList()
                        
                    } }header: {
                        Text("Projects").font(.headline).foregroundColor(.accentColor)
                    }
            }
            .listStyle(.insetGrouped)
            .padding(.zero)
            
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    EditButton()
                }
                ToolbarItem(placement: .automatic) {
                    addButton
                }
            }
            .navigationTitle("Welcome")
            .searchable(text: $searchText) {
                Text("Search for todos and projects!")
            }
            .onSubmit(of: .search, performSearch)
            .onAppear {
                NotificationUtility.hasPermissions(completion: { hasPermissions in
                    if !hasPermissions, !NotificationUtility.getDontShowRemindersModal() {
                        self.showEnableRemindersModal = true
                    }
                })
            }
            .fullScreenCover(isPresented: $showEnableRemindersModal) {
                EnableRemindersModalView().tint(tintColor)
            }
            .padding(.zero)
        }
    }
    
    private func performSearch() {
        // TODO: implement global search functionality
    }
    
    private var addButton: some View {
        
        @State var projectForBinding :Project? = Project()
        
        return AnyView(
            Button(action: { self.showModal = true }) {
                Label("Add Item", systemImage: "plus")
            }.sheet(isPresented: $showModal) {
                CreateProjectView(project: $projectForBinding, showModal: $showModal)
            }
        )
    }
    
}

struct ProjectListRow: View {
    
    
    @Binding var project : Project?
    @State var projectId :String // 왜 옵셔널?
    @State var showModal = false
    
    
    init(project: (String, Binding<Project?>)){ //여기 프로젝트도 바인딩 되야함.
        
        self._project = project.1
        self.projectId = project.0
        
    }
    
    
    var body: some View {
        HStack {
            
            Circle().frame(width: 12, height: 12)
                .overlay(
                    Circle().foregroundColor(Color(hex: project!.colorHexString ?? "#FFFFFF"))
                        .frame(width: 10, height: 10)
                )
            
            Text(project!.projectName ?? "Untitled")
            Text(project!.selectedLanguage.name)
                .foregroundColor(.gray)
        }
        .swipeActions(){
            
            //Edit Mode Button
            Button (action: {
                showModal = true }){
                    Label("info", systemImage: "info.circle")
                }
            
        }.sheet(isPresented: $showModal) {
            //EditMode
            CreateProjectView(project: (self.projectId, self.$project), showModal: $showModal)
            
        }.tint(.indigo)
        
    }
    
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
