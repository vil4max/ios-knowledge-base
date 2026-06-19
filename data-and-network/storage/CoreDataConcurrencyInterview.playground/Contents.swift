import CoreData
import Foundation

/*
 Q&A cards — Q33 (Core Data concurrency basics)

 Core Data concurrency:
 https://developer.apple.com/documentation/coredata/using_core_data_in_the_background

 Thesis: contexts are tied to a queue (main or private); do not pass `NSManagedObject` across threads;
 pass `NSManagedObjectID` and re-fetch in the destination context.
*/

print("NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType raw:",
      NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType.rawValue)
print("NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType raw:",
      NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType.rawValue)
