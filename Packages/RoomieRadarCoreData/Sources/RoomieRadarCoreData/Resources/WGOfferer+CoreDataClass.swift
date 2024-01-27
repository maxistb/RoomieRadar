//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//
// swiftlint: disable function_parameter_count

import CoreData
import FirebaseAuth
import FirebaseFirestore
import Foundation
import SwiftUI

@objc(WGOfferer)
public class WGOfferer: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<WGOfferer> {
    return NSFetchRequest<WGOfferer>(entityName: "WGOfferer")
  }

  @NSManaged public var address: String
  @NSManaged public var contactInfo: String
  @NSManaged public var id: String
  @NSManaged public var idealRoommate: String
  @NSManaged public var imageString: String
  @NSManaged public var name: String
  @NSManaged public var wgDescription: String
  @NSManaged public var wgPrice: String
  @NSManaged public var wgSize: String

  public class func createWGOfferer(uid: String) -> WGOfferer {
    let newWGOfferer = WGOfferer(context: CoreDataStack.shared.mainContext)
    newWGOfferer.address = ""
    newWGOfferer.contactInfo = ""
    newWGOfferer.id = uid
    newWGOfferer.idealRoommate = ""
    newWGOfferer.imageString = ""
    newWGOfferer.name = ""
    newWGOfferer.wgDescription = ""
    newWGOfferer.wgPrice = ""
    newWGOfferer.wgSize = ""

    try? CoreDataStack.shared.mainContext.save()
    return newWGOfferer
  }

  public class func createWGOfferer(
    address: String,
    contactInfo: String,
    id: String,
    idealRoommate: String,
    imageString: String,
    name: String,
    wgDescription: String,
    wgPrice: String,
    wgSize: String
  ) -> WGOfferer {
    let newWGOfferer = WGOfferer(context: CoreDataStack.shared.mainContext)
    newWGOfferer.address = address
    newWGOfferer.contactInfo = contactInfo
    newWGOfferer.id = id
    newWGOfferer.idealRoommate = idealRoommate
    newWGOfferer.imageString = imageString
    newWGOfferer.name = name
    newWGOfferer.wgDescription = wgDescription
    newWGOfferer.wgPrice = wgPrice
    newWGOfferer.wgSize = wgSize

    try? CoreDataStack.shared.mainContext.save()
    return newWGOfferer
  }

  public class func updateFirestoreWGOfferer(docRef: DocumentReference, newWGOfferer: WGOfferer) {
    let docData: [String: Any] = [
      "address": newWGOfferer.address,
      "contactInfo": newWGOfferer.contactInfo,
      "idealRoommate": newWGOfferer.idealRoommate,
      "imageString": newWGOfferer.imageString,
      "name": newWGOfferer.name,
      "wgDescription": newWGOfferer.wgDescription,
      "wgPrice": newWGOfferer.wgPrice,
      "wgSize": newWGOfferer.wgSize
    ]

    docRef.setData(docData)
  }

  public class func updateLocalDataWithFirestore(database: Firestore, user: User) {
    let localUser = FetchRequest<WGOfferer>(
      entity: WGOfferer.entity(),
      sortDescriptors: [],
      predicate: NSPredicate(format: "id == %@", user.uid)
    )

    if let wgOfferer = localUser.wrappedValue.first {
      let docRef = database.collection("WGOfferer").document(user.uid)
      docRef.getDocument(completion: { document, error in
        guard error == nil else { return }

        if let document = document, document.exists {
          let data = document.data() as? [String: String]
          wgOfferer.address = data?["address"] ?? ""
          wgOfferer.contactInfo = data?["contactInfo"] ?? ""
          wgOfferer.idealRoommate = data?["idealRoommate"] ?? ""
          wgOfferer.imageString = data?["imageString"] ?? ""
          wgOfferer.name = data?["name"] ?? ""
          wgOfferer.wgDescription = data?["wgDescription"] ?? ""
          wgOfferer.wgPrice = data?["wgPrice"] ?? ""
          wgOfferer.wgSize = data?["wgSize"] ?? ""
        }
      })
      try? CoreDataStack.shared.mainContext.save()
    } else {
      let docRef = database.collection("WGOfferer").document(user.uid)
      docRef.getDocument(completion: { document, error in
        guard error == nil else { print("DOCUMENT NOT FOUND"); return }

        if let document = document, document.exists {
          let data = document.data() as? [String: String]
          _ = createWGOfferer(
            address: data?["address"] ?? "",
            contactInfo: data?["contactInfo"] ?? "",
            id: user.uid,
            idealRoommate: data?["idealRoommate"] ?? "",
            imageString: data?["imageString"] ?? "",
            name: data?["name"] ?? "",
            wgDescription: data?["wgDescription"] ?? "",
            wgPrice: data?["wgPrice"] ?? "",
            wgSize: data?["wgSize"] ?? ""
          )

          try? CoreDataStack.shared.mainContext.save()
        }
      })
    }
  }
}

extension WGOfferer: Identifiable {}
