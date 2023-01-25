//
//  CreateProjectView.swift
//  ios to do app
//
//  Created by dasoya on 24.01.23.
//

import SwiftUI

struct CreateProjectView: View {
        
    
    @State private var _newProject = newProject()
    
    @Binding var showModal: Bool
    @ObservedObject var viewModel = ProjectViewModel()
    
    private let colorPalette : [String] = ["#FFCA3A","#109648","#264653","#B8B8FF","#F4A261","#FF595E","#8338EC","#3A86FF","#00AFB9"]
    private let columns = [GridItem(.adaptive(minimum: 80))]
    
    fileprivate func extractedFunc() -> some View {
        return VStack{
            ColorPicker("Color", selection: self.$_newProject.projectColor)
            
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(colorPalette, id: \.self){ colorHex in
                    
                    let color = Color(hex: colorHex)
                    
                    Circle()
                        .foregroundColor(color)
                        .frame(width: 45, height: 45)
                        .opacity(color == self._newProject.projectColor ? 0.5 : 1.0)
                        .onTapGesture {
                            self._newProject.projectColor = color
                        }
                    
                }
            }
            .padding(.vertical, 30)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading,spacing: 20){
            
            Form{
                Section{

                        VStack{
                            Text("Create a project")
                                .bold()
                                .font(.title)
                            
                            
                            
                            TextField("Project Name", text: self.$_newProject.projectName)
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
               
        
                Section{
                    Picker(selection: self.$_newProject.selectedLanguage, label: Text("Language")) {
                        LanguageList()
                    }.onReceive([self._newProject.selectedLanguage].publisher.first()) { (value) in
                        self._newProject.selectedLanguage = value
                        
                    }
                }
                
                Section{
                    extractedFunc()
                
                }
                
            }
            
            Spacer()
            
            HStack{
                Spacer()
                Button(action:   {
                    
                    self.viewModel.addProject(name: _newProject.projectName, color: _newProject.projectColor.toHex(), language:_newProject.selectedLanguage)
                    
                    self._newProject = .init()
                    self.showModal = false
                    
                }  ) {
                    Text("Add")
                } .disabled(self._newProject.projectName.isEmpty)
                    .alert("Error add project", isPresented: $viewModel.showAlert, actions: {
                        Button("Ok", action: { self.viewModel.showAlert = false })
                    }, message: { Text(self.viewModel.error?.localizedDescription ?? "Unknown error") })
                Spacer()
            }
            
        }.background(Color(UIColor.systemGroupedBackground))
       
        
    }
    
    
    
}

struct newProject {
    
    var projectName : String
    var projectColor : Color
    var selectedLanguage : Language
    
    init(){
        projectName = ""
        projectColor = Color.white
        selectedLanguage = Language(id: "en", name: "English", nativeName: "English")
    }
    
    
}

struct CreateProjectView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProjectView(showModal: .constant(false))
    }
}
