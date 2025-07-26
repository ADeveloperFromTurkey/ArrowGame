//
//  GameViewController.swift
//  ArrowGama
//
//  Created by Yusuf Erdem Ongun on 3.07.2025.
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

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    
    var arkaSes = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filePath = Bundle.main.path(forResource: "arkaplanSesi", ofType: "wav")!
        let ArkaplanSesiURL = URL(fileURLWithPath: filePath)
        
        do {arkaSes = try AVAudioPlayer(contentsOf: ArkaplanSesiURL)}
        catch { return print("cannot find file")}
        
        arkaSes.numberOfLoops = -1
        arkaSes.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)

                NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = AnaEkran(size: CGSize(width: 1536, height: 2048))
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    @objc func appDidEnterBackground() {
        arkaSes.pause()
    }

    @objc func appWillEnterForeground() {
        arkaSes.play()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
