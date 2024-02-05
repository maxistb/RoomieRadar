//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseAuth
import Styleguide
import SwiftUI

enum TabSelection {
  case matches
  case swiping
  case profile
}

enum MatchesNavigation: Hashable {
  case wgOffererDetail(WGOfferer)
  case wgSearcherDetail(WGSearcher)
}

enum ProfileNavigation: Hashable {
  case profileScreen
}

enum SwipingNavigation: Hashable {
  case swipingScreen
}

struct BottomTabbar: View {
  @State private var selectedTab: TabSelection = .matches
  @State private var matchesNavigationStack: [MatchesNavigation] = []
  @State private var profileNavigationStack: [ProfileNavigation] = []
  @State private var swipingNavigationStack: [SwipingNavigation] = []

  let user: User
  let isWGOffererState: Bool
  let profileScreenViewModel: ProfileScreenViewModel

  init(user: User, isWGOffererState: Bool) {
    self.user = user
    self.isWGOffererState = isWGOffererState
    self.profileScreenViewModel = ProfileScreenViewModel(isWGOffererState: isWGOffererState, user: user)
  }

  var body: some View {
    TabView(selection: tabSelection()) {
      MatchesScreen(isWGOffererState: isWGOffererState, path: $matchesNavigationStack)
        .tag(TabSelection.matches)
        .tabItem {
          Image(systemName: "bubble.left")
          Text("Matches")
        }

      SwipingScreen(isWGOffererState: isWGOffererState, path: $swipingNavigationStack)
        .tabItem {
          Image(systemName: "arrow.left.arrow.right")
          Text("Swiping")
        }
        .tag(TabSelection.swiping)

      ProfileScreen(viewModel: profileScreenViewModel, path: $profileNavigationStack)
        .tabItem {
          Image(systemName: "person.crop.circle")
          Text("Profil")
        }
        .tag(TabSelection.profile)
    }
    .tint(Asset.Color.beatzColor.swiftUIColor)
    .navigationBarBackButtonHidden()
  }
}

extension BottomTabbar {
  private func tabSelection() -> Binding<TabSelection> {
    Binding {
      self.selectedTab
    } set: { tappedTab in

      if tappedTab == self.selectedTab {
        if matchesNavigationStack.isEmpty {
        } else {
          matchesNavigationStack = []
        }
      }
      self.selectedTab = tappedTab
    }
  }
}
