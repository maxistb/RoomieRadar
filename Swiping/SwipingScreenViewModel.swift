//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseFirestore
import Foundation
import Styleguide

final class SwipingScreenViewModel: ObservableObject {
  @Published var hasError = false
  @Published var errorMessage = ""
  @Published var wgOffererArray: [WGOfferer] = []
  var currentWGOfferer: WGOfferer? {
    wgOffererArray.first
  }


}
