//
//  Preferences.swift
//  Tahm
//
//  Created by Chace on 2019/8/30.
//  Copyright © 2019 Chace. All rights reserved.
//

import Foundation

struct Preferences {
    var cloud: Int {
        get {
            let savedCloud = UserDefaults.standard.integer(forKey: "cloud")
            if savedCloud >= 0 {
                return savedCloud
            }
            return 0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "cloud")
        }
    }
    var naming: Int {
        get {
            let savedNaming = UserDefaults.standard.integer(forKey: "naming")
            if savedNaming >= 0 {
                return savedNaming
            }
            return 0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "naming")
        }
    }
    var clipboard: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "clipboard")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "clipboard")
        }
    }
    var shortcut: Data? {
        get {
            return UserDefaults.standard.data(forKey: "shortcut") ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "shortcut")
        }
    }
    var powerBoot: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "powerBoot")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "powerBoot")
        }
    }
    var uploadMessage: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "uploadMessage")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "uploadMessage")
        }
    }
    var compress: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "compress")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "compress")
        }
    }
}
