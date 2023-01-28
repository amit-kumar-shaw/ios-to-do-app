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
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            SearchableView(searchText:$searchText)
        }
        .searchable(text: $searchText)
        .disableAutocorrection(true)
        .onSubmit(of: .search, performSearch)
        
    }
    
    private func performSearch() {
        // TODO: implement global search functionality
    }
}

struct SearchableView: View {
    @Environment(\.tintColor) var tintColor
    @State private var offset: CGFloat = 0
    @State private var searchTerm = ""
    // @State private var projectName = ""
    // @State private var projectColor = Color.white
    @State private var showModal = false
    @State private var isSortByLanguage = false
    @State private var languageProjectDict = [String:(String,Binding<Project?>)]()
    @Binding public var searchText : String
    
    @ObservedObject var viewModel = ProjectViewModel()
    @ObservedObject var todoViewModel = TodoListViewModel()
    
    //    @State private var showEnableRemindersModal : Bool = false
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch
    
    init(searchText : Binding<String>){
        
        self._searchText = searchText
        
    }
    
    func viewWillAppear(){
        
        
        for item in $viewModel.projects {
            
            languageProjectDict[item.1.wrappedValue?.selectedLanguage.name ?? "None"] = (item.0.wrappedValue,item.1)
        }
        
    }
    
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
   
    
    @ViewBuilder var body: some View {
        
        
        List {
            
            //Home View Lists
            upcomingList()
            
            todayList()
            
            settingList()
            
            
            
            if self.isSortByLanguage {
                
                sortByLanguage()
                  
                
            } else {
                
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
            
            
        }
        .listStyle(.insetGrouped)
        .padding(.zero)
        .onAppear(perform: viewWillAppear)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                // EditButton()
                sortByLanguageButton
            }
            ToolbarItem(placement: .automatic) {
                addButton
            }
        }
        .navigationTitle("Welcome")
        //            .searchable(text: $searchText) {
        //                SearchView(searchText: $searchText)
        //            }
        //            .onSubmit(of: .search, performSearch)
        //            .onAppear {
        //                NotificationUtility.hasPermissions(completion: { hasPermissions in
        //                    if !hasPermissions, !NotificationUtility.getDontShowRemindersModal() {
        //                        self.showEnableRemindersModal = true
        //                    }
        //                })
        //            }
        //            .fullScreenCover(isPresented: $showEnableRemindersModal) {
        //                EnableRemindersModalView().tint(tintColor)
        //            }
        .padding(.zero)
        
        //NavigationLink(destination: TodoDetail(entityId: searchTodoId), isActive: $isPresentingSearchedTodo) { EmptyView()}
        //NavigationLink(destination: TodoDetail(entityId: item.0))
        
        
        
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
    
    private var sortByLanguageButton : some View {
        
        return AnyView(
            Button(action: {viewWillAppear()
                isSortByLanguage = !isSortByLanguage }) {
                Label("SortByLanguage", systemImage: "tray.fill")
                
            }
        )
        
    }
    
    private func sortByLanguage() -> some View {
        
        var languageListsViews =  [Section<Text, NavigationLink<ProjectListRow, ProjectListView>, EmptyView>]()
        
        languageProjectDict.forEach{ language, value in
            
            var section = Section(header: Text(language)){
                    
                    NavigationLink(destination: ProjectListView(projectId: value.0) ){
                        
                        //show a project list
                        ProjectListRow(project: (value.0, value.1))
                        
                    }
                }
            
            
            languageListsViews.append(section)
            
            
        }
        
        return Group {
           
            ForEach(0...languageListsViews.count-1,id: \.self) { index in
                languageListsViews[index]
            }
            
        }
    }
    
    
//    private mutating func saveLanguageDict(){
//        for item in $viewModel.projects{
//
//            self.languageProjectDict[item.1.wrappedValue?.projectName ?? "None"] = (item.0.wrappedValue,item.1)
//        }
//
//    }
    
}

struct ProjectListRow: View {
    
    
    @Binding var project : Project?
    @State var projectId :String
    @State var showModal = false
    
    
    init(project: (String, Binding<Project?>)){
        
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
