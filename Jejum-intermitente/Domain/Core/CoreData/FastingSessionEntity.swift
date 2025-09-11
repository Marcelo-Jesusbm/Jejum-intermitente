//
//  FastingSessionEntity.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation
import CoreData

@objc(FastingSessionEntity)
class FastingSessionEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var planId: String
    @NSManaged var planName: String
    @NSManaged var planEmoji: String
    @NSManaged var goalDuration: Double
    @NSManaged var startDate: Date
    @NSManaged var endDate: Date?
}

extension FastingSessionEntity {
    @nonobjc class func fetchRequest() -> NSFetchRequest<FastingSessionEntity> {
        NSFetchRequest<FastingSessionEntity>(entityName: CoreDataModel.fastingSessionEntityName)
    }
}
