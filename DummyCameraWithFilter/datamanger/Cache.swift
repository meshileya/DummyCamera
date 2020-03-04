//
//  Cache.swift
//  DummyCameraWithFilter
//
//  Created by Israel Meshileya on 04/03/2020.
//  Copyright © 2020 Israel. All rights reserved.
//

import Foundation
class CacheHelper {
    let defaults = UserDefaults.standard
    func getCachedData(key: String) -> String{
        return (defaults.string(forKey: key) ?? "")
    }
    
    func cacheData(data: String, key:String){
        defaults.setValue(data, forKey: key)
        defaults.synchronize()
    }
}
