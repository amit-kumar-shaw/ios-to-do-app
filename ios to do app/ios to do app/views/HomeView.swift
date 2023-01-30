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
   
    @State private var showModal = false
    @State var isSortedByLanguage = false
    @State private var languageProjectDict = [String:[(String,Binding<Project?>)]]()
 
    @State var projectForBinding :Project? = Project()
    
    @ObservedObject var viewModel = ProjectViewModel()
    @ObservedObject var todoViewModel = TodoListViewModel()
    
    @State var showTodayView : Bool = false
    
    @Binding public var searchText : String
    //    @State private var showEnableRemindersModal : Bool = false
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch
    
    init(searchText : Binding<String>){
        
        self._searchText = searchText
        
    }
    
    
    fileprivate func upcomingList() -> some View {
        return HStack {
            NavigationLink(destination: UpcomingView(), label: {
                Image(systemName: "hourglass.circle.fill").foregroundColor(tintColor)
                Text("Upcoming").foregroundColor(tintColor)
            })
        }
    }
    
    fileprivate func todayList() -> some View{
        return HStack {
            
            NavigationLink(destination: TodayView(),
                           isActive: $showTodayView,
                           label: {
                Image(systemName: "calendar.badge.exclamationmark").foregroundColor(tintColor)
                Text("Today").foregroundColor(tintColor)
            })
        }.onOpenURL{ url in
            guard url.scheme == "widget-deeplink" else { return }
            showTodayView = true
        }
    }
    
    /// Link to Tags filter View
    /// - Returns: A cell to access Tags filter view
    fileprivate func tagList() -> some View{
        return HStack {
            NavigationLink(destination: TagView(),
                           label: {
                Image(systemName: "number.square.fill").foregroundColor(tintColor)
                Text("Tags").foregroundColor(tintColor)
            })
        }
    }
    
    fileprivate func settingList() -> some View {
        return HStack {
            NavigationLink(destination: SettingsView(), label: {
                Image(systemName: "gearshape").foregroundColor(tintColor)
                Text("Settings").foregroundColor(tintColor)
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
                
                if self.isSortedByLanguage {
                    // Projects Section sorted by language
                    sortByLanguage() } else {
                    // Projects Section
                    Section {
                        
                        if viewModel.projects.isEmpty { addButton
                        } else {
                            projectList()
                        } }header: {
                            Text("Projects").foregroundColor(tintColor).font(.headline)
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
        .padding(.zero)
        
        
        
    }
    
   
    
    private var addButton: some View {
        
        
        
        return AnyView(
            Button(action: { self.showModal = true }) {
                Label("Add Item", systemImage: "plus")
            }.sheet(isPresented: $showModal) {
                CreateProjectView(project: $projectForBinding, showModal: $showModal)
            }
        )
    }
    
    func saveLanguageDict(){
        
        languageProjectDict = [:]
        
        for item in $viewModel.projects {
            
            let key = item.1.wrappedValue?.selectedLanguage.name ?? "None"
            let value = (item.0.wrappedValue,item.1.self)
            
            
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
                
                saveLanguageDict()
                    
                
                isSortedByLanguage = !isSortedByLanguage }) {
                    Label("SortByLanguage", systemImage: "tray.fill")
                    
                }
        )
        
    }
    
    private func sortByLanguage() -> some View {

        var languageListsViews = [AnyView]()

        languageProjectDict.forEach{ language, values in

            let section = Section(header: Text(language)){

                ForEach(values, id:\.0){ value in

                    NavigationLink(destination: ProjectListView(projectId: value.0) ){

                        //show a project list
                        ProjectListRow(project: (value.0, value.1), isSortedByLanguage : $isSortedByLanguage)

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
    
    
    fileprivate func projectList() -> some View {
        return ForEach($viewModel.projects, id: \.0) { $item in
            // navigate to Project to do list
            NavigationLink(destination: ProjectListView(projectId: item.0)) {
                
                //show a project list
                ProjectListRow(project: (item.0, $item.1),isSortedByLanguage : $isSortedByLanguage)
                
            }
        }
        .headerProminence(.standard)
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
