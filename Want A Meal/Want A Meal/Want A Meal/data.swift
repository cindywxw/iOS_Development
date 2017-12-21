//
//  dish.swift
//  Want A Meal
//
//  Created by Cynthia on 09/03/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

// dish has properties of name, price, and image, used in "Menu"
class dish {
    var name: String?
    var price: Double?
    var image: UIImage?
    
    init(name: String?, price: Double?, image: UIImage?) {
        self.name = name
        self.price = price
        self.image = image
    }
}

/// attribute: http://stackoverflow.com/questions/30743408/check-for-internet-connection-in-swift-2-ios-9
// check the network availability
public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}

//class order {
//    var name: String?
////    var item: dish?
//    var quantity: Int?
//    
//    init(name: String?, quantity: Int?) {
//        self.name = name
//        self.quantity = quantity
//        
//    }
//    
//}




