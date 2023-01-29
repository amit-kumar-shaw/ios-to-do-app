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
    @State private var languageProjectDict = [String:[(String,Binding<Project?>)]]()
    @Binding public var searchText : String
    
    @ObservedObject var viewModel = ProjectViewModel()
    @ObservedObject var todoViewModel = TodoListViewModel()
    
    //    @State private var showEnableRemindersModal : Bool = false
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch
    
    init(searchText : Binding<String>){
        
        self._searchText = searchText
        
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
    
    fileprivate func tagList() -> some View{
        return HStack {
            NavigationLink(destination: TagView(),
                           label: {
                Image(systemName: "number.square.fill")
                Text("Tags")
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
            if (!isSearching) {
                
                
                upcomingList()
                
                todayList()
                
                tagList()
                
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
            else {
                SearchView(searchText: $searchText)
            }
            
            
            
        }
        
        .toolbar {
            ToolbarItem(placement: .automatic) {
                
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
        .headerProminence(.standard)
    }
    
    //    private func performSearch() {
    //        // TODO: implement global search functionality
    //    }
    //
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
    
    func saveLanguageDict(){
        
        //  var projectArray = [(String : Binding<Project?>)]
        
        for item in $viewModel.projects {
            
            let key = item.1.wrappedValue?.selectedLanguage.name ?? "None"
            let value = (item.0.wrappedValue,item.1)
            
            
            if var projects = languageProjectDict[key] {
                projects.append(value)
                languageProjectDict[key] = projects
            } else {
                languageProjectDict[key] = [value]
            }
            
        }
        
    }
    
    private var sortByLanguageButton : some View {
        
       // var isEmpty =  saveLanguageDict.count == 0
        return AnyView(
            Button(action: {
                
                if languageProjectDict.isEmpty
                {   saveLanguageDict()
                    
                }
                isSortByLanguage = !isSortByLanguage }) {
                    Label("SortByLanguage", systemImage: "tray.fill")
                    
                }
        )
        
    }
    
    private func sortByLanguage() -> some View {

        var languageListsViews = [AnyView]() // [Section<Any, Any, Any>]

        languageProjectDict.forEach{ language, values in

            let section = Section(header: Text(language)){

                ForEach(values, id:\.0){ value in

                    NavigationLink(destination: ProjectListView(projectId: value.0) ){

                        //show a project list
                        ProjectListRow(project: (value.0, value.1))

                    }
                }
            }

            
            languageListsViews.append(AnyView(section))

        }
        
       

        return Group {

            ForEach(0...languageListsViews.count-1,id: \.self) { index in
                languageListsViews[index]
            }

        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
