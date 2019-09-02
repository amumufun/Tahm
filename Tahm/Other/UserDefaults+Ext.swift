//
//  UserDefaults+Ext.swift
//  Tahm
//
//  Created by Chace on 2019/8/29.
//  Copyright © 2019 Chace. All rights reserved.
//

import Foundation

extension UserDefaults {
    func retrive<T>(_ valueType: T.Type, key: String) -> T? where T: Codable {
        guard let data = value(forKey: key) as? Data, let decoded = try? JSONDecoder().decode(valueType, from: data) else {
            return nil
        }
        return decoded
    }
    
    func set<T>(_ value: T, key: String) where T: Codable {
        let encoded = try? JSONEncoder().encode(value)
        self.setValue(encoded, forKey: key)
    }
}
