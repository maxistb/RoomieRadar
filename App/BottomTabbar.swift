//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

struct BottomTabbar: View {
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
          Text("Matches")
        }
        .toolbarBackground(.visible, for: .tabBar)

      EmptyScreen()
        .tabItem {
          Image(systemName: "person.crop.circle")
          Text("Matches")
        }
        .toolbarBackground(.visible, for: .tabBar)
    }
    .tint(Asset.Color.beatzColor.swiftUIColor)
  }
}
