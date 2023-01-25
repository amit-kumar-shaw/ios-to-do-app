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

    @State private var showEnableRemindersModal: Bool = false

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
                            Text("Setting")
                        })
                    }
                }
                    
                Section{
                    if viewModel.projects.isEmpty {
                        addButton
                    } else {
                        ForEach($viewModel.projects, id: \.0) { $item in
                            NavigationLink(destination: TodoView(project: (item.0, item.1!))) { // init with Project id
                                HStack {
                                    Text(nameText(item: item.1))
                                }
                            }
                                
                        }.onDelete { indexSet in
                            let index = indexSet.first!
                            self.viewModel.deleteProject(at: index)
                        }
                    }
                } header: {
                    Text("Projects").font(.headline).foregroundColor(.accentColor)
                }
            }
                
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    EditButton()
                }
                ToolbarItem(placement: .automatic) {
                    self.addButton
                }
            }
            .navigationTitle("Welcome")
        }
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
    
    private func performSearch() {
        // TODO: implement global search functionality
    }
    
    private var addButton: some View {
        return AnyView(
            Button(action: { self.showModal = true }) {
                Label("Create project", systemImage: "plus")
            }.sheet(isPresented: $showModal) {
                VStack {
                    Text("Creat a Project!")
                        .font(.title)
                        
                    TextField("Project Name", text: self.$projectName)
                    ColorPicker("Project Color", selection: self.$projectColor)
                        
                    Button(action: {
                        self.viewModel.addProject(name: self.projectName, color: self.projectColor.toHex())
                        self.showModal = false
                            
                    }) {
                        Text("Add")
                    }.disabled(self.projectName.isEmpty)
                        .alert("Error add project", isPresented: $viewModel.showAlert, actions: {
                            Button("Ok", action: { self.viewModel.showAlert = false })
                        }, message: { Text(self.viewModel.error?.localizedDescription ?? "Unknown error") })
                        
                }.padding(.all, 50)
            }
        )
    }
        
    private func nameText(item: Project?) -> String {
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
        HomeView()
    }
}
