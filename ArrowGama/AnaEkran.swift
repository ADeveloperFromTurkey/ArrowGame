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

import Foundation
import SpriteKit

class AnaEkran: SKScene{
    
    let baslaButonu = SKSpriteNode(imageNamed: "başlaButonu")
    let webButon = SKLabelNode(fontNamed: "Bion-Book")
    
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
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        for touch in touches{
            let dokunma = touch.location(in: self)
            if baslaButonu.contains(dokunma){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let Mtransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: Mtransition)
            }
            if webButon.contains(dokunma){
                if let url = URL(string: "https://github.com/ADeveloperFromTurkey/ArrowGame") {
                UIApplication.shared.open(url)
            }};
        }
    }
    
}
