//
//  ContentView.swift
//  ios to do app
//
//  Created by Cristi Conecini on 04.01.23.
//

import CoreData
import FirebaseAuth
import SwiftUI

///Displays the home screen with a search bar to allow users to search for projects.
struct HomeView: View {
    //State variable to hold the search text entered by the user
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            SearchableView(searchText:$searchText)
        }
        // Adds a search bar to the navigation bar
        .searchable(text: $searchText)
        .disableAutocorrection(true)
    }
    
}

///This view serves as the main view of the app and displays Today View, Upcoming View, Tag View and  Projects.
struct SearchableView: View {
    
    @Environment(\.tintColor) var tintColor
    
    @State private var offset: CGFloat = 0
    @State private var searchTerm = ""
    @State private var showModal = false
    
    ///State property `languageProjectDict` is a dictionary for sorting projects by their language
    @State private var languageProjectDict = [String:[(String,Binding<Project?>)]]()
    
    @State var showTodayView : Bool = false
    @State var isSortedByLanguage = false
    @State var projectForBinding : Project? = Project()
    
    @Binding public var searchText : String
    
    ///Observed object property  `View Model`  to load projects list and their info
    @ObservedObject var viewModel = ProjectViewModel()
    
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch
    
    init(searchText : Binding<String>){
        
        self._searchText = searchText
        
    }
    
    ///Function `upcomingList` navigates to ` UpcomingView`  with lists of upcoming to-dos, grouped by week
    ///- returns : Upcoming List View with icon and Text
    fileprivate func upcomingList() -> some View {
        return HStack {
            NavigationLink(destination: UpcomingView(), label: {
                Image(systemName: "hourglass.circle.fill").foregroundColor(tintColor)
                Text("Upcoming").foregroundColor(tintColor)
            })
        }
    }
    
    /// Function `todoyList` navigates to `TodayView`  with a list of to-dos due today.
    /// - Returns : Today List with icon and Text
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
    
    /// Function projectList displays a list of projects by navigating to ProjectListView
    /// - Parameters:
    ///     Inputs  : $viewModel.projects - an array of tuple representing projects
    /// - Returns: A list of project names each linked to its respective ProjectListView
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

    
    @ViewBuilder var body: some View {
        
        List {
            if (!isSearching) {
                
                todayList()
                
                upcomingList()
                
                tagList()
                
                if self.isSortedByLanguage {
                    /// Projects Section sorted by language
                    sortByLanguage()
                    
                } else {
                        
                    /// Projects Section
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
            ToolbarItem(placement: .automatic) {
                settingButton
            }
            
        }
        .navigationTitle("Welcome")
        .padding(.zero)
        
        
        
    }
    

   
    ///Function `addButton` displays a button that allows the user to create a new project by presenting the `CreateProjectView`  modal.
    private var addButton: some View {
        
        return AnyView(
            Button(action: { self.showModal = true }) {
                Label("Add Item", systemImage: "plus")
            }.sheet(isPresented: $showModal) {
                CreateProjectView(project: $projectForBinding, showModal: $showModal)
            }
        )
    }
    
   
    ///Displays a button that allows the user to access and change app settings such as color scheme.
    fileprivate var settingButton: some View {
        return HStack {
            NavigationLink(destination: SettingsView(), label: {
                Image(systemName: "gearshape").foregroundColor(tintColor)
            })
        }
    }
    
    ///Displays a button that allows the user to sort the projects by thier language when pressed.
    private var sortByLanguageButton : some View {
        
        return AnyView(
            Button(action: {
                
                saveLanguageDict()
                    
                isSortedByLanguage = !isSortedByLanguage }) {
                    Label("SortByLanguage", systemImage: "tray.fill")
                    
                }
        )
        
    }
    
    ///Sorts and saves the projects by their selected language in a dictionary called languageProjectDict.
    ///The dictionary uses the language name as the key and a tuple of project ID and project information as the value.
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
    
    ///Function `sortByLanguage` sorts the projects by their selected language and displays them in a list
    ///- Returns: A list of sections, each section represents a language and contains the projects for that language
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
    
 
    
   
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
