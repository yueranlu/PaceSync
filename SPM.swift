

import CoreMotion
import Foundation
import Combine

/*
Structure
 
 1. first need to define class as observable object to be able to use in ui
    - declare vairbale such as pedometer, timer, and three minute timer
    - declare varibales that are going to be available in the view
    - need variable to see steps counted as well as time passes to calculate spm
 
 2. first function starts stracking
    - it uses CMPedometer to see if available then it will start updating using .startUpdates from the class CMPedometer and from Date() from Foundation
    - then we use a closure that follows this call, and updates everytime .startupdates starts
        - use weak self
 
 3. function that actually does the SPM and stores in variables
 
 4. function that refreshed the UI to update it
 
 // to connect to view we need to create an instance of this class and store it in a variable, then we to call it we use theinstance and do instance.startTracking(), or instance.stopTracking()
 */

class StepTracker: ObservableObject {
    // aribale to aces the pedometer
    private var pedometer = CMPedometer()
    
    // variables that are (activatedthen removed at each cycle)
    
    private var timer: Timer?
    private var threeMinuteTimer: Timer?
    
    // variables that are updates in the view
    @Published var currentSPM: Double = 0
    @Published var internalSPM: Double = 0
    
    // variable to store pace every 10s (may use later for displaying)
    @Published var SPMHistory: [Double] = []
    
    // tracks how many steps you have when you start tracking
    private var stepCountStart: Int = 0
    // stores the time when tracking started
    private var startTime: Date?
    
    // init runs whenevr an instance of this is created
    init(){
        startTracking()
    }
    
    func startTracking(){
        if CMPedometer.isStepCountingAvailable(){
            // chat gpt ily (no clue what this does)
            pedometer.startUpdates(from: Date()){
                [weak self] data, error in guard let self = self, let data = data, error == nil else {
                    return}
                
                DispatchQueue.main.async{
                    self.updateStepsPerMinute(with: data)
                }
            }
            // start the time and step counting
            startTime = Date()
            stepCountStart = 0
            
            // now we want it to start tracking
            
            // 1. update every 10s for the ui
            // track using the timer and a closure to repeat every 10s
            
            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true){ [weak self] _ in
                // this refreshes the UI for the variable current SPM
                guard let self = self else {return}
                
                self.sendSPMtoUI()
                // saves pave every 10s in a list
                self.SPMHistory.append(self.currentSPM)
            }
            // 2. update every 3 minutes for internal use when switching songs
            threeMinuteTimer = Timer.scheduledTimer(withTimeInterval:180, repeats: true){ [weak self] _ in
                guard let self = self else {return}
                self.internalSPM = self.currentSPM
                
            }
        }
    }
        // function to calcuate steps per minute as often as possible
        private func updateStepsPerMinute(with data: CMPedometerData){
            if startTime == nil{
                startTime = data.startDate
            }
            // need to calucte steps per minute
            
            // ! is for force unwrapping, since we delcared it as optiona eailier we need to unwrap to tell swift we are sure it has a value, other ways too but not used here (let x = x)
            let elapsedTime = Date().timeIntervalSince(startTime!)
            let stepsNum = data.numberOfSteps.intValue
            let minutes = elapsedTime/60.0
            // ternary operator to update steps
            currentSPM = minutes > 0 ? Double(stepsNum) / minutes : 0
        }
        
        // function to update ui for the every 10s
        private func sendSPMtoUI(){
            objectWillChange.send()
        }
        
    func stopTracking(){
        timer?.invalidate()
        threeMinuteTimer?.invalidate()
        pedometer.stopUpdates()
        
        timer = nil
        threeMinuteTimer = nil
        startTime = nil
        
    }
    
    deinit{
        stopTracking()
    }
}

