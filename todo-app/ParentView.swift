//
//  ParentView.swift
//  todo-app
//
//  Created by Raymond Ndlovu on 10/06/2024.
//

import SwiftUI

struct ParentView: View {
    @State private var user: User?

    var body: some View {
        if let _ = user {
            ContentView()
        } else {
            LoadingView(user: $user)
        }
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView()
    }
}

