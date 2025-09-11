//
//  CoreDataModel.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation
import CoreData

enum CoreDataModel {
    static let fastingSessionEntityName = "FastingSessionEntity"
    static let planPreferenceEntityName = "PlanPreferenceEntity"

    static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        model.entities = [
            makeFastingSessionEntity(),
            makePlanPreferenceEntity()
        ]
        return model
    }

    private static func makeFastingSessionEntity() -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = fastingSessionEntityName
        entity.managedObjectClassName = NSStringFromClass(FastingSessionEntity.self)

        let id = NSAttributeDescription()
        id.name = "id"
        id.attributeType = .UUIDAttributeType
        id.isOptional = false

        let planId = NSAttributeDescription()
        planId.name = "planId"
        planId.attributeType = .stringAttributeType
        planId.isOptional = false

        let planName = NSAttributeDescription()
        planName.name = "planName"
        planName.attributeType = .stringAttributeType
        planName.isOptional = false

        let planEmoji = NSAttributeDescription()
        planEmoji.name = "planEmoji"
        planEmoji.attributeType = .stringAttributeType
        planEmoji.isOptional = false

        let goalDuration = NSAttributeDescription()
        goalDuration.name = "goalDuration"
        goalDuration.attributeType = .doubleAttributeType
        goalDuration.isOptional = false

        let startDate = NSAttributeDescription()
        startDate.name = "startDate"
        startDate.attributeType = .dateAttributeType
        startDate.isOptional = false

        let endDate = NSAttributeDescription()
        endDate.name = "endDate"
        endDate.attributeType = .dateAttributeType
        endDate.isOptional = true

        entity.properties = [id, planId, planName, planEmoji, goalDuration, startDate, endDate]
        entity.uniquenessConstraints = [["id"]]
        return entity
    }

    private static func makePlanPreferenceEntity() -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = planPreferenceEntityName
        entity.managedObjectClassName = NSStringFromClass(PlanPreferenceEntity.self)

        let key = NSAttributeDescription()
        key.name = "key"
        key.attributeType = .stringAttributeType
        key.isOptional = false

        let defaultPlanId = NSAttributeDescription()
        defaultPlanId.name = "defaultPlanId"
        defaultPlanId.attributeType = .stringAttributeType
        defaultPlanId.isOptional = false

        entity.properties = [key, defaultPlanId]
        entity.uniquenessConstraints = [["key"]]
        return entity
    }
}
