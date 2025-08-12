import SpriteKit
import GameplayKit

class afterPlayButton: SKScene {
    
    override func didMove(to view: SKView) {
        if let buttonhNode = self.childNode(withName: "button") as? SKSpriteNode {
            buttonhNode.name = "button" // تأكد من أن الاسم مطابق في الـ SKScene
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = self.nodes(at: location)
        for node in touchedNodes {
            if node.name == "button" || node.name == "text agree"  {
                goToLoading()
                return }
            if node.name == "x" {
                goToHomeScene()
                return
            }
        }
    }
    
    func goToLoading() {
        if let scene = SKScene(fileNamed: "startGame") {
            scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.2))
        }
    }
    
    func goToHomeScene() {
                     if let homeScene = SKScene(fileNamed: "homepage") {                        homeScene.scaleMode = .aspectFill
                         self.view?.presentScene(homeScene, transition: SKTransition.fade(withDuration: 0.2))
                         
                         
                         
                     }
                 }
}
