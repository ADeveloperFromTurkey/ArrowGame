//
//  AnaEkran.swift
//  ArrowGame
//
//  Created by Yusuf Erdem Ongun on 25.07.2025
//  GameScene.swift
//  ArrowGame
//
//  Copyright 2025 Yusuf Erdem Ongun
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//

import SpriteKit
import UIKit
import SwiftUI

class AnaEkran: SKScene{
    
    var appUserData: UserData!
    
    init(size: CGSize, userData: UserData) {
        super.init(size: size)
        self.appUserData = userData
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let baslaButonu = SKSpriteNode(imageNamed: "başlaButonu")
    let webButon = SKLabelNode(fontNamed: "Bion-Book")
    let storeButon = SKLabelNode(fontNamed: "Bion-Book")
    let OynanisButon = SKLabelNode(fontNamed: "Bion-Book")
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "arkaplan 2")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = self.size
        background.zPosition = 0
        addChild(background)
        
        let oyunYazi1 = SKLabelNode(fontNamed: "Bion-Book")
        oyunYazi1.text = "Ok"
        oyunYazi1.fontSize = 200
        oyunYazi1.fontColor = .white
        oyunYazi1.position = CGPoint(x: size.width/2, y: size.height/2 + 600)
        oyunYazi1.zPosition = 1
        self.addChild(oyunYazi1)
        let oyunYazi2 = SKLabelNode(fontNamed: "Bion-Book")
        oyunYazi2.text = "Oyunu"
        oyunYazi2.fontSize = 200
        oyunYazi2.fontColor = .white
        oyunYazi2.position = CGPoint(x: size.width/2, y: size.height/2 + 475)
        oyunYazi2.zPosition = 1
        self.addChild(oyunYazi2)
        let oyunYazi3 = SKLabelNode(fontNamed: "Bion-Book")
        oyunYazi3.text = "Başla"
        oyunYazi3.fontSize = 100
        oyunYazi3.fontColor = .white
        oyunYazi3.position = CGPoint(x: size.width/2, y: size.height/2 - 400)
        oyunYazi3.zPosition = 1
        self.addChild(oyunYazi3)
        webButon.text = "Kaynak Kodu"
        webButon.fontColor = .black
        webButon.fontSize = 50
        webButon.zPosition = 100
        webButon.name = "webButon"
        webButon.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.1)
        self.addChild(webButon)
        baslaButonu.setScale(1)
        baslaButonu.position = CGPoint(x: size.width/2, y: size.height/2)
        baslaButonu.zPosition = 1
        self.addChild(baslaButonu)
        storeButon.text = "Mağaza"
        storeButon.fontColor = .black
        storeButon.fontSize = 30
        storeButon.zPosition = 100
        storeButon.name = "storeButon"
        storeButon.position = CGPoint(x: self.size.width/2 - 300, y: self.size.height * 0.1 + 10)
        self.addChild(storeButon)
        OynanisButon.text = "Oynanış"
        OynanisButon.fontColor = .black
        OynanisButon.fontSize = 30
        OynanisButon.zPosition = 100
        OynanisButon.name = "OynanisButon"
        OynanisButon.position = CGPoint(x: self.size.width/2 + 300, y: self.size.height * 0.1 + 10)
        self.addChild(OynanisButon)
        let paraYazi = SKLabelNode(fontNamed: "Bion-Book")
        paraYazi.text = "\(appUserData.para) 🟡"
        paraYazi.fontSize = 50
        paraYazi.fontColor = .white
        paraYazi.zPosition = 102
        paraYazi.position = CGPoint(x: size.width * 0.27, y: size.height/2)
        paraYazi.horizontalAlignmentMode = .center
        self.addChild(paraYazi)
        let paraYazi2 = SKLabelNode(fontNamed: "Bion-Book")
        paraYazi2.text = "Para:"
        paraYazi2.fontSize = 50
        paraYazi2.fontColor = .white
        paraYazi2.zPosition = 102
        paraYazi2.position = CGPoint(x: size.width * 0.27, y: size.height/2 + 50)
        paraYazi2.horizontalAlignmentMode = .center
        self.addChild(paraYazi2)
        let yuksekSkorYazi = SKLabelNode(fontNamed: "Bion-Book")
        yuksekSkorYazi.text = "\(appUserData.EnYuksekSkor)"
        yuksekSkorYazi.fontSize = 70
        yuksekSkorYazi.fontColor = .white
        yuksekSkorYazi.zPosition = 102
        yuksekSkorYazi.position = CGPoint(x: size.width * 0.73, y: size.height/2)
        yuksekSkorYazi.horizontalAlignmentMode = .center
        self.addChild(yuksekSkorYazi)
        let yuksekSkorYazi2 = SKLabelNode(fontNamed: "Bion-Book")
        yuksekSkorYazi2.text = "Yüksek Skor:"
        yuksekSkorYazi2.fontSize = 30
        yuksekSkorYazi2.fontColor = .white
        yuksekSkorYazi2.zPosition = 102
        yuksekSkorYazi2.position = CGPoint(x: size.width * 0.73, y: size.height/2 + 60)
        yuksekSkorYazi2.horizontalAlignmentMode = .center
        self.addChild(yuksekSkorYazi2)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        for touch in touches{
            let dokunma = touch.location(in: self)
            if baslaButonu.contains(dokunma){
                let sceneToMoveTo = GameScene(size: self.size, userData: appUserData)
                sceneToMoveTo.scaleMode = self.scaleMode
                let Mtransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: Mtransition)
            }
            if webButon.contains(dokunma){
                if let url = URL(string: "https://github.com/ADeveloperFromTurkey/ArrowGame") {
                    UIApplication.shared.open(url)
                }};
            if storeButon.contains(dokunma) {
                guard let appUserDataToPass = self.appUserData else { // Değişken adı appUserData olmalı
                        print("Hata: AnaEkran'daki appUserData nil. Mağaza açılamadı.")
                        return
                    }
                let storeView = ContentView(appUserData: appUserDataToPass) .environmentObject(appUserDataToPass)
                let hostingController = UIHostingController(rootView: storeView)
                hostingController.modalPresentationStyle = .fullScreen
                
                if let window = self.view?.window,
                   let rootVC = window.rootViewController {
                    rootVC.present(hostingController, animated: true)
                }
            }
            if OynanisButon.contains(dokunma) {
                let storeView = OynanisMenuView()
                let hostingController = UIHostingController(rootView: storeView)
                hostingController.modalPresentationStyle = .fullScreen
                
                if let window = self.view?.window,
                   let rootVC = window.rootViewController {
                    rootVC.present(hostingController, animated: true)
                }
            }
        }
    }
}
