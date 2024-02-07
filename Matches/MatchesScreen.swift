//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI

struct MatchesScreen: View {
  // is true if current user is wgofferer
  let isWGOffererState: Bool
  var path: Binding<[MatchesNavigation]>

  @ObservedObject private var viewModel: MatchesViewModel

  init(isWGOffererState: Bool, path: Binding<[MatchesNavigation]>) {
    self.isWGOffererState = isWGOffererState
    self.path = path
    self._viewModel = ObservedObject(initialValue: MatchesViewModel(isWGOffererState: isWGOffererState))
  }

  var body: some View {
    NavigationStack(path: path) {
      ScrollView {
        if isWGOffererState {
          ForEach(viewModel.wgSearcherMatches, id: \.id) { wgSearcher in
            MatchesListEntry(entry: wgSearcher)
            Divider()
          }
        } else {
          ForEach(viewModel.wgOffererMatches, id: \.id) { wgOfferer in
            MatchesListEntry(entry: wgOfferer)
            Divider()
          }
        }
      }
      .navigationTitle("Matches")
    }
  }
}
