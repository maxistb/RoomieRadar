//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseAuth
import RoomieRadarCoreData
import Styleguide
import SwiftUI

struct BottomTabbar: View {
  @FetchRequest var wgSearcher: FetchedResults<WGSearcher>
  @FetchRequest var wgOfferer: FetchedResults<WGOfferer>
  let user: User

  init(user: User) {
    self.user = user

    _wgSearcher = FetchRequest(
      entity: WGSearcher.entity(),
      sortDescriptors: [],
      predicate: NSPredicate(format: "id == %@", user.uid)
    )

    _wgOfferer = FetchRequest(
      entity: WGOfferer.entity(),
      sortDescriptors: [],
      predicate: NSPredicate(format: "id == %@", user.uid)
    )
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
    Group {
      if let wgSearcher = wgSearcher.first {
        let viewModel = ProfileScreenViewModel(wgOfferer: nil, wgSearcher: wgSearcher)

        ProfileScreen(viewModel: viewModel)
          .tabItem {
            Image(systemName: "person.crop.circle")
            Text("Profil")
          }
          .toolbarBackground(.visible, for: .tabBar)
      }

      if let wgOfferer = wgOfferer.first {
        let viewModel = ProfileScreenViewModel(wgOfferer: wgOfferer, wgSearcher: nil)

        ProfileScreen(viewModel: viewModel)
          .tabItem {
            Image(systemName: "person.crop.circle")
            Text("Profil")
          }
          .toolbarBackground(.visible, for: .tabBar)
      }
    }
  }
}
