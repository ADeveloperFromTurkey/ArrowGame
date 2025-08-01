//
//  OyunBitisSahnesi.swift
//  ArrowGame
//
//  Created by Yusuf Erdem Ongun on 24.07.2025.
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
import SwiftUI


class OyunBitisSahnesi: SKScene {
    
    var appUserData: UserData!
    
    init(size: CGSize,appUserData: UserData!) {
        super.init(size: size)
        self.appUserData = appUserData
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let yenidenBaslamaButonu = SKSpriteNode(imageNamed: "yenidenBaşlatButonu")
    let anaSayfaButonu = SKSpriteNode(imageNamed: "anaSayfaButonu")
    
    override func didMove(to view: SKView) {
        let arkaplan = SKSpriteNode(imageNamed: "arkaplan 2")
        arkaplan.position = CGPoint(x: size.width / 2, y: size.height / 2)
        arkaplan.size = self.size
        arkaplan.zPosition = 0
        self.addChild(arkaplan)
        
        let gameOverLabel1 = SKLabelNode(fontNamed: "Bion-Book")
        gameOverLabel1.position = CGPoint(x: size.width / 2 - 50, y: size.height / 2 + 400)
        gameOverLabel1.text = "OYUN"
        gameOverLabel1.fontSize = 200
        gameOverLabel1.zPosition = 100
        gameOverLabel1.fontColor = .white
        self.addChild(gameOverLabel1)
        let gameOverLabel2 = SKLabelNode(fontNamed: "Bion-Book")
        gameOverLabel2.position = CGPoint(x: size.width / 2 + 50, y: size.height / 2 + 200)
        gameOverLabel2.text = "BİTTİ."
        gameOverLabel2.fontSize = 200
        gameOverLabel2.zPosition = 101
        gameOverLabel2.fontColor = .white
        self.addChild(gameOverLabel2)
        let skorLabel = SKLabelNode(fontNamed: "Bion-Book")
        skorLabel.position = CGPoint(x: size.width / 2 - 175, y: size.height / 2 + 130)
        skorLabel.text = "Skor: \(skor)"
        skorLabel.horizontalAlignmentMode = .right
        skorLabel.fontSize = 50
        skorLabel.zPosition = 102
        skorLabel.fontColor = .white
        self.addChild(skorLabel)
        
        let defaults = UserDefaults()
        var yuksekSkor = defaults.integer(forKey: "yuksekSkor")
        
        if skor > yuksekSkor {
            yuksekSkor = skor
            defaults.set(yuksekSkor, forKey: "yuksekSkor")
        }
        
        let skorLabelUp = SKLabelNode(fontNamed: "Bion-Book")
        skorLabelUp.position = CGPoint(x: size.width / 2, y: size.height / 2 + 130)
        skorLabelUp.text = "Yüksek Skor: \(yuksekSkor)"
        skorLabelUp.horizontalAlignmentMode = .left
        skorLabelUp.fontSize = 50
        skorLabelUp.zPosition = 102
        skorLabelUp.fontColor = .white
        self.addChild(skorLabelUp)
        
        yenidenBaslamaButonu.setScale(1)
        yenidenBaslamaButonu.position = CGPoint(x: size.width / 2 - 250, y: size.height / 2 - 50)
        yenidenBaslamaButonu.zPosition = 103
        self.addChild(yenidenBaslamaButonu)
        
        anaSayfaButonu.setScale(1)
        anaSayfaButonu.position = CGPoint(x: size.width / 2 + 250, y: size.height / 2 - 50)
        anaSayfaButonu.zPosition = 103
        self.addChild(anaSayfaButonu)
        
        let kazanc = skor * 2
        appUserData.para += kazanc
        
        let kazancText = SKLabelNode(fontNamed: "Bion-Book")
        kazancText.position = CGPoint(x: size.width / 2, y: size.height / 2 - 450)
        kazancText.text = "Kazanç: \(kazanc) 🟡"
        kazancText.horizontalAlignmentMode = .center
        kazancText.fontSize = 100
        kazancText.zPosition = 102
        kazancText.fontColor = .white
        self.addChild(kazancText)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let dokunma = touch.location(in: self)
            
            if yenidenBaslamaButonu.contains(dokunma) {
                
                let sceneToMoveTo = GameScene(size: self.size, userData: appUserData)
                sceneToMoveTo.scaleMode = self.scaleMode
                let Mtransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: Mtransition)
                skor = 0
            }
            if anaSayfaButonu.contains(dokunma) {
                
                let sceneToMoveTo = AnaEkran(size: self.size, userData: appUserData)
                sceneToMoveTo.scaleMode = self.scaleMode
                let Mtransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: Mtransition)
                skor = 0
            }
        }
        
    }
}
