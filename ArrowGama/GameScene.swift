//  GameScene.swift
//  ArrowGame
//  Created by Yusuf Erdem Ongun on 3.07.2025.
//  Türkiye C*
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
import GameplayKit
class Ok: SKSpriteNode {
    var hedefeCarpti = false
    var currentAngle: CGFloat = 0.0
    var radius: CGFloat = 100.0
}
var skor = 0
class GameScene: SKScene, SKPhysicsContactDelegate {
    struct PhysicsCategory {
        static let none: UInt32 = 0
        static let ok: UInt32 = 0b1
        static let hedef: UInt32 = 0b10
    }
   
    let skorYazi = SKLabelNode(fontNamed: "Bion-Book")
    var can = 3
    let canYazi = SKLabelNode(fontNamed: "Bion-Book")
    var artArdaOk: Int = 0
    var kontroller = 0
    let BaslaYazi1 = SKLabelNode(fontNamed: "Bion-Book")
    let BaslaYazi2 = SKLabelNode(fontNamed: "Bion-Book")
    
    var appUserData: UserData!
    
    enum oyunDurumlari {
        case baslangic
        case oyunda
        case bitis
    }
    
    var durum = oyunDurumlari.baslangic //deneme
    
    
    let okSes = SKAction.playSoundFileNamed("oksesi.wav", waitForCompletion: false)
    let checkPointSes = SKAction.playSoundFileNamed("checkpoint.wav", waitForCompletion: false)
    let yay = SKSpriteNode(imageNamed: "yay")
    let hedef = SKSpriteNode(imageNamed: "hedef")
    let radius: CGFloat = 100.0
    private var lastFireTime = Date()
    var gameArea: CGRect
    init(size: CGSize, userData: UserData) {
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
        self.appUserData = userData
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func update(_ currentTime: TimeInterval) {
        // Manuel ok-ok çarpışma kontrolü (mesafeye dayalı)
        let oklar = self.children.compactMap { $0 as? Ok }
        for i in 0..<oklar.count {
            for j in i+1..<oklar.count {
                let ok1 = oklar[i]
                let ok2 = oklar[j]

                let dx = ok1.position.x - ok2.position.x
                let dy = ok1.position.y - ok2.position.y
                let distance = sqrt(dx*dx + dy*dy)

                if distance < ok1.size.width {
                    ok1.removeFromParent()
                    ok2.removeFromParent()
                    canAzalt()
                    artArdaOk = 0
                    break
                }
            }
            
        }
        for node in self.children {
            if durum == oyunDurumlari.oyunda {
                if let ok = node as? Ok, ok.hedefeCarpti {
                    guard let hedef = self.childNode(withName: "hedef") else { continue }
                    
                    // Açıyı artır
                    ok.currentAngle += 0.02 // dönüş hızı

                    // Yeni pozisyonu hesapla
                    let newX = hedef.position.x + cos(ok.currentAngle) * ok.radius
                    let newY = hedef.position.y + sin(ok.currentAngle) * ok.radius

                    ok.position = CGPoint(x: newX, y: newY)
                    ok.zRotation = ok.currentAngle - .pi / 2 + .pi
                    
                }
                
            }
        }
        kontrol()
        
    }
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        let dekor = SKSpriteNode(imageNamed: "arkaplan")
        dekor.size = self.size
        dekor.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        dekor.zPosition = 0
        self.addChild(dekor)
        yay.setScale(1)
        yay.position = CGPoint(x: self.size.width / 2, y: 0 - yay.size.height)
        yay.zPosition = 3
        self.addChild(yay)
        yay.name = "yay"
        hedef.setScale(1.0)
        hedef.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.63)
        hedef.zPosition = 2
        hedef.name = "hedef"
        hedef.physicsBody = SKPhysicsBody(circleOfRadius: hedef.size.width / 2)
        //print(hedef.size)
        //print(hedef.physicsBody!)
        hedef.physicsBody!.affectedByGravity = false
        hedef.physicsBody!.categoryBitMask = PhysicsCategory.hedef
        hedef.physicsBody!.collisionBitMask = PhysicsCategory.none
        hedef.physicsBody!.contactTestBitMask = PhysicsCategory.ok
        hedef.alpha = 0
        self.addChild(hedef)
        let dondur = SKAction.rotate(byAngle: .pi, duration: 2)
        let surekliDon = SKAction.repeatForever(dondur)
        hedef.run(surekliDon)
        
        skorYazi.text = "Skor: 0"
        skorYazi.fontSize = 70
        skorYazi.fontColor = .white
        skorYazi.horizontalAlignmentMode = .center
        skorYazi.position = CGPoint(x: self.size.width * 0.5 , y: self.size.height + skorYazi.frame.height)
        skorYazi.zPosition = 100
        canYazi.text = "Can: 3"
        canYazi.fontSize = 40
        canYazi.fontColor = .white
        canYazi.horizontalAlignmentMode = .center
        canYazi.position = CGPoint(x: self.size.width * 0.5 , y: self.size.height + canYazi.frame.height)
        canYazi.zPosition = 99
        self.addChild(skorYazi)
        self.addChild(canYazi)
        
