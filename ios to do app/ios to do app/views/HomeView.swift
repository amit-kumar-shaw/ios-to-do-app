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
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        NavigationLink(destination: UpcomingView(), label: {
                            Image(systemName: "hourglass.circle.fill")
                            Text("Upcoming")
                        })
                    }
                    
                    HStack {
                        NavigationLink(destination: TodayView(),
                                       label: {
                            Image(systemName: "calendar.badge.exclamationmark")
                            Text("Today")
                        })
                    }
                    
                    HStack {
                        NavigationLink(destination: SettingsView(), label: {
                            Image(systemName: "gearshape")
                            Text("Settings")
                        })
                    }
                }
                
                Section {
                    if viewModel.projects.isEmpty {
                        addButton
                    } else {
                        
                        ForEach($viewModel.projects, id: \.0) { $item in
                            // navigate to Project to do list
                            NavigationLink(destination: ProjectListView(projectId: item.0)) {
                                ProjectListRow(project: item.1!)
                            }
                        }
                        .onDelete { indexSet in
                            let index = indexSet.first!
                            self.viewModel.deleteProject(at: index)
                        }
                        .headerProminence(.standard)
                        
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
//            .searchable(text: $searchText) {
//                SearchView(searchText: $searchText)
//            }
//            .onSubmit(of: .search, performSearch)
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
        .searchable(text: $searchText) {
            SearchView(searchText: $searchText)
        }
        .onSubmit(of: .search, performSearch)
    }
    
    private func performSearch() {
        // TODO: implement global search functionality
    }
    
    private var addButton: some View {
        return AnyView(
            Button(action: { self.showModal = true }) {
                Label("Add Item", systemImage: "plus")
            }.sheet(isPresented: $showModal) {
                CreateProjectView(showModal: $showModal)
            }
        )
    }
    
    private func nameText(item: Project?) -> String {
        guard let item = item, let name = item.projectName else {
            return "Untitled"
        }
        
        return name
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

struct ProjectListRow: View {
    
    
    var project: Project
    
    
    var body: some View {
        HStack {
            Circle().frame(width: 12, height: 12)
                .overlay(
                    Circle().foregroundColor(Color(hex: project.colorHexString ?? "#FFFFFF"))
                        .frame(width: 10, height: 10)
                )
            
            Text(project.projectName ?? "Untitled")
            Text(project.selectedLanguage.name)
                .foregroundColor(.gray)
        }
    }
    
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
