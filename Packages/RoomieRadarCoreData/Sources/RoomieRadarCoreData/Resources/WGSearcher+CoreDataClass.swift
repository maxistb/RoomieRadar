//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//
//

import CoreData
import FirebaseAuth
import FirebaseFirestore
import Foundation

@objc(WGSearcher)
public class WGSearcher: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<WGSearcher> {
    return NSFetchRequest<WGSearcher>(entityName: "WGSearcher")
  }

  @NSManaged public var age: String
  @NSManaged public var contactInfo: String
  @NSManaged public var gender: String
  @NSManaged public var hobbies: String
  @NSManaged public var id: String
  @NSManaged public var imageString: String
  @NSManaged public var name: String
  @NSManaged public var ownDescription: String

  public class func createWGSearcher(uid: String) -> WGSearcher {
    let newWGSearcher = WGSearcher(context: CoreDataStack.shared.mainContext)
    newWGSearcher.age = ""
    newWGSearcher.contactInfo = ""
    newWGSearcher.gender = ""
    newWGSearcher.hobbies = ""
    newWGSearcher.id = uid
    newWGSearcher.imageString = ""
    newWGSearcher.name = ""
    newWGSearcher.ownDescription = ""

    try? CoreDataStack.shared.mainContext.save()
    return newWGSearcher
  }

  public class func updateFirestoreWGOfferer(docRef: DocumentReference, wgSearcher: WGSearcher) {
    let docData: [String: Any] = [
      "age": wgSearcher.age,
      "contactInfo": wgSearcher.contactInfo,
      "gender": wgSearcher.gender,
      "hobbies": wgSearcher.hobbies,
      "imageString": wgSearcher.imageString,
      "name": wgSearcher.name,
      "ownDescription": wgSearcher.ownDescription
    ]

    docRef.setData(docData)
  }

  public class func updateLocalDataWithFirestore(database: Firestore, user: User) {
    let docRef = database.collection("WGSearcher").document(user.uid)
    docRef.getDocument(completion: { document, error in
      guard error == nil else { return }

      if let document = document, document.exists {
        let data = document.data()
        print(data)
      }
    })
  }
}

extension WGSearcher: Identifiable {}
