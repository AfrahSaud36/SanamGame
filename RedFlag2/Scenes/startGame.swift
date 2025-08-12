//
//  startGame.swift
//  RedFlag2
//
//  Created by Jwan Faisal Alameer on 11/09/1446 AH.
//

import SpriteKit

class startGame: SKScene {
    var play1: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        // البحث عن العقدة الموجودة في المشهد
        if let existingCharacter = self.childNode(withName: "play1") as? SKSpriteNode {
            play1 = existingCharacter
            
            // تحميل الصور من Assets
            let texture1 = SKTexture(imageNamed: "play1")
            let texture2 = SKTexture(imageNamed: "play2")
            
            // إنشاء الأنيميشن
            let animation = SKAction.animate(with: [texture1, texture2], timePerFrame: 0.1)
            let repeatAnimation = SKAction.repeatForever(animation)
            
            // تشغيل الأنيميشن على العقدة نفسها
            play1.run(repeatAnimation)
        }
        
        // الانتظار لمدة ثانيتين ثم الانتقال إلى GameScene
        let wait = SKAction.wait(forDuration: 2.0)
        let transition = SKAction.run { [weak self] in
            self?.goToGameScene()
        }
        self.run(SKAction.sequence([wait, transition]))
    }
    
    func goToGameScene() {
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            let transition = SKTransition.crossFade(withDuration: 0.1) // انتقال ناعم
            self.view?.presentScene(scene, transition: transition)
        }
    }


}

