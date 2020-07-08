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
        Text("email: \(UserDefaults.standard.string(forKey: "email") ?? "-")")
    }
}

struct ResultUIView_Previews: PreviewProvider {
    static var previews: some View {
        ResultUIView()
    }
}
