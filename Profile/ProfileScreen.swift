////
//// Created by Maximillian Stabe on 20.01.24.
//// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
////
//
//import Firebase
//import RoomieRadarCoreData
//import SwiftUI
//
//struct ProfileScreen: View {
//  @FetchRequest var wgSearcher: FetchedResults<WGSearcher>
//  @FetchRequest var wgOfferer: FetchedResults<WGOfferer>
//  @State private var wgOfferer1: WGOfferer
//  @State private var wgSearcher1: WGSearcher
//  let user: User
//
//  init(user: User) {
//    self.user = user
//
//    _wgSearcher = FetchRequest(
//      entity: WGSearcher.entity(),
//      sortDescriptors: [],
//      predicate: NSPredicate(format: "id == %@", user.uid)
//    )
//
//    _wgOfferer = FetchRequest(
//      entity: WGOfferer.entity(),
//      sortDescriptors: [],
//      predicate: NSPredicate(format: "id == %@", user.uid)
//    )
//
//    _wgOfferer1 = State(initialValue: _wgOfferer.wrappedValue.first)
//    _wgSearcher1 = State(initialValue: _wgSearcher.wrappedValue.first)
//  }
//
//  var body: some View {
//    List {
//      if let wgOfferer1 = wgOfferer1 {
//        self.wgOffererView
//      } else if let wgSearcher1 = wgSearcher1 {
//        self.wgSearcherView
//      } else {
//        EmptyView()
//      }
//    }
//    .navigationTitle("Profil")
//  }
//
//  var wgOffererView: some View {
//    Text("Test")
//  }
//
//  var wgSearcherView: some View {
//    guard wgSearcher1 != nil else { return VStack {}}
//
//   
//  }
//
//
//}
