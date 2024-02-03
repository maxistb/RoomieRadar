//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class SwipingCardViewModel: ObservableObject {
  @Published var offset = CGSize.zero
  @Published var color: Color = .clear
  @Published var hasError = false
  @Published var errorMessage = ""

  func swipeCard(userID: String) {
    switch offset.width {
    case -500 ... -130:
      dislikeUser(dislikedUserID: userID)
      offset = CGSize(width: -500, height: 0)
    case 130 ... 500:
      likeUser(likedUserID: userID)
      offset = CGSize(width: 500, height: 0)
    default:
      offset = .zero
    }
  }

  func changeColor(width: CGFloat) {
    switch width {
    case -500 ... -130:
      color = .red
    case 130 ... 500:
      color = .green
    default:
      color = .clear
    }
  }

  func likeUser(likedUserID: String) {
    if let currentUserID = Auth.auth().currentUser?.uid {
      let likesDocument = Firestore.firestore().collection("Swipes")

      let likedUserDocument = likesDocument.document(likedUserID)
      let currentUserDocument = likesDocument.document(currentUserID)

      currentUserDocument.setData(["liked": FieldValue.arrayUnion([likedUserID])], merge: true) { error in
        if let error = error {
          self.hasError = true
          self.errorMessage = error.localizedDescription
        }
      }

      likedUserDocument.setData(["likedBy": FieldValue.arrayUnion([currentUserID])], merge: true) { error in
        if let error = error {
          self.hasError = true
          self.errorMessage = error.localizedDescription
        }
      }
    }
  }

  func dislikeUser(dislikedUserID: String) {
    if let currentUserID = Auth.auth().currentUser?.uid {
      let likesDocument = Firestore.firestore().collection("Swipes")

      let currentUserDocument = likesDocument.document(currentUserID)

      currentUserDocument.setData(["disliked": FieldValue.arrayUnion([dislikedUserID])], merge: true) { error in
        if let error = error {
          self.hasError = true
          self.errorMessage = error.localizedDescription
        }
      }
    }
  }
}
