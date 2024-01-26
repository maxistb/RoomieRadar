//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//
//

import CoreData
import FirebaseFirestore
import Foundation

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
}

extension WGOfferer: Identifiable {}
