//
//  UIDeviceEx.swift
//  ExKit
//
//  Created by ZhouYuzhen on 2020/11/8.
//

import Foundation

public extension UIDevice {
    /// 系统启动时间
    var systemUptime: Date {
        let time = ProcessInfo.processInfo.systemUptime
        return Date(timeIntervalSinceNow: 0 - time)
    }
    
    /// 是否是Phone
    var isPhone: Bool {
        return userInterfaceIdiom == .phone
    }
    
    /// 是否是Pad
    var isPad: Bool {
        return userInterfaceIdiom == .pad
    }
    
    /// 是否是模拟器
    var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    /// 是否被越狱
    var isJailbroken: Bool {
        if isSimulator {
            return false
        }
        let paths = [
            "/Applications/Cydia.app",
            "/private/var/lib/apt/",
            "/private/var/lib/cydia",
            "/private/var/stash"
        ]
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        
        let bash = fopen("/bin/bash", "r")
        if bash != nil {
            fclose(bash)
            return true
        }
        
        let path = "/private/\(uuid)"
        do {
            try "test".write(toFile: path, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch _ {
            
        }
        return false
    }
    
    // 是否可以拨打电话
    var canMakeCalls: Bool {
        return UIApplication.shared.canOpenURL(URL(string: "tel://")!)
    }
    
    /// https://www.theiphonewiki.com/wiki/Models
    var machineModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
       
        let machine = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
        return machine
    }
    
    /// https://www.theiphonewiki.com/wiki/Models
    var machineModelName: String {
        let machine = self.machineModel;
        switch machine {
        // AppleTV
        case "AppleTV1,1":
            return "Apple TV (1st generation)"
        case "AppleTV2,1":
            return "Apple TV (2nd generation)"
        case "AppleTV3,1":
            return "Apple TV (3rd generation)"
        case "AppleTV5,3":
            return "Apple TV (4th generation)"
        case "AppleTV6,2":
            return "Apple TV 4K"
            
        // AppleWatch
        case "Watch1,1", "Watch1,2":
            return "Apple Watch (1st generation)"
            
        case "Watch2,3", "Watch2,4":
            return "Apple Watch Series 2"
        case "Watch2,6", "Watch2,7":
            return "Apple Watch Series 1"
        
        case "Watch3,1", "Watch3,2", "Watch3,3", "Watch3,4":
            return "Apple Watch Series 3"
            
        case "Watch4,1", "Watch4,2", "Watch4,3", "Watch4,4":
            return "Apple Watch Series 4"
            
        case "Watch5,1", "Watch5,2", "Watch5,3":
            return "Apple Watch Series 5"
        case "Watch5,9", "Watch5,10", "Watch5,11", "Watch5,12":
            return "Apple Watch SE"
            
        case "Watch6,1", "Watch6,2", "Watch6,3", "Watch6,4":
            return "Apple Watch Series 6"
            
        // iPad
        case "iPad1,1":
            return "iPad"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":
            return "iPad mini"
            
        case "iPad3,1", "iPad3,2", "iPad3,3":
            return "iPad (3rd generation)"
        case "iPad3,4", "iPad3,5", "iPad3,6":
            return "iPad (4th generation)"
            
        case "iPad4,1", "iPad4,2", "iPad4,3":
            return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":
            return "iPad mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":
            return "iPad mini 3"
            
        case "iPad5,1", "iPad5,2":
            return "iPad mini 4"
        case "iPad5,3", "iPad5,4":
            return "iPad Air 2"
        
        case "iPad6,11", "iPad6,12":
            return "iPad (5th generation)"
        case "iPad6,7", "iPad6,8":
            return "iPad Pro (12.9-inch)"
        case "iPad6,3", "iPad6,4":
            return "iPad Pro (9.7-inch)"
            
        case "iPad7,5", "iPad7,6":
            return "iPad (6th generation)"
        case "iPad7,11", "iPad7,12":
            return "iPad (7th generation)"
        case "iPad7,1", "iPad7,2":
            return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad7,3", "iPad7,4":
            return "iPad Pro (10.5-inch)"
            
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":
            return "iPad Pro (11-inch)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":
            return "iPad Pro (12.9-inch) (3rd generation)"
        case "iPad8,9", "iPad8,10":
            return "iPad Pro (11-inch) (2nd generation)"
        case "iPad8,11", "iPad8,12":
            return "iPad Pro (12.9-inch) (4th generation)"
            
        case "iPad11,1", "iPad11,2":
            return "iPad mini (5th generation)"
        case "iPad11,3", "iPad11,4":
            return "iPad Air (3rd generation)"
        case "iPad11,6", "iPad11,7":
            return "iPad (8th generation)"
            
        case "iPad13,1", "iPad13,2":
            return "iPad Air (4th generation)"
            
            
        // iPhone
        case "iPhone1,1":
            return "iPhone"
        case "iPhone1,2":
            return "iPhone 3G"
            
        case "iPhone2,1":
            return "iPhone 3GS"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":
            return "iPhone 4"
            
        case "iPhone4,1":
            return "iPhone 4S"
            
        case "iPhone5,1", "iPhone5,2":
            return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":
            return "iPhone 5c"
            
        case "iPhone6,1", "iPhone6,2":
            return "iPhone 5s"
            
        case "iPhone7,1":
            return "iPhone 6 Plus"
        case "iPhone7,2":
            return "iPhone 6"
            
        case "iPhone8,1":
            return "iPhone 6s"
        case "iPhone8,2":
            return "iPhone 6s Plus"
        case "iPhone8,4":
            return "iPhone SE (1st generation)"
            
        case "iPhone9,1", "iPhone9,3":
            return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":
            return "iPhone 7 Plus"
            
        case "iPhone10,1", "iPhone10,4":
            return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":
            return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":
            return "iPhone X"
        
        case "iPhone11,2":
            return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":
            return "iPhone XS Max"
        case "iPhone11,8":
            return "iPhone XR"
            
        case "iPhone12,1":
            return "iPhone 11"
        case "iPhone12,3":
            return "iPhone 11 Pro"
        case "iPhone12,5":
            return "iPhone 11 Pro Max"
        case "iPhone12,8":
            return "iPhone SE (2nd generation)"
        
        case "iPhone13,1":
            return "iPhone 12 mini"
        case "iPhone13,2":
            return "iPhone 12"
        case "iPhone13,3":
            return "iPhone 12 Pro"
        case "iPhone13,4":
            return "iPhone 12 Pro Max"
            
        // iPod
        case "iPod1,1":
            return "iPod touch"
        case "iPod2,1":
            return "iPod touch (2nd generation)"
        case "iPod3,1":
            return "iPod touch (3nd generation)"
        case "iPod4,1":
            return "iPod touch (4nd generation)"
        case "iPod5,1":
            return "iPod touch (5nd generation)"
        case "iPod7,1":
            return "iPod touch (6nd generation)"
        case "iPod9,1":
            return "iPod touch (7nd generation)"
            
        case "i386":
            return "Simulator x86"
        case "x86_64":
            return "Simulator x64"
        default:
            return ""
        }
    }
    
    /// UUID
    var uuid: String {
        let puuid = CFUUIDCreate(nil);
        let uuidString = CFUUIDCreateString(nil, puuid);
        let uuid = CFStringCreateCopy(nil, uuidString!) as String
        return uuid
    }
}
