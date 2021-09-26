import Foundation

enum HTTPMethod: String {
  case GET
  case POST
  case PUT
}

//struct EmptyParams: QueryParams { }

protocol APIRequest {
  associatedtype Response
  

  var method: HTTPMethod { get }
  var path: String { get }
  var contentType: String { get }
  var additionalHeaders: [String: String] { get }
  var body: Data? { get }
 // var params: QueryParamsType? { get }

  func handle(response: Data) throws -> Response
}
