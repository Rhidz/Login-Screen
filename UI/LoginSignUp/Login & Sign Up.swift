//
//  ContentView.swift
//  Login Screen
//
//  Created by Admin on 25/09/2021.
//

import SwiftUI

import Combine
// MARK:- DRAWING CONSTANTS
let purpleOpacity : Double = 0.10
let grayOpacity : Double = 0.80
let cornerradius: CGFloat = 9.0
let shadowRadius: CGFloat = 6.0

enum AuthState {
    case signIn
    case signUp
}

struct LoginSignUp: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var email: String = ""
    @State var confirmPassword:String = ""
    @State var authstate: AuthState = .signUp
    @State var validationError: Bool = false
    @State var networkOperation: AnyCancellable?
    @State var requestError = false
    @State var requestErrorText = ""
    
    private let apiClient = APIClient()
    
    var socialIcons: [String] = ["google", "facebook", "apple"]
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.11).ignoresSafeArea()
            VStack {
                VStack {
                    VStack {
                        HStack(alignment: .center) {
                            
                            TextField("Username", text: $username)
                                .textContentType(.username)
                                .autocapitalization(.none)
                            Spacer()
                            Image("username")
                        }.padding(5)
                        
                        
                        if(authstate == .signUp) {
                            HStack {
                                TextField("Email", text: $email)
                                    .textContentType(.emailAddress)
                                    .autocapitalization(.none)
                                Spacer()
                                Image("email")
                              } .padding(5) // HSTACK EMAIL
                            
                            HStack {
                                TextField("Password", text: $password)
                                    .textContentType(.password)
                                    .autocapitalization(.none)
                                Spacer()
                                Image("password")
                            }.padding(5)
                            HStack {
                                TextField("Confirm Password", text: $confirmPassword)
                                    .textContentType(.password)
                                    .autocapitalization(.none)
                                Spacer()
                                Image("password")
                            }.padding(5)
                            
                        }
                        else {
                            HStack {
                                TextField("Password", text: $password)
                                    .textContentType(.password)
                                    .autocapitalization(.none)
                                Spacer()
                                Image("password")
                            }.padding(5)
                        }
                        
                    }.padding(20) //  VSTACK 3
                    
                    Button(action: {
                        
                        doAuth()
                    }, label: {
                        Text(authstate == .signIn ? "Sign In" : "Sign Up")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                    })
                        .frame(width: 250, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        //.overlay(Rectangle())
                        .cornerRadius(16.0)
                        .foregroundColor(.blue).opacity(0.30)
                        .padding(10)// SIGNUP/LOGIN BUTTON
                    
                }//  VSTACK 2
                .frame(width: 380, height: 400)
                .background(Color.white.opacity(0.80))
                .cornerRadius(20.0)
                .shadow(radius: 16).accentColor(.white)
                .alert(isPresented: $validationError) {
                    if authstate == .signUp {
                        return Alert(title: Text("Please complete the username, email, and password fields"))
                    } else {
                        return Alert(title: Text("Please complete the username and password fields"))
                    }
                }
                
                HStack {
                    Text(authstate == .signIn ? "Don't have an account?" : "Have an account?")
                        .foregroundColor(.black.opacity(0.60))
                    Button(action: {
                        toggleAuthState()
                    }, label: {
                        Text(authstate == .signIn ? "Sign Up" : "Sign In")
                            .foregroundColor(.blue)
                    }).padding(.leading, 3)
                }.padding(15) // END OF Sign In Sign Up HSTACK
                
                Text("------ or ------")
                    .font(.body)
                    .foregroundColor(.black.opacity(0.60))
                    .padding(7)
                HStack {
                    
                    ForEach(socialIcons.indices){ icon in
                        Image("\(socialIcons[icon])").frame(width: 34, height: 34, alignment: .center)
                            .shadow(color: .gray.opacity(0.50), radius: 3)
                            .padding(5)
                            .onTapGesture {
                                // dosth
                            }
                    }
                    
                }.padding() // END OF HSTACK
                
            } // VSTACK 1
        } // ZSTACK
    }
    
    private func toggleAuthState() {
        authstate =  authstate == .signIn ? .signUp : .signIn
    }
    
    private func doAuth() {
        networkOperation?.cancel()
        switch authstate {
        case .signIn:
            doSignIn()
            print("Fix")
        case .signUp:
            doSignUp()
            
        }
    }
    
     private func doSignIn() {
        
        guard username.count > 0 && password.count > 0 else {
            validationError = true
            return
        }
         // Important
         let loginString = String(format: "%@:%@", username, password)
         let loginData = loginString.data(using: String.Encoding.utf8)!
         let base64loginString = loginData.base64EncodedString()
        
         let request = SignInUserRequest(encodedString: base64loginString)
        
         networkOperation = apiClient.publisherForRequest(request).sink(receiveCompletion: { result in
            handleResult(result)
            
          }, receiveValue: { _ in
            print("Got notification")
             })
        
        removeValues()
    }
    private func removeValues() {
        if !username.isEmpty, !password.isEmpty, !email.isEmpty, !confirmPassword.isEmpty {
            username = ""
            password = ""
            email = ""
            confirmPassword = ""
        }
    }
     
    private func doSignUp() {
        guard username.count > 0, email.count > 0, password.count > 0, confirmPassword.count > 0 else {
            validationError = true
            return
        }
        let request = SignUpUserRequest(username: username, email: email, password: password, confirmPassword: confirmPassword)
        networkOperation = apiClient.publisherForRequest(request)
            .sink(receiveCompletion: { result in
                handleResult(result)
            }, receiveValue: {_ in})
        removeValues()
    }
    
    private func handleResult(_ result: Subscribers.Completion<Error>) {
        if case .failure(let error) = result {
            // TODO: we could check for 401 and show a nicer error
            switch error {
            case APIError.requestFailed(let statusCode):
                requestErrorText = "Status code: \(statusCode)"
            case APIError.postProcessingFailed(let innerError):
                requestErrorText = "Error: \(String(describing: innerError))"
            default:
                requestErrorText = "An error occurred: \(String(describing: error))"
            }
        }
        else {
            requestErrorText = ""
            networkOperation = nil
        }
        
        requestError = requestErrorText.count > 0
    }
}


struct LoginSignUp_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignUp()
        
    }
}
