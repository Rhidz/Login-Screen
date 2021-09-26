//
//  APIClient.swift
//  Login Screen
//
//  Created by Admin on 25/09/2021.

import Foundation
import Combine


enum APIError: Error {
  case urlProcessingFailed
  case requestFailed(Int)
  case postProcessingFailed(Error?)
}

struct APIClient {
  let session: URLSession
  let environment: APIEnvironment

  init(session: URLSession = .shared, environment: APIEnvironment = .local) {
    self.session = session
    self.environment = environment
  }

  func publisherForRequest<T: APIRequest>(_ request: T) -> AnyPublisher<T.Response, Error> {
    var url = environment.baseUrl.appendingPathComponent(request.path)
    var urlRequest: URLRequest
    
    urlRequest = URLRequest(url: url)
    urlRequest.addValue(request.contentType, forHTTPHeaderField: "Content-Type")
    request.additionalHeaders.forEach { key, value in
      urlRequest.addValue(value, forHTTPHeaderField: key)
    }
    urlRequest.httpMethod = request.method.rawValue
    urlRequest.httpBody = request.body

    let publisher = session.dataTaskPublisher(for: urlRequest)
      .tryMap { data, response -> Data in
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
          let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
          throw APIError.requestFailed(statusCode)
        }
        return data
      }
      .tryMap { data -> T.Response in
        try request.handle(response: data)
      }
      .tryCatch { error -> AnyPublisher<T.Response, APIError> in
        if error is APIError {
          throw error
        } else {
          throw APIError.postProcessingFailed(error)
        }
      }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()

    return publisher
  }
}
