//
//  LoginComponents.swift
//  Login Screen
//
//  Created by Admin on 25/09/2021.
//

import SwiftUI

struct LoginComponents: View {
    
    @State var str: String = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                //.cornerRadius(10)
                .strokeBorder(Color.blue.opacity(0.60), lineWidth: 4.0)
                .foregroundColor(.blue.opacity(0.20))
           TextField("Username", text: $str)
                .frame(width: 300, height: 40, alignment: .center)//.cornerRadius(16.0)
                .padding(8)
                .autocapitalization(.none)
            
        }.frame(width: 300, height: 60, alignment: .center)
    }
}

struct LoginComponents_Previews: PreviewProvider {
        //@Binding var name = "Rhidita"
    static var previews: some View {
        LoginComponents()//.previewLayout(.sizeThatFits)
    }
}
