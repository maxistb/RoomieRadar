//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import SwiftUI

struct WGOfferer: Hashable, WGListEntry {
  var address: String
  var contactInfo: String
  var id: String
  var idealRoommate: String
  var imageString: String
  var name: String
  var ownDescription: String
  var wgPrice: String
  var wgSize: String

  public static var shared = WGOfferer(
    address: "",
    contactInfo: "",
    id: "",
    idealRoommate: "",
    imageString: "",
    name: "",
    ownDescription: "",
    wgPrice: "",
    wgSize: ""
  )

  public func updateFirestoreWGOfferer(docRef: DocumentReference) {
    let docData: [String: Any] = [
      "address": WGOfferer.shared.address,
      "contactInfo": WGOfferer.shared.contactInfo,
      "idealRoommate": WGOfferer.shared.idealRoommate,
      "imageString": WGOfferer.shared.imageString,
      "name": WGOfferer.shared.name,
      "wgDescription": WGOfferer.shared.ownDescription,
      "wgPrice": WGOfferer.shared.wgPrice,
      "wgSize": WGOfferer.shared.wgSize
    ]

    docRef.setData(docData)
  }

  public func updateLocalDataWithFirestore(database: Firestore, user: User) {
    let docRef = database.collection("WGOfferer").document(user.uid)
    docRef.getDocument(completion: { document, error in
      guard error == nil else { return }

      if let document = document, document.exists {
        let data = document.data() as? [String: String]
        WGOfferer.shared.address = data?["address"] ?? "Error"
        WGOfferer.shared.contactInfo = data?["contactInfo"] ?? "Error"
        WGOfferer.shared.idealRoommate = data?["idealRoommate"] ?? "Error"
        WGOfferer.shared.imageString = data?["imageString"] ?? "Error"
        WGOfferer.shared.name = data?["name"] ?? "Error"
        WGOfferer.shared.ownDescription = data?["wgDescription"] ?? "Error"
        WGOfferer.shared.wgPrice = data?["wgPrice"] ?? "Error"
        WGOfferer.shared.wgSize = data?["wgSize"] ?? "Error"
        WGOfferer.shared.id = user.uid
      }
    })
  }

  public func createMockDataInFirebase() {
    let mockUser1 = WGOfferer(
      address: "123 Main St",
      contactInfo: "john.doe@example.com",
      id: "1",
      idealRoommate: "Friendly and tidy",
      imageString: "https://picsum.photos/400/225?random=1",
      name: "John Doe",
      ownDescription: "Spacious apartment with a great view",
      wgPrice: "$1200/month",
      wgSize: "3 bedrooms"
    )

    let mockUser2 = WGOfferer(
      address: "456 Oak Ave",
      contactInfo: "jane.smith@example.com",
      id: "2",
      idealRoommate: "Quiet and respectful",
      imageString: "https://picsum.photos/400/225?random=2",
      name: "Jane Smith",
      ownDescription: "Cozy studio with modern amenities",
      wgPrice: "$800/month",
      wgSize: "1 bedroom"
    )

    let mockUser3 = WGOfferer(
      address: "789 Elm St",
      contactInfo: "bob.jenkins@example.com",
      id: "3",
      idealRoommate: "Loves pets and enjoys cooking",
      imageString: "https://picsum.photos/400/225?random=3",
      name: "Bob Jenkins",
      ownDescription: "Townhouse with a backyard",
      wgPrice: "$1500/month",
      wgSize: "2 bedrooms"
    )

    let mockUser4 = WGOfferer(
      address: "101 Pine Rd",
      contactInfo: "susan.white@example.com",
      id: "4",
      idealRoommate: "Artistic and laid-back",
      imageString: "https://picsum.photos/400/225?random=4",
      name: "Susan White",
      ownDescription: "Loft-style apartment with exposed brick",
      wgPrice: "$1800/month",
      wgSize: "4 bedrooms"
    )

    let mockUser5 = WGOfferer(
      address: "202 Cedar Ln",
      contactInfo: "michael.green@example.com",
      id: "5",
      idealRoommate: "Sports enthusiast and social",
      imageString: "https://picsum.photos/400/225?random=5",
      name: "Michael Green",
      ownDescription: "High-rise living with gym and pool",
      wgPrice: "$2000/month",
      wgSize: "2 bedrooms"
    )

    let mockUserArray = [mockUser1, mockUser2, mockUser3, mockUser4, mockUser5]

    for mockUser in mockUserArray {
      let docRef = Firestore.firestore().collection("WGOfferer").document(mockUser.id)

      let docData: [String: Any] = [
        "address": mockUser.address,
        "contactInfo": mockUser.contactInfo,
        "idealRoommate": mockUser.idealRoommate,
        "imageString": mockUser.imageString,
        "name": mockUser.name,
        "wgDescription": mockUser.ownDescription,
        "wgPrice": mockUser.wgPrice,
        "wgSize": mockUser.wgSize
      ]

      docRef.setData(docData)
    }
  }
}
