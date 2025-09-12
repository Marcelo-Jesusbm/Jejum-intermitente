//
//  HealthStoreManaging.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 12/09/25.
//

import Foundation
import HealthKit

public protocol HealthStoreManaging {
    var isAvailable: Bool { get }
    func requestAuthorizationIfNeeded(completion: @escaping (Bool) -> Void)
    func saveFastingSession(sessionId: UUID, start: Date, end: Date, planName: String, planEmoji: String, completion: ((Bool) -> Void)?)
    func deleteFastingSession(sessionId: UUID, completion: ((Bool) -> Void)?)
    func upsertFastingSession(sessionId: UUID, start: Date, end: Date, planName: String, planEmoji: String, completion: ((Bool) -> Void)?)
}

public final class HealthKitService: HealthStoreManaging {
    private let healthStore = HKHealthStore()
    private let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession)!

    // Metadados para localizar amostras por sessão
    private let metaSessionId = "fasting.sessionId"
    private let metaPlanName = "fasting.planName"
    private let metaPlanEmoji = "fasting.planEmoji"

    public init() {}

    public var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    public func requestAuthorizationIfNeeded(completion: @escaping (Bool) -> Void) {
        guard isAvailable else { completion(false); return }
        let toShare: Set = [mindfulType]
        let toRead: Set = [mindfulType]
        healthStore.requestAuthorization(toShare: toShare, read: toRead) { granted, _ in
            completion(granted)
        }
    }

    public func saveFastingSession(sessionId: UUID, start: Date, end: Date, planName: String, planEmoji: String, completion: ((Bool) -> Void)? = nil) {
        guard isAvailable else { completion?(false); return }
        let metadata: [String: Any] = [
            metaSessionId: sessionId.uuidString,
            metaPlanName: planName,
            metaPlanEmoji: planEmoji
        ]
        // mindfulSession usa HKCategorySample com value = HKCategoryValue.notApplicable
        let sample = HKCategorySample(type: mindfulType, value: HKCategoryValue.notApplicable.rawValue, start: start, end: end, metadata: metadata)
        healthStore.save(sample) { success, _ in
            completion?(success)
        }
    }

    public func deleteFastingSession(sessionId: UUID, completion: ((Bool) -> Void)? = nil) {
        guard isAvailable else { completion?(false); return }
        fetchSamples(sessionId: sessionId) { [weak self] samples in
            guard let self else { completion?(false); return }
            guard let samples, !samples.isEmpty else { completion?(true); return }
            self.healthStore.delete(samples) { success, _ in
                completion?(success)
            }
        }
    }

    public func upsertFastingSession(sessionId: UUID, start: Date, end: Date, planName: String, planEmoji: String, completion: ((Bool) -> Void)? = nil) {
        // Estratégia simples: deleta amostras existentes dessa sessão e salva uma nova
        deleteFastingSession(sessionId: sessionId) { [weak self] _ in
            self?.saveFastingSession(sessionId: sessionId, start: start, end: end, planName: planName, planEmoji: planEmoji, completion: completion)
        }
    }

    // MARK: - Query helpers

    private func fetchSamples(sessionId: UUID, completion: @escaping ([HKSample]?) -> Void) {
        let predicate = NSPredicate(format: "metadata.%K == %@", metaSessionId, sessionId.uuidString)
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: mindfulType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sort]) { _, samples, _ in
            completion(samples)
        }
        healthStore.execute(query)
    }
}