        let ekranaGel1 = SKAction.moveTo(y: self.size.height * 0.9, duration: 0.4)
        let ekranaGel2 = SKAction.moveTo(y: self.size.height * 0.875, duration: 0.4)
        canYazi.run(ekranaGel2)
        skorYazi.run(ekranaGel1)
        
        BaslaYazi1.text = "Başlamak için dokunun."
        BaslaYazi1.fontSize = 60
        BaslaYazi1.fontColor = .white
        BaslaYazi1.zPosition = 100
        BaslaYazi1.position = CGPoint(x: self.size.width * 0.5 , y: self.size.height * 0.5)
        BaslaYazi1.alpha = 0
        self.addChild(BaslaYazi1)
        
        let gecis = SKAction.fadeIn(withDuration: 0.4)
        
        BaslaYazi2.run(gecis)
        BaslaYazi2.text = "*"
        BaslaYazi2.fontSize = 600
        BaslaYazi2.fontColor = .white
        BaslaYazi2.zPosition = 100
        BaslaYazi2.position = CGPoint(x: self.size.width * 0.5 , y: self.size.height * 0.45)
        BaslaYazi2.alpha = 0
        self.addChild(BaslaYazi2)
        
        BaslaYazi1.run(gecis)
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        if body1.categoryBitMask == PhysicsCategory.ok && body2.categoryBitMask == PhysicsCategory.hedef {
            guard let ok = (body1.node as? Ok) ?? (body2.node as? Ok),
                  let hedef = (body1.node == ok ? body2.node : body1.node) as? SKSpriteNode else { return }

            // Oku durdur
            ok.physicsBody = nil
            ok.removeAllActions()

            let dx = ok.position.x - hedef.position.x
            let dy = ok.position.y - hedef.position.y
            let angle = atan2(dy, dx) + .pi / 2
            ok.hedefeCarpti = true
            ok.currentAngle = atan2(dy, dx)
            ok.radius = sqrt(dx*dx + dy*dy)

            ok.zRotation = angle
            skorEkle()
            artArdaOk += 1
        }
        
    }
    func skorEkle() {
        skor += 1
        skorYazi.text = "Skor: \(skor)"
        
    }
    func skorAzalt() {
        skor = skor - 1
        skorYazi.text = "Skor: \(skor)"
        //print("function called: skorAzalt")
        
    }
    func canEkle(_ sayi: Int) {
        can += sayi
        canYazi.text = "Can: \(can)"
        let renkEfekt = SKAction.colorize(with: .green, colorBlendFactor: 1, duration: 0)
        let renkSıfırla = SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0)
        let renkBekle = SKAction.wait(forDuration: 0.3)
        let renkSequence = SKAction.sequence([renkEfekt,renkBekle, renkSıfırla])
        canYazi.run(renkSequence)
        
    }
    func canAzalt() {
        can = can - 1
        if can == 0 {
            gameOver()
        }
        canYazi.text = "Can: \(can)"
        //print("function called: canAzalt")
        
        if can == 1 {
            let renkEfekt = SKAction.colorize(with: .red, colorBlendFactor: 1, duration: 0)
            let renkSıfırla = SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0)
            let renkBekle = SKAction.wait(forDuration: 0.3)
            let renkSequence = SKAction.sequence([renkEfekt,renkBekle, renkSıfırla,renkBekle,renkEfekt,renkBekle, renkSıfırla])
            canYazi.run(renkSequence)
        }
        
    }
    func oyunuBaslat() {
        durum = oyunDurumlari.oyunda
        
        let yaziyiGönder1 = SKAction.moveTo(x: self.size.width + BaslaYazi1.frame.width, duration: 0.6)
        let yaziyiSil = SKAction.removeFromParent()
        let yaziSiralama = SKAction.sequence([yaziyiGönder1, yaziyiSil])
        BaslaYazi1.run(yaziSiralama)
        let yaziyiGönder2 = SKAction.moveTo(x: self.size.width + BaslaYazi2.frame.width, duration: 0.6)
        let yaziSiralama2 = SKAction.sequence([yaziyiGönder2, yaziyiSil])
        BaslaYazi2.run(yaziSiralama2)
        
        let hedefGosterimi = SKAction.fadeIn(withDuration: 0.6)
        hedef.run(hedefGosterimi)
        
        let yayGetir = SKAction.moveTo(y: self.size.height * 0.2, duration: 0.6)
        yay.run(yayGetir)
        
    }
    func kontrolNoktası(){
        let kontrolNoktasi = SKSpriteNode(imageNamed: "kontrolNoktası")
        kontrolNoktasi.setScale(0.7)
        kontrolNoktasi.position = CGPoint(x: gameArea.size.width * 0.9, y: self.size.height + kontrolNoktasi.size.height)
        kontrolNoktasi.zPosition = 105
        kontrolNoktasi.alpha = 0
        self.addChild(kontrolNoktasi)
        
        let kontrolNoktasiGoster = SKAction.fadeIn(withDuration: 0)
        let kontrolNoktasiGizle = SKAction.fadeOut(withDuration: 0)
        let sahneyeGel = SKAction.moveTo(y: self.size.height * 0.9, duration: 0.4)
        let sahnedenGit = SKAction.moveTo(y: self.size.height + kontrolNoktasi.size.height, duration: 0.3)
        let bekle = SKAction.wait(forDuration: 0.3)
        let sil = SKAction.removeFromParent()
        let animasyon = SKAction.sequence([bekle,kontrolNoktasiGizle,bekle,kontrolNoktasiGoster,bekle,kontrolNoktasiGizle,bekle,kontrolNoktasiGoster])
        let kontrolNoktasiSequence = SKAction.sequence([checkPointSes,kontrolNoktasiGoster,sahneyeGel,animasyon,sahnedenGit,sil])
        kontrolNoktasi.run(kontrolNoktasiSequence)
        
    }
    func oktemilendiYazısı(){
        let yazi = SKLabelNode(fontNamed: "Bion-Book")
        yazi.text = "Oklar Temizlendi!"
        yazi.fontSize = 50
        yazi.fontColor = .white
        yazi.position = CGPoint(x: self.size.width * 0.5, y: 0 - yazi.frame.size.height)
        yazi.zPosition = 100
        self.addChild(yazi)
        let yaziGelme = SKAction.moveTo(y: self.size.height * 0.1, duration: 0.3)
        let yaziGitme = SKAction.moveTo(y: 0 - yazi.frame.height, duration: 0.3)
        let bekle = SKAction.wait(forDuration: 2)
        let Sil = SKAction.removeFromParent()
        let yaziSequence = SKAction.sequence([yaziGelme, bekle, yaziGitme, Sil])
        yazi.run(yaziSequence)
        
    }
    func kontrol() {
        if(artArdaOk >= 5){
            canEkle(1)
            artArdaOk = 0
        }
        if(kontroller < 1){
            if(skor == 15){
                canEkle(3)
                kontroller += 1
                kontrolNoktası()
            }
        }
        if(kontroller < 2){
            if(skor == 30){
                canEkle(10)
                kontroller += 1
                kontrolNoktası()
            }
        }
        if(kontroller < 3){
            if(skor == 40){
                canEkle(5)
                kontroller += 1
                kontrolNoktası()
                oktemilendiYazısı()
                self.enumerateChildNodes(withName: "ok") { node, _ in
                    node.removeFromParent()
                }
            }
        }
    }
    func gameOver(){
        durum = oyunDurumlari.bitis
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "ok"){
            ok, stop in
            ok.removeAllActions()
        }
        self.enumerateChildNodes(withName: "hedef"){
            hedef, stop in
            hedef.removeAllActions()
        }
        let sahneDegisimi = SKAction.run(_:sahneDegistir)
        let bekle = SKAction.wait(forDuration: 2)
        let actionSequence = SKAction.sequence([bekle, sahneDegisimi])
        self.run(actionSequence)
        
    }
    func sahneDegistir(){
        let sceneToMoveTo = OyunBitisSahnesi(size: self.size, appUserData: appUserData)
        sceneToMoveTo.scaleMode = self.scaleMode
        let Mtransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: Mtransition)
    }
    func okfirlat() {
        
        let currentTime = Date()
        if currentTime.timeIntervalSince(lastFireTime) > 0.5 {
            lastFireTime = currentTime
            let ok = Ok(imageNamed: "\(appUserData.secilenOk)")
            ok.setScale(1.0)
            ok.name = "ok"
            ok.position = yay.position
            ok.zPosition = 1
            ok.physicsBody = SKPhysicsBody(rectangleOf: ok.size)
            //print(ok.size)
            //print(ok.physicsBody!)
            ok.physicsBody!.affectedByGravity = false
            ok.physicsBody!.categoryBitMask = PhysicsCategory.ok
            ok.physicsBody!.collisionBitMask = PhysicsCategory.ok
            ok.physicsBody!.contactTestBitMask = PhysicsCategory.ok | PhysicsCategory.hedef
            ok.physicsBody!.collisionBitMask = PhysicsCategory.ok
            ok.physicsBody!.categoryBitMask = PhysicsCategory.ok
            //ok.physicsBody!.isDynamic = true
            ok.physicsBody!.affectedByGravity = false
            ok.physicsBody?.linearDamping = 0
            ok.physicsBody?.angularDamping = 0
            ok.physicsBody?.allowsRotation = true
            ok.physicsBody?.usesPreciseCollisionDetection = true
            ok.physicsBody?.isDynamic = true
            self.addChild(ok)
            let move = SKAction.moveTo(y: size.height, duration: 1.5)
            let okSequence = SKAction.sequence([okSes,move])
            ok.run(okSequence)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if durum == oyunDurumlari.oyunda {
            okfirlat()
        }
        else if durum == oyunDurumlari.baslangic {
            oyunuBaslat()
        }
    }
}
