//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//
// swiftlint:disable opening_brace

import FirebaseAuth
import FirebaseFirestore
import Foundation
import Styleguide

final class SwipingScreenViewModel: ObservableObject {
  @Published var wgOffererArray: [WGOfferer] = []
  @Published var wgSearcherArray: [WGSearcher] = []
  private let database = Firestore.firestore()

  func getAllWGOfferer() {
    self.database.collection("WGOfferer").getDocuments { wgSnapshot, wgError in
      guard let wgSnapshot = wgSnapshot, wgError == nil else {
        return
      }

      for documentSnapshot in wgSnapshot.documents {
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

        self.wgOffererArray.append(wgOfferer)
      }

      if let currentUserID = Auth.auth().currentUser?.uid {
        self.database.collection("Swipes").document(currentUserID).getDocument { swipeSnapshot, swipeError in
          guard let swipeSnapshot = swipeSnapshot, swipeError == nil else {
            return
          }
          let documentData = swipeSnapshot.data()

          if let disliked = documentData?["disliked"] as? [String],
             let liked = documentData?["liked"] as? [String]
          {
            self.wgOffererArray = self.wgOffererArray.filter { !disliked.contains($0.id) && !liked.contains($0.id) }
          } else {}
        }
      }
    }
  }

  func getAllWGSearcher() {
    self.database.collection("WGSearcher").getDocuments { wgSnapshot, wgError in
      guard let wgSnapshot = wgSnapshot, wgError == nil else {
        return
      }

      for documentSnapshot in wgSnapshot.documents {
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

        self.wgSearcherArray.append(wgSearcher)
      }

      if let currentUserID = Auth.auth().currentUser?.uid {
        self.database.collection("Swipes").document(currentUserID).getDocument { swipeSnapshot, swipeError in
          guard let swipeSnapshot = swipeSnapshot, swipeError == nil else {
            return
          }

          let documentData = swipeSnapshot.data()

          if let disliked = documentData?["disliked"] as? [String],
             let liked = documentData?["liked"] as? [String]
          {
            print("INITIAL: \(self.wgSearcherArray)")
            print("DISLIKED: \(disliked)")
            print("LIKED: \(liked)")
            self.wgSearcherArray = self.wgSearcherArray.filter { !disliked.contains($0.id) && !liked.contains($0.id) }
            print("FILTERED: \(self.wgSearcherArray)")

          } else {}
        }
      }
    }
  }
}

// swiftlint:enable opening_brace
