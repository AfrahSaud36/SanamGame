import SpriteKit
import GameplayKit

class map: SKScene {
    
    override func didMove(to view: SKView) {
                if let diriyahNode = self.childNode(withName: "DiriyahRec") as? SKSpriteNode {
                    diriyahNode.name = "DiriyahRec" 
                }
            }
            
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = self.nodes(at: location)
        for node in touchedNodes {
            if node.name == "DiriyahRec" || node.name == "text diriyah" || node.name == "dyrMap" {
                goToAfterPlayButtonScene()
                return
                
                
            }
            
            if node.name == "x" {
                goToHomeScene()
                return
            }
        }
    }

            
    func goToAfterPlayButtonScene() {
        if let scene = SKScene(fileNamed: "afterPlayButton") {
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.2))
        }}
    
   func goToHomeScene() {
                    if let homeScene = SKScene(fileNamed: "homepage") {                        homeScene.scaleMode = .aspectFill
                        self.view?.presentScene(homeScene, transition: SKTransition.fade(withDuration: 0.2))
                        
                        
                        
                    }
                }

    }

