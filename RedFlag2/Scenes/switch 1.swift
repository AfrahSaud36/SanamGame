//import SpriteKit
//
//class SwitchScene: SKScene {
//    
//    var girlSwitch: SKSpriteNode!
//    var boySwitch: SKSpriteNode!
//    var arrowLeft: SKSpriteNode!
//    var arrowRight: SKSpriteNode!
//    
//    override func didMove(to view: SKView) {
//        // ربط العناصر من المشهد
//        girlSwitch = childNode(withName: "girlSwitch") as? SKSpriteNode
//        boySwitch = childNode(withName: "boySwitch") as? SKSpriteNode
//        arrowLeft = childNode(withName: "arrow1") as? SKSpriteNode
//        arrowRight = childNode(withName: "arrow2") as? SKSpriteNode
//
//        // تأكد من أن الأسهم أمام الشخصيات
//        arrowLeft.zPosition = 10
//        arrowRight.zPosition = 10
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//        let touchedNodes = self.nodes(at: location)
//
//        for node in touchedNodes {
//            if node == arrowRight {
//                print("تم الضغط على السهم الأيمن")
//                bringGirlToFront()
//                return
//            } else if node == arrowLeft {
//                print("تم الضغط على السهم الأيسر")
//                bringBoyToFront()
//                return
//            }
//        }
//    }
//    
//    func bringGirlToFront() {
//        print("تحريك البنت للأمام")
//        girlSwitch.position = CGPoint(x: -106.887, y: -12)
//        girlSwitch.size = CGSize(width: 109.378, height: 216.429)
//        
//        // إعادة حجم وموقع الولد لحالته الطبيعية
//        boySwitch.position = CGPoint(x: 80.92, y: -36.112)
//        boySwitch.size = CGSize(width: 65.57, height: 129.745)
//    }
//    
//    func bringBoyToFront() {
//        print("تحريك الولد للأمام")
//        boySwitch.position = CGPoint(x: 70, y: -6)
//        boySwitch.size = CGSize(width: 94, height: 186)
//        
//        // إعادة حجم وموقع البنت لحالتها الطبيعية
//        girlSwitch.position = CGPoint(x: -85.667, y: -22.692)
//        girlSwitch.size = CGSize(width: 71, height: 154)
//    }
//}
