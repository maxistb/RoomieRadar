//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseFirestore
import SwiftUI

struct TestMainView: View {
  @State private var wgOffererArray: [WGOfferer] = []

  var body: some View {
    VStack {
      ZStack {
        ForEach(wgOffererArray, id: \.id) { wgOfferer in
          WGOffererCardView(wgOfferer: wgOfferer)
        }
      }
    }
    .onAppear {
      getAllWGOfferer()
    }
  }

  func getAllWGOfferer() {
    Firestore
      .firestore()
      .collection("WGOfferer")
      .getDocuments { snapshot, error in
        guard let snapshot = snapshot, error == nil else { return }

        snapshot.documents.forEach { documentSnapshot in
          let documentData = documentSnapshot.data()

          if let address = documentData["address"] as? String,
             let contactInfo = documentData["contactInfo"] as? String,
             let idealRoommate = documentData["idealRoommate"] as? String,
             let imageString = documentData["imageString"] as? String,
             let name = documentData["name"] as? String,
             let wgDescription = documentData["wgDescription"] as? String,
             let wgPrice = documentData["wgPrice"] as? String,
             let wgSize = documentData["wgSize"] as? String
          {
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
        }
      }
  }
}
