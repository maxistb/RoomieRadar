//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//
// swiftlint: disable function_body_length

import FirebaseAuth
import FirebaseFirestore
import Foundation

class MatchesViewModel: ObservableObject {
  @Published var wgOffererMatches: [WGOfferer] = []
  @Published var wgSearcherMatches: [WGSearcher] = []
  let isWGOffererState: Bool
  private let database = Firestore.firestore()

  init(isWGOffererState: Bool) {
    self.isWGOffererState = isWGOffererState

    if !isWGOffererState {
      self.getWGOffererMatches { wgOfferer in
        self.wgOffererMatches = wgOfferer
      }
    } else {
      self.getWGSearcherMatches { wgSearcher in
        self.wgSearcherMatches = wgSearcher
      }
    }
  }

  func getWGOffererMatches(completion: @escaping ([WGOfferer]) -> Void) {
    var wgOffererArray: [WGOfferer] = []

    if let currentUserID = Auth.auth().currentUser?.uid {
      var currentUserLikes: [String] = []
      var currentUserLikedBy: [String] = []
      var matches: [String] {
        currentUserLikes.filter { currentUserLikedBy.contains($0) }
      }

      let group = DispatchGroup()

      group.enter()
      self.database.collection("Swipes").document(currentUserID).getDocument { documentSnapshot, error in
        defer {
          group.leave()
        }

        guard let documentSnapshot = documentSnapshot, error == nil else {
          completion([])
          return
        }

        let documentData = documentSnapshot.data()

        guard let likes = documentData?["liked"] as? [String],
              let likedBy = documentData?["likedBy"] as? [String]
        else {
          completion([])
          return
        }

        currentUserLikes = likes
        currentUserLikedBy = likedBy
      }

      group.enter()
      self.database.collection("WGOfferer").getDocuments { documentSnapshots, error in
        defer {
          group.leave()
        }

        guard let documentSnapshots = documentSnapshots, error == nil else {
          completion([])
          return
        }

        for documentSnapshot in documentSnapshots.documents {
          let documentData = documentSnapshot.data()

          guard let address = documentData["address"] as? String,
                let contactInfo = documentData["contactInfo"] as? String,
                let idealRoommate = documentData["idealRoommate"] as? String,
                let imageString = documentData["imageString"] as? String,
                let name = documentData["name"] as? String,
                let wgDescription = documentData["wgDescription"] as? String,
                let wgPrice = documentData["wgPrice"] as? String,
                let wgSize = documentData["wgSize"] as? String
          else {
            continue
          }

          let wgOfferer = WGOfferer(
            address: address,
            contactInfo: contactInfo,
            id: documentSnapshot.documentID,
            idealRoommate: idealRoommate,
            imageString: imageString,
            name: name,
            wgDescription: wgDescription,
            wgPrice: wgPrice,
            wgSize: wgSize
          )

          wgOffererArray.append(wgOfferer)
        }
      }

      group.notify(queue: .main) {
        wgOffererArray = wgOffererArray.filter { matches.contains($0.id) }
        completion(wgOffererArray)
      }
    }
  }

  func getWGSearcherMatches(completion: @escaping ([WGSearcher]) -> Void) {
    var wgSearcherArray: [WGSearcher] = []

    if let currentUserID = Auth.auth().currentUser?.uid {
      var currentUserLikes: [String] = []
      var currentUserLikedBy: [String] = []
      var matches: [String] {
        currentUserLikes.filter { currentUserLikedBy.contains($0) }
      }

      let group = DispatchGroup()

      group.enter()
      self.database.collection("Swipes").document(currentUserID).getDocument { documentSnapshot, error in
        defer {
          group.leave()
        }

        guard let documentSnapshot = documentSnapshot, error == nil else {
          completion([])
          return
        }

        let documentData = documentSnapshot.data()

        guard let likes = documentData?["liked"] as? [String],
              let likedBy = documentData?["likedBy"] as? [String]
        else {
          completion([])
          return
        }

        currentUserLikes = likes
        currentUserLikedBy = likedBy
      }

      group.enter()
      self.database.collection("WGSearcher").getDocuments { documentSnapshots, error in
        defer {
          group.leave()
        }

        guard let documentSnapshots = documentSnapshots, error == nil else {
          completion([])
          return
        }

        for documentSnapshot in documentSnapshots.documents {
          let documentData = documentSnapshot.data()

          guard let age = documentData["age"] as? String,
                let contactInfo = documentData["contactInfo"] as? String,
                let gender = documentData["gender"] as? String,
                let hobbies = documentData["hobbies"] as? String,
                let imageString = documentData["imageString"] as? String,
                let name = documentData["name"] as? String,
                let ownDescription = documentData["ownDescription"] as? String
          else {
            continue
          }

          let wgSearcher = WGSearcher(
            age: age,
            contactInfo: contactInfo,
            gender: gender,
            hobbies: hobbies,
            id: documentSnapshot.documentID,
            imageString: imageString,
            name: name,
            ownDescription: ownDescription
          )

          wgSearcherArray.append(wgSearcher)
        }
      }

      group.notify(queue: .main) {
        wgSearcherArray = wgSearcherArray.filter { matches.contains($0.id) }
        completion(wgSearcherArray)
      }
    }
  }
}

// swiftlint: enable function_body_length
