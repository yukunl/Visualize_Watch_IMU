
import Foundation
import HealthKit
import CoreMotion
import SocketIO


class WorkoutManager: NSObject, ObservableObject {
    

    @Published private(set) var secondElapsed = 0.0
    @Published var count = 0
    
    
    // timer
    
    var timer = Timer()
    
    static func == (lhs: WorkoutManager, rhs: WorkoutManager) -> Bool {
        return lhs.secondElapsed == rhs.secondElapsed
    }
    
    // IMU
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    let sampleInterval = 0.02
    
    @Published private(set) var pitch = Double.zero
    @Published private(set) var yaw = Double.zero
    @Published private(set) var roll = Double.zero
    
    @Published private(set) var accX = Double.zero
    @Published private(set) var accY = Double.zero
    @Published private(set) var accZ = Double.zero
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    var manager = SocketManager(socketURL: URL(string: "ws://" + API.publicIP + ":" + API.portNumber)!, config: [.log(true), .compress])
    
    
    @Published  var socket : SocketIOClient
    
    override init(){
        socket = manager.defaultSocket
        
    }
    
    
    func switchStartEnd(){
        if(count % 2 != 0){
            self.socket.on(clientEvent: .connect) {(data, ack) in
               print("apple watch Connected")
                self.socket.emit("pythonPort", ["message" : "begin"])
                        }
            self.socket.connect()
            
            startWorkout()
            timer = Timer.scheduledTimer( withTimeInterval: 0.02, repeats: true){
                timer in self.secondElapsed += 0.02 }
            
            // coremotion
            self.motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
                          guard let data = data else {
                              print("Error: \(error!)")
                              return
                          }
                          let attitude: CMAttitude = data.attitude
                          let acceleration: CMAcceleration = data.userAcceleration
                          
                          DispatchQueue.main.async {
                              self.pitch = attitude.pitch
                              self.yaw = attitude.yaw
                              self.roll = attitude.roll
                              self.accX = acceleration.x
                              self.accY = acceleration.y
                              self.accZ = acceleration.z
                          }
                      }
                  self.motionManager.deviceMotionUpdateInterval = sampleInterval
                  
        }
        else{
            self.socket.disconnect()
            timer.invalidate()
            secondElapsed = 0.0
            
            pitch = Double.zero
            yaw = Double.zero
            roll = Double.zero
            accX = Double.zero
            accY = Double.zero
            accZ = Double.zero
        }
        
        count += 1
        
    }
    // Start the workout.
    func startWorkout() {
        
        
        
//        socket.on(clientEvent: .connect) {(data, ack) in
//            print("apple watch Connected")
//            self.socket.emit("NodeJS Server Port", ["message" : "begin"])
//        }
//        self.socket.connect()
//        self.socket.emit("NodeJS Server Port", ["time" : Double(round(10*newValue)/10)])
        
        
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running
        configuration.locationType = .outdoor

        // Create the session and obtain the workout builder.
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            // Handle any exceptions.
            return
        }

        // Setup session and builder.
        session?.delegate = self
        builder?.delegate = self

        // Set the workout builder's data source.
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                     workoutConfiguration: configuration)

        // Start the workout session and begin data collection.
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            // The workout has started.
        }
    }

    // Request authorization to access HealthKit.
    func requestAuthorization() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]

        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
//            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
//            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
//            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
//            HKQuantityType.quantityType(forIdentifier:.)!,
            HKObjectType.activitySummaryType()
        ]

        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
        }
    }

    // MARK: - Session State Control

    // The app's workout state.
    @Published var running = false

    func togglePause() {
        if running == true {
            self.pause()
        } else {
            resume()
        }
    }

    func pause() {
        session?.pause()
    }

    func resume() {
        session?.resume()
    }

    func endWorkout() {
        session?.end()
    }

    // MARK: - Workout Metrics
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    @Published var workout: HKWorkout?

    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }

        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning), HKQuantityType.quantityType(forIdentifier: .distanceCycling):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            default:
                return
            }
        }
    }

    func resetWorkout() {
        builder = nil
        workout = nil
        session = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
    }
}

// MARK: - HKWorkoutSessionDelegate
extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            self.running = toState == .running
        }

        // Wait for the session to transition states before ending the builder.
        if toState == .ended {
            builder?.endCollection(withEnd: date) { (success, error) in
                self.builder?.finishWorkout { (workout, error) in
                    DispatchQueue.main.async {
                        self.workout = workout
                    }
                }
            }
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {

    }
}

// MARK: - HKLiveWorkoutBuilderDelegate
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {

    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return // Nothing to do.
            }

            let statistics = workoutBuilder.statistics(for: quantityType)

            // Update the published values.
            updateForStatistics(statistics)
        }
    }
}
