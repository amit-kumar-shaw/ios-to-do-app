//
//  ProjectList.swift
//  ios to do app
//
//  Created by dasoya on 29.01.23.
//

import SwiftUI
import Foundation

struct ProjectListRow: View {
    
    
    @Binding var project : Project?
    @Binding var isSortedByLanguage : Bool
    @State var projectId :String
    @State var showModal = false
    
   // @ObservedObject var homeView = HomeView()
    @ObservedObject var viewModel = ProjectViewModel()
    
    init(project: (String, Binding<Project?>),isSortedByLanguage: Binding<Bool>){
        
        self._project = project.1
        self.projectId = project.0
        
        self._isSortedByLanguage = isSortedByLanguage
    }
    
    init(project: (String, Binding<Project?>)){
        
        self._project = project.1
        self.projectId = project.0
        
        self._isSortedByLanguage = .constant(false)
    }
    
    var body: some View {
        HStack {
            Circle()
                .foregroundColor(Color(hex: project!.colorHexString ?? "#FFFFFF"))
                .frame(width: 12, height: 12)
            Text(project!.projectName ?? "Untitled")
            Text(project!.selectedLanguage.name)
                .foregroundColor(.gray)
        }
        .swipeActions(){
            
            //Delete Projet Button
            Button (action: {
                showModal = true
                isSortedByLanguage = false
            }){
                    Label("info", systemImage: "info.circle")
                }.tint(.indigo)
            
            //Edit Mode Button
            Button (action: {
                viewModel.deleteProject(projectId : projectId)
                isSortedByLanguage = false
            }){
                    Label("delete", systemImage: "minus.circle")
                }.tint(.red)
            
        }.sheet(isPresented: $showModal) {
        
            CreateProjectView(project: (self.projectId, self.$project), showModal: $showModal)
            
        }
        
    }
    
}
