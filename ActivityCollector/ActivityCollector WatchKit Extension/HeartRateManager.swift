//
//  HeartRateManager.swift
//  ActivityCollector WatchKit Extension
//
//  Created by Yukun Li on 4/11/22.
//

import Foundation
import HealthKit

class HeartRateManager:ObservableObject{
    
    private var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    @Published var count = 0
    @Published private(set) var value = 0
    
    
    func start(){
        autorizeHealthKit()
    }
    
    func heartRateSwitchStartEnd() {
        if(count%2 == 0){
            value = 0
        }else{
            startHeartRateQuery(quantityTypeIdentifier: .heartRate)
        }
        count = count + 1;
    }
    
    func autorizeHealthKit() {
        let healthKitTypes: Set = [
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
    }
    
    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
                query, samples, deletedObjects, queryAnchor, error in

                guard let samples = samples as? [HKQuantitySample] else {
                    return
                }
            
                self.process(samples, type: quantityTypeIdentifier)

                }
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        query.updateHandler = updateHandler
        
        healthStore.execute(query)
    }
    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        var lastHeartRate = 0.0
        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
            }
            self.value = Int(lastHeartRate)
        }
    }

}
