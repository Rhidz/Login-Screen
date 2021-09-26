//
//  UserRequest.swift
//  Login Screen
//
//  Created by Admin on 25/09/2021.
//

import Foundation

extension Notification.Name {
    static let signInNotification = Notification.Name("SignInNotification")
    static let signOutNotification = Notification.Name("SignOutNotification")
}

struct SignUpUserRequest: APIRequest {
    let user: UserAuthentication

    init(username: String, email: String, password: String, confirmPassword: String) {
      self.user = UserAuthentication(name: username, email: email, password: password, confirmPassword:confirmPassword)
    }

    typealias Response = Void

    var method: HTTPMethod { return .POST }
    var path: String { return "/users" }
    var contentType: String { return "application/json" }
    var additionalHeaders: [String : String] { return [:] }
    var body: Data? {
      return try? JSONEncoder().encode(user)
    }
   

    func handle(response: Data) throws -> Void {
      currentSignedUpUser = user
      NotificationCenter.default.post(name: .signInNotification, object: nil)
    }
    
    
    
    
}

struct SignInUserRequest: APIRequest {
    let user: UserLogin
    
    
    init(encodedString: String ) {
        self.user = UserLogin(base64String: encodedString)
    }

    typealias Response = Void

    var method: HTTPMethod { return .POST }
    var path: String { return "/login" }
    var contentType: String { return "application/json" }
    var additionalHeaders: [String : String] { return ["Authorization":"Basic \(user.base64String)"] }
    var body: Data? {
      return nil
    }
   

    func handle(response: Data) throws -> Void {
      currentLoggedInUser = user
      NotificationCenter.default.post(name: .signInNotification, object: nil)
    }
    
    
    
    
}
