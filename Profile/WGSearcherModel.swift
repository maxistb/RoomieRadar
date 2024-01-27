//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

public struct WGSearcher {
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
}
