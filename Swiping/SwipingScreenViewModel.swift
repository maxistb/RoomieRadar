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

  func getAllWGSearcher(completion: @escaping ([WGSearcher]?, Error?) -> Void) {
    var localWGSearcher: [WGSearcher] = []

    // Retrieve data from the "WGOfferer" collection
    self.database.collection("WGSearcher").getDocuments { wgSnapshot, wgError in
      guard let wgSnapshot = wgSnapshot, wgError == nil else {
        completion(nil, wgError)
        return
      }

      // Process data from "WGSearcher" collection
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
          continue // Skip to the next iteration if any required field is missing
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

        localWGSearcher.append(wgSearcher)
      }

      // Return the WGSearcher array through the completion handler
      completion(localWGSearcher, nil)
    }

    // Retrieve data from the "Swipes" collection based on the currentUser
    if let currentUserID = Auth.auth().currentUser?.uid {
      self.database.collection("Swipes").document(currentUserID).getDocument { swipeSnapshot, swipeError in
        guard let swipeSnapshot = swipeSnapshot, swipeError == nil else {
          completion(nil, swipeError)
          return
        }

        // Process data from "Swipes" collection
        let documentData = swipeSnapshot.data()

        if let disliked = documentData?["disliked"] as? [String],
           let liked = documentData?["liked"] as? [String]
        {
          // Filter out disliked and liked items
          print("DISLIKED: \(disliked)")
          print("LIKED: \(liked)")
          localWGSearcher = localWGSearcher.filter { !disliked.contains($0.id) && !liked.contains($0.id) }
          print("FILTERED: \(localWGSearcher)")

          // Return the filtered WGOfferer array
          completion(localWGSearcher, nil)
        } else {
          completion(nil, nil) // Handle case where "disliked" and "liked" arrays are not present
        }
      }
    }
  }
}

// swiftlint:enable opening_brace
