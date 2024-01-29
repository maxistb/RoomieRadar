//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

struct WGOfferer {
  var address: String
  var contactInfo: String
  var id: String
  var idealRoommate: String
  var imageString: String
  var name: String
  var wgDescription: String
  var wgPrice: String
  var wgSize: String

  public static var shared = WGOfferer(
    address: "Adress",
    contactInfo: "Meine E-Mail-Adresse:",
    id: "",
    idealRoommate: "Wir suchen nach einem neuen netten Mitbewohner. Er sollte Spaß am Trinken haben, selber aufräumen und organisiert sein.",
    imageString: "https://picsum.photos/id/1/200/300",
    name: "RoomieRadarWG",
    wgDescription: "Wir sind ein zusammengewürfelter Haufen. Wir akzeptieren alle Leute und trinken gerne mal Abends zusammen.",
    wgPrice: "430",
    wgSize: "12"
  )

  public func updateFirestoreWGOfferer(docRef: DocumentReference) {
    let docData: [String: Any] = [
      "address": WGOfferer.shared.address,
      "contactInfo": WGOfferer.shared.contactInfo,
      "idealRoommate": WGOfferer.shared.idealRoommate,
      "imageString": WGOfferer.shared.imageString,
      "name": WGOfferer.shared.name,
      "wgDescription": WGOfferer.shared.wgDescription,
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
        WGOfferer.shared.wgDescription = data?["wgDescription"] ?? "Error"
        WGOfferer.shared.wgPrice = data?["wgPrice"] ?? "Error"
        WGOfferer.shared.wgSize = data?["wgSize"] ?? "Error"
        WGOfferer.shared.id = user.uid
      }
    })
  }
}
