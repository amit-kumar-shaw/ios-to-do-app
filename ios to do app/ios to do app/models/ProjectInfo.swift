//
//  ProjectInfo.swift
//  ios to do app
//
//  Created by dasoya on 30.01.23.
//

import Foundation
import SwiftUI


/// Project Info to store values gotten by user  for creating a project
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

