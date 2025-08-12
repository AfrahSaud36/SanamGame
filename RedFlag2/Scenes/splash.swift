import SpriteKit

class SplashScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        let label = SKLabelNode(text: "Welcome to RedFlag2!")
        label.fontSize = 30
        label.fontColor = .black
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(label)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let scene = GameScene(fileNamed: "homepage") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
            }
        }
    }
}
