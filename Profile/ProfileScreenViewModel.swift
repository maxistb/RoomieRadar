////
//// Created by Maximillian Stabe on 20.01.24.
//// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
////
//
//import FirebaseAuth
//import Foundation
//import RoomieRadarCoreData
//import SwiftUI
//
//class ProfileScreenViewModel: ObservableObject {
//  @Published var wgOffererAddress = ""
//  @Published var wgOffererContactInfo = ""
//  @Published var wgOffererIdealRoommate = ""
//  @Published var wgOffererImageString = ""
//  @Published var wgOffererName = ""
//  @Published var wgDescription = ""
//  @Published var wgPrice = ""
//  @Published var wgSize = ""
//
//  @Published var wgSearcherAge = ""
//  @Published var wgSearcherContactInfo = ""
//  @Published var wgSearcherGender = ""
//  @Published var wgSearcherHobbies = ""
//  @Published var wgSearcherImageString = ""
//  @Published var wgSearcherName = ""
//  @Published var wgSearcherOwnDescription = ""
//
//  @FetchRequest var wgSearcher: FetchedResults<WGSearcher>
//  @FetchRequest var wgOfferer: FetchedResults<WGOfferer>
//
//  let viewState: ViewStates
//
//  init(user: User) {
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
//    let searcherCount = _wgSearcher.wrappedValue.count
//    let offererCount = _wgOfferer.wrappedValue.count
//
//    if searcherCount > 0 {
//      self.viewState = .wgSearcher
//    } else if offererCount > 0 {
//      self.viewState = .wgOfferer
//    } else {
//      self.viewState = .error
//    }
//
//    if let wgOfferer = wgOfferer.first {
//      self.wgOffererAddress = wgOfferer.address
//      self.wgOffererContactInfo = wgOfferer.contactInfo
//      self.wgOffererIdealRoommate = wgOfferer.idealRoommate
//      self.wgOffererImageString = wgOfferer.imageString
//      self.wgOffererName = wgOfferer.name
//      self.wgDescription = wgOfferer.wgDescription
//      self.wgPrice = wgOfferer.wgPrice
//      self.wgSize = wgOfferer.wgSize
//
//    } else if let wgSearcher = wgSearcher.first {
//      self.wgSearcherAge = wgSearcher.age
//      self.wgSearcherContactInfo = wgSearcher.contactInfo
//      self.wgSearcherGender = wgSearcher.gender
//      self.wgSearcherHobbies = wgSearcher.hobbies
//      self.wgSearcherImageString = wgSearcher.imageString
//      self.wgSearcherName = wgSearcher.name
//      self.wgSearcherOwnDescription = wgSearcher.ownDescription
//    }
//  }
//}
//
//enum ViewStates {
//  case wgOfferer
//  case wgSearcher
//  case error
//}
