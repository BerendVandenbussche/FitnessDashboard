//
//  BatteryMonitoring.swift
//  FitnessDashboard WatchKit Extension
//
//  Created by Berend Vandenbussche on 07/01/2021.
//

import WatchKit

class BatteryMonitoring: NSObject {
    public static let BatteryDidChangeNotification = Notification.Name(rawValue: "BatteryStateNotifier.BatteryDidChangeNotification")
    
    public static let shared = BatteryMonitoring()
    
    public private(set) var state : WKInterfaceDeviceBatteryState = .unknown
    public private(set) var level: Int = -1
    
    private var timer : Timer?
    public var isStarted: Bool {get{return timer != nil && timer!.isValid}}
    
    public func start(withPeriod period : TimeInterval){
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: period, target: self, selector : #selector(self.verifyAndNotifyOfChange), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    public func stop(){
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func verifyAndNotifyOfChange(){
        let (newState, newLevel) = getBatteryInfo()
        
        if newState != state || newLevel != level{
            state = newState
            level = newLevel
            NotificationCenter.default.post(Notification(name: BatteryMonitoring.BatteryDidChangeNotification, object: (state, level), userInfo: nil))
        }
    }
    
    public func getBatteryInfo(forDevice device: WKInterfaceDevice = WKInterfaceDevice.current()) -> (WKInterfaceDeviceBatteryState, Int){
    let originalMonitoringValue = device.isBatteryMonitoringEnabled
    defer{
    device.isBatteryMonitoringEnabled = originalMonitoringValue
    }
    device.isBatteryMonitoringEnabled = true
    return (device.batteryState, Int(100.0 * device.batteryLevel))
    }
    

}
