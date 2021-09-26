//
//  UserAuthentication.swift
//  Login Screen
//
//  Created by Admin on 25/09/2021.
//

import Foundation


var currentSignedUpUser: UserAuthentication?
var currentLoggedInUser: UserLogin?

struct UserAuthentication: Codable {
  var name: String
  var email: String
  var password: String
  var confirmPassword: String
}

struct UserLogin: Codable {
    var base64String: String
}
