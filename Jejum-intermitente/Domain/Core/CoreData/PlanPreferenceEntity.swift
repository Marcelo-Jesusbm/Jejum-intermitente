//
//  PlanPreferenceEntity.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation
import CoreData

@objc(PlanPreferenceEntity)
class PlanPreferenceEntity: NSManagedObject {
    @NSManaged var key: String
    @NSManaged var defaultPlanId: String
}

extension PlanPreferenceEntity {
    @nonobjc class func fetchRequest() -> NSFetchRequest<PlanPreferenceEntity> {
        NSFetchRequest<PlanPreferenceEntity>(entityName: CoreDataModel.planPreferenceEntityName)
    }
}
