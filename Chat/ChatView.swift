//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI

struct ChatView: View {
  let wgOfferer: WGOfferer
  var path: Binding<[MatchesNavigation]>

  var body: some View {
    NavigationStack(path: path) {
      VStack {
        Text("Child View")

        Text(wgOfferer.name)
      }
      .navigationTitle("Chat")
    }
  }
}
