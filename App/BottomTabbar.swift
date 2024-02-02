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
  let profileScreenViewModel: ProfileScreenViewModel

  init(user: User, isWGOffererState: Bool) {
    self.user = user
    self.isWGOffererState = isWGOffererState
    self.profileScreenViewModel = ProfileScreenViewModel(isWGOffererState: isWGOffererState, user: user)
  }

  var body: some View {
    TabView {
      EmptyScreen()
        .tabItem {
          Image(systemName: "bubble.left")
          Text("Matches")
        }
        .toolbarBackground(.visible, for: .tabBar)

      SwipingScreen(isWGOffererState: isWGOffererState)
        .tabItem {
          Image(systemName: "arrow.left.arrow.right")
          Text("Swiping")
        }
        .toolbarBackground(.visible, for: .tabBar)

      ProfileScreen(viewModel: profileScreenViewModel)
        .tabItem {
          Image(systemName: "person.crop.circle")
          Text("Profil")
        }
        .toolbarBackground(.visible, for: .tabBar)
    }
    .tint(Asset.Color.beatzColor.swiftUIColor)
    .navigationBarBackButtonHidden()
  }
}
