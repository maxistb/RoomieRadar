//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseAuth
import Styleguide
import SwiftUI

struct BottomTabbar: View {
  let user: User

  init(user: User) {
    self.user = user
  }

  var body: some View {
    TabView {
      EmptyScreen()
        .tabItem {
          Image(systemName: "bubble.left")
          Text("Matches")
        }
        .toolbarBackground(.visible, for: .tabBar)

      EmptyScreen()
        .tabItem {
          Image(systemName: "arrow.left.arrow.right")
          Text("Swiping")
        }
        .toolbarBackground(.visible, for: .tabBar)

      profileScreen
    }
    .tint(Asset.Color.beatzColor.swiftUIColor)
    .navigationBarBackButtonHidden()
  }

  private var profileScreen: some View {
    let viewModel = ProfileScreenViewModel()

    return ProfileScreen(viewModel: viewModel)
      .tabItem {
        Image(systemName: "person.crop.circle")
        Text("Profil")
      }
      .toolbarBackground(.visible, for: .tabBar)
  }
}
