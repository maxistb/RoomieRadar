//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseAuth
import Styleguide
import SwiftUI

struct BottomTabbar: View {
  let user: User
  let isWGOffererState: Bool

  init(user: User, isWGOffererState: Bool) {
    self.user = user
    self.isWGOffererState = isWGOffererState
  }

  var body: some View {
    TabView {
      EmptyScreen()
        .tabItem {
          Image(systemName: "bubble.left")
          Text("Matches")
        }
        .toolbarBackground(.visible, for: .tabBar)

      TestMainView()
        .tabItem {
          Image(systemName: "arrow.left.arrow.right")
          Text("Swiping")
        }
        .toolbarBackground(.visible, for: .tabBar)

      profileScreen
    }
    .onAppear {
      print("STATE: \(isWGOffererState)")
    }
    .tint(Asset.Color.beatzColor.swiftUIColor)
    .navigationBarBackButtonHidden()
  }

  private var profileScreen: some View {
    let viewModel = ProfileScreenViewModel(isWGOffererState: isWGOffererState, user: user)

    return ProfileScreen(viewModel: viewModel)
      .tabItem {
        Image(systemName: "person.crop.circle")
        Text("Profil")
      }
      .toolbarBackground(.visible, for: .tabBar)
  }
}
