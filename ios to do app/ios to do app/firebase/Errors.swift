//
//  Errors.swift
//  ios to do app
//
//  Created by Cristi Conecini on 17.01.23.
//

import Foundation

struct AuthError: Error{
    var localizedDescription = "Error loading todos, user not logged in"
    
}

struct ProjectNotFoundError: Error{
    var localizedDescription = "Project not found"
}
