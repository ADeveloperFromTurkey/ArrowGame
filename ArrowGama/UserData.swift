//
//  UserData.swift
//  ArrowGame
//
//  Created by Yusuf Erdem Ongun on 30.07.2025.
//
//
//  Copyright 2025 Yusuf Erdem Ongun
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
import SwiftUI
import Combine

class UserData: ObservableObject {
    
    @Published var secilenOk: String {
        didSet {
            UserDefaults.standard.set(secilenOk, forKey: "secilenOk")
        }
    }
    @Published var para: Int {
        didSet {
            UserDefaults.standard.set(para, forKey: "para")
        }
    }
    @Published var sahipOlunanOklar: [String] {
        didSet {
            UserDefaults.standard.set(sahipOlunanOklar, forKey: "sahipOlunanOklarListesi")
        }
    }
    let oklarınParaları: [String: Int] = ["ok1": 100, "ok2": 200, "ok3": 300, "ok4": 250, "ok5": 300, "ok6": 150]
    let oklar: [String] = ["ok1", "ok2", "ok3","ok4","ok5","ok6"]
    
    init() {
        self.para = UserDefaults.standard.integer(forKey: "para")
        self.sahipOlunanOklar = UserDefaults.standard.stringArray(forKey: "sahipOlunanOklarListesi") ?? ["ok1"]
        self.secilenOk = UserDefaults.standard.string(forKey: "secilenOk") ?? "ok1"
        if self.para == 0 && self.sahipOlunanOklar.isEmpty {
            self.sahipOlunanOklar = ["ok1"]
            self.secilenOk = "ok1"
        }
    }
}
