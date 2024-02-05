//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//
// swiftlint:disable opening_brace

import FirebaseAuth
import FirebaseFirestore
import Foundation
import Styleguide

@MainActor
final class SwipingScreenViewModel: ObservableObject {
  enum ViewState {
    case loading
    case success
    case error
  }

  @Published var wgOffererArray: [WGOfferer] = []
  @Published var wgSearcherArray: [WGSearcher] = []
  @Published var viewState: ViewState = .loading
  private let database = Firestore.firestore()
  private let currentUserID = Auth.auth().currentUser?.uid

  func getAllWGOfferer() async throws {
    do {
      let querySnapshot = try await self.database.collection("WGOfferer").getDocuments()
      for documentSnapshot in querySnapshot.documents {
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
          self.viewState = .error
          return
        }

        let wgOfferer = WGOfferer(
          address: address,
          contactInfo: contactInfo,
          id: documentSnapshot.documentID,
          idealRoommate: idealRoommate,
          imageString: imageString,
          name: name,
          ownDescription: wgDescription,
          wgPrice: wgPrice,
          wgSize: wgSize
        )

        self.wgOffererArray.append(wgOfferer)
      }

      if let currentUserID = currentUserID {
        let document = try await self.database.collection("Swipes").document(currentUserID).getDocument()
        let documentData = document.data()

        if let disliked = documentData?["disliked"] as? [String],
           let liked = documentData?["liked"] as? [String]
        {
          self.wgOffererArray = self.wgOffererArray.filter { !disliked.contains($0.id) && !liked.contains($0.id) }
          self.viewState = .success
        } else {
          self.viewState = .error
          return
        }
      }
    } catch {
      self.viewState = .error
      return
    }
  }

  func getAllWGSearcher() async throws {
    do {
      let querySnapshot = try await self.database.collection("WGSearcher").getDocuments()

      for documentSnapshot in querySnapshot.documents {
        let documentData = documentSnapshot.data()

        guard let age = documentData["age"] as? String,
              let contactInfo = documentData["contactInfo"] as? String,
              let gender = documentData["gender"] as? String,
              let hobbies = documentData["hobbies"] as? String,
              let imageString = documentData["imageString"] as? String,
              let name = documentData["name"] as? String,
              let ownDescription = documentData["ownDescription"] as? String
        else {
          self.viewState = .error
          return
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

      if let currentUserID = currentUserID {
        let document = try await self.database.collection("Swipes").document(currentUserID).getDocument()

        let documentData = document.data()

        if let disliked = documentData?["disliked"] as? [String],
           let liked = documentData?["liked"] as? [String]
        {
          self.wgSearcherArray = self.wgSearcherArray.filter { !disliked.contains($0.id) && !liked.contains($0.id) }
          self.viewState = .success

        } else {
          self.viewState = .error
          return
        }
      }
    } catch {
      self.viewState = .error
      return
    }
  }
}

// swiftlint:enable opening_brace
