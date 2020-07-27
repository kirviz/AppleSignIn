//
//  ResultUIView.swift
//  AppleSignIn
//
//  Created by Darius Jankauskas on 08/07/2020.
//  Copyright © 2020 The Floow. All rights reserved.
//

import SwiftUI

struct ResultUIView: View {
    var body: some View {
        Form {
            HStack {
                Text("UserID:")
                Spacer()
                Text("\(UserDefaults.standard.string(forKey: "userID") ?? "-")")
            }
            HStack {
                Text("Email:")
                Spacer()
                Text("\(UserDefaults.standard.string(forKey: "email") ?? "-")")
            }
            HStack {
                Text("Name:")
                Spacer()
                Text("\(UserDefaults.standard.string(forKey: "givenName") ?? "-") \(UserDefaults.standard.string(forKey: "familyName") ?? "-")")
            }
        }.navigationBarTitle("Signed in!")
    }
}

struct ResultUIView_Previews: PreviewProvider {
    static var previews: some View {
        ResultUIView()
    }
}
