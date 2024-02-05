//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

public struct WGSearcher: Hashable {
  var age: String
  var contactInfo: String
  var gender: String
  var hobbies: String
  var id: String
  var imageString: String
  var name: String
  var ownDescription: String

  public static var shared = WGSearcher(
    age: "",
    contactInfo: "",
    gender: "",
    hobbies: "",
    id: "",
    imageString: "",
    name: "",
    ownDescription: ""
  )

  public func updateFirestoreWGOfferer(docRef: DocumentReference) {
    let docData: [String: Any] = [
      "age": WGSearcher.shared.age,
      "contactInfo": WGSearcher.shared.contactInfo,
      "gender": WGSearcher.shared.gender,
      "hobbies": WGSearcher.shared.hobbies,
      "imageString": WGSearcher.shared.imageString,
      "name": WGSearcher.shared.name,
      "ownDescription": WGSearcher.shared.ownDescription
    ]

    docRef.setData(docData)
  }

  public func updateLocalDataWithFirestore(database: Firestore, user: User) {
    let docRef = database.collection("WGSearcher").document(user.uid)
    docRef.getDocument(completion: { document, error in
      guard error == nil else { return }

      if let document = document, document.exists {
        let data = document.data() as? [String: String]
        WGSearcher.shared.age = data?["age"] ?? "Error"
        WGSearcher.shared.contactInfo = data?["contactInfo"] ?? "Error"
        WGSearcher.shared.gender = data?["gender"] ?? "Error"
        WGSearcher.shared.hobbies = data?["hobbies"] ?? "Error"
        WGSearcher.shared.imageString = data?["imageString"] ?? "Error"
        WGSearcher.shared.name = data?["name"] ?? "Error"
        WGSearcher.shared.ownDescription = data?["ownDescription"] ?? "Error"
        WGSearcher.shared.id = user.uid
      }
    })
  }

  public func createMockSearcherDataInFirebase() {
    let mockSearcher1 = WGSearcher(
      age: "25",
      contactInfo: "alice.smith@example.com",
      gender: "Female",
      hobbies: "Reading, hiking",
      id: "101",
      imageString: "https://picsum.photos/400/225?random=101",
      name: "Alice Smith",
      ownDescription: "Easy-going and adventurous"
    )

    let mockSearcher2 = WGSearcher(
      age: "30",
      contactInfo: "bob.jones@example.com",
      gender: "Male",
      hobbies: "Cooking, gaming",
      id: "102",
      imageString: "https://picsum.photos/400/225?random=102",
      name: "Bob Jones",
      ownDescription: "Food lover and gamer"
    )

    let mockSearcher3 = WGSearcher(
      age: "28",
      contactInfo: "carol.white@example.com",
      gender: "Female",
      hobbies: "Painting, yoga",
      id: "103",
      imageString: "https://picsum.photos/400/225?random=103",
      name: "Carol White",
      ownDescription: "Artistic and health-conscious"
    )

    let mockSearcher4 = WGSearcher(
      age: "22",
      contactInfo: "david.green@example.com",
      gender: "Male",
      hobbies: "Photography, coding",
      id: "104",
      imageString: "https://picsum.photos/400/225?random=104",
      name: "David Green",
      ownDescription: "Photographer and developer"
    )

    let mockSearcher5 = WGSearcher(
      age: "27",
      contactInfo: "emma.jones@example.com",
      gender: "Female",
      hobbies: "Traveling, music",
      id: "105",
      imageString: "https://picsum.photos/400/225?random=105",
      name: "Emma Jones",
      ownDescription: "Wanderlust and music enthusiast"
    )

    let mockSearcherArray = [mockSearcher1, mockSearcher2, mockSearcher3, mockSearcher4, mockSearcher5]

    for mockSearcher in mockSearcherArray {
      let docRef = Firestore.firestore().collection("WGSearcher").document(mockSearcher.id)

      let docData: [String: Any] = [
        "age": mockSearcher.age,
        "contactInfo": mockSearcher.contactInfo,
        "gender": mockSearcher.gender,
        "hobbies": mockSearcher.hobbies,
        "id": mockSearcher.id,
        "imageString": mockSearcher.imageString,
        "name": mockSearcher.name,
        "ownDescription": mockSearcher.ownDescription
      ]

      docRef.setData(docData)
    }
  }
}
