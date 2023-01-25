//
//  CreateProjectView.swift
//  ios to do app
//
//  Created by dasoya on 24.01.23.
//

import SwiftUI

struct CreateProjectView: View {
    
    @State private var projectName = ""
    @State private var projectColor = Color.white
    @Binding var showModal: Bool
    @ObservedObject var viewModel = ProjectViewModel()
    
    private let colorPalette : [Color] = [.red, .yellow, .orange, .purple, .blue, .indigo, .green, .mint, .black, .white]
    private let columns = [GridItem(.adaptive(minimum: 80))]
    
    var body: some View {
        VStack(alignment: .leading,spacing: 20){
            
                Text("Create a project")
                    .bold()
                    .font(.title)
                    .padding(.all,30)
                    .padding(.bottom,-25)
                
             
            TextField("Project Name", text: self.$projectName)
                    .frame(height: 55)
                    .background(.white)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 4)
                    .cornerRadius(16)
                    
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(UIColor.systemGroupedBackground))
                            )
                 
                        .padding(.horizontal,30)
                     
                      
                    
                
                    ColorPicker("Color", selection: self.$projectColor)
                        .padding(.all,30)
                        .padding(.bottom,-30)
                        .font(.title)
                        .bold()
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(colorPalette, id: \.self){ color in
                            
                            Circle()
                                .foregroundColor(color)
                                .frame(width: 45, height: 45)
                                .opacity(color == projectColor ? 0.5 : 1.0)
                                .onTapGesture {
                                    self.projectColor = color
                                }
                            
                        }
                    }
                    .padding(.top,30)
                    .background(Rectangle().cornerRadius(16).foregroundColor(.white))
                    .padding(.horizontal,30)
                    
                  
                
                Spacer()
            
            HStack{
                Spacer()
                Button(action:   {
                    
                    self.viewModel.addProject(name: self.projectName, color: self.projectColor.toHex())
                    
                    self.projectName = ""
                    self.projectColor = Color.white
                    self.showModal = false
                    
                }  ) {
                    Text("Add")
                } .disabled(self.projectName.isEmpty)
                    .alert("Error add project", isPresented: $viewModel.showAlert, actions: {
                        Button("Ok", action: { self.viewModel.showAlert = false })
                    }, message: { Text(self.viewModel.error?.localizedDescription ?? "Unknown error") })
                Spacer()
            }
            
        }.background(Color(UIColor.systemGroupedBackground))
      //  .padding(.all,50)
        //.navigationBarTitle("Create a project")
            
    }
    
}

struct CreateProjectView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProjectView(showModal: .constant(false))
    }
}
