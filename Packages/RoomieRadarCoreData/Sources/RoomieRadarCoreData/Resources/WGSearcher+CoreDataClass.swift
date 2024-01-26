//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//
//

import CoreData
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
}

extension WGSearcher: Identifiable {}
