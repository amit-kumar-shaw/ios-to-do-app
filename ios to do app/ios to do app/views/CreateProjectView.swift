//
//  CreateProjectView.swift
//  ios to do app
//
//  Created by dasoya on 24.01.23.
//

import SwiftUI

struct CreateProjectView: View {
        
    
    @State var projectInfo : ProjectInfo = ProjectInfo()
    @Binding var selectedProject : Project?
    @Binding var showModal: Bool
    @ObservedObject var viewModel = ProjectViewModel()
    @State var editMode : Bool = true

    // Init to create Project
    init(project: Binding<Project?>,showModal: Binding<Bool>){
        editMode = false
        self._showModal = showModal
        self._selectedProject = project
       
    }
    
    // Init to edit Project
    init(project: (String,Binding<Project?>), showModal: Binding<Bool>){
        
        projectInfo = ProjectInfo(project: (project.0,project.1.wrappedValue!))
        self._selectedProject = project.1
        self._showModal = showModal
    }
    
    
    private let colorPalette : [String] = ["#FFCA3A","#109648","#264653","#B8B8FF","#F4A261","#FF595E","#8338EC","#3A86FF","#00AFB9"]
    private let columns = [GridItem(.adaptive(minimum: 80))]
    
    
    
    fileprivate func projectNameView() -> some View {
        return VStack{
            Text("Project Name")
                .bold()
                .font(.title)
            
            
            
            TextField("Project Name", text: self.$projectInfo.projectName)
                .frame(height: 55)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.horizontal], 4)
                .background(Color(UIColor.systemGroupedBackground))
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(UIColor.systemGroupedBackground))
                )
            
        }
    }
    
    fileprivate func selectLanguageView() -> some View {
        return Picker(selection: self.$projectInfo.selectedLanguage, label: Text("Language")) {
            LanguageList()
        }.onReceive([self.projectInfo.selectedLanguage].publisher.first()) { (value) in
            self.projectInfo.selectedLanguage = value
            
        }
    }
    
    fileprivate func selectColorView() -> some View {
        return VStack{
            ColorPicker("Color", selection: self.$projectInfo.projectColor)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(colorPalette, id: \.self){ colorHex in
                    
                    let color = Color(hex: colorHex)
                    
                    Circle()
                        .foregroundColor(color)
                        .frame(width: 45, height: 45)
                        .opacity(color == self.projectInfo.projectColor ? 0.5 : 1.0)
                        .onTapGesture {
                            self.projectInfo.projectColor = color
                        }
                    
                }
            }
            .padding(.vertical, 30)
        }
    }
    
    fileprivate func doneButtonView() -> some View {
        return HStack{
            Spacer()
            Button(action:   {
                
                if self.editMode  {
                    
                    self.viewModel.editProject(projectId : self.projectInfo.projectId!
                                               ,projectInfo: self.projectInfo)
                    selectedProject = Project(projectName: projectInfo.projectName, projectColor: projectInfo.projectColor, language: projectInfo.selectedLanguage)
                }
                else {
                    self.viewModel.addProject(projectInfo: projectInfo)
                }
                
                self.projectInfo = .init()
                self.showModal = false
                
            }  ) {
                Text("Done")
            } .disabled(self.projectInfo.projectName.isEmpty)
                .alert("Error add project", isPresented: $viewModel.showAlert, actions: {
                    Button("Ok", action: { self.viewModel.showAlert = false })
                }, message: { Text(self.viewModel.error?.localizedDescription ?? "Unknown error") })
            Spacer()
        }
    }
    
    var body: some View {
        VStack(alignment: .leading,spacing: 20){
            
            Form{
                Section{
                    projectNameView()
                }
               
                Section{
                    selectLanguageView()
                }
                
                Section{
                    selectColorView()
                }
                
            }
            
            Spacer()
            
            doneButtonView()
            
        }.background(Color(UIColor.systemGroupedBackground))
       
        
    }
    
    
    
}

struct ProjectInfo {
    
    var projectName : String
    var projectColor : Color
    var selectedLanguage : Language
    var projectId : String?
    
    init(){
        projectName = ""
        projectColor = Color.white
        selectedLanguage = Language(id: "en", name: "English", nativeName: "English")
       
    }
    
    init(id : String ,name:String,color:Color,language:Language){
        self.init()
        projectId = id
        projectName = name
        projectColor = color
        selectedLanguage = language
   
    }
    
    init(project : (String, Project)){
        
        projectId = project.0
        projectName = project.1.projectName!
        projectColor = Color(hex:project.1.colorHexString!)
        selectedLanguage = project.1.selectedLanguage
    }
    
    
}

//struct CreateProjectView_Previews: PreviewProvider {
//    static var previews: some View {
//       CreateProjectView(_newProject: $newProject(),showModal: .constant(false))
//    }
//}
