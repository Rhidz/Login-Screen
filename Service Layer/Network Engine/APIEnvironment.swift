//
//  APIEnvironment.swift
//  Login Screen
//
//  Created by Admin on 25/09/2021.
//

import Foundation

struct APIEnvironment {
  var baseUrl: URL
}

extension APIEnvironment {
  static let prod = APIEnvironment(baseUrl: URL(string: "http://192.168.1.98:8080/api/v1")!)
  static let local = APIEnvironment(baseUrl: URL(string: "http://127.0.0.1:8080/")!)
  static let local81 = APIEnvironment(baseUrl: URL(string: "http://localhost:8081/api/v1")!)

}
