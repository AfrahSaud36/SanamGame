import SpriteKit
import GameplayKit

class homepage: SKScene {
    
    var button: SKSpriteNode?
    var coinCountLabel: SKLabelNode?
    
    override func didMove(to view: SKView) {
        // ✅ إعداد الخلفية
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -1
        background.size = self.size
        addChild(background)
        
        // ✅ البحث عن الزر وإضافته للمتغير
        button = self.childNode(withName: "button") as? SKSpriteNode
        button?.isUserInteractionEnabled = false
        
        // ✅ إنشاء وتعديل `SKLabelNode` لعرض عدد العملات
        setupCoinCountLabel()
        
        // ✅ تحميل عدد الكوينز من iCloud عند فتح الصفحة الرئيسية
        loadCoinsFromiCloud()

        // ✅ إجبار مزامنة `NSUbiquitousKeyValueStore`
        NSUbiquitousKeyValueStore.default.synchronize()
        
        // ✅ تأكد من أن الصفحة تستمع لتحديثات الكوينز
        NotificationCenter.default.addObserver(self, selector: #selector(updateCoinLabel), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: nil)

        // ✅ تأكيد تحميل الصفحة
        print("📢 الصفحة الرئيسية تم تحميلها، عدد الكوينز الحالي: \(CoinStorageHelper.shared.getCoinCount())")
    }
    
    func setupCoinCountLabel() {
        coinCountLabel = SKLabelNode(fontNamed: "Arial")
        coinCountLabel?.fontSize = 20
        coinCountLabel?.fontColor = .black // ✅ تغيير اللون إلى الأسود
        coinCountLabel?.fontColor = .white
        coinCountLabel?.horizontalAlignmentMode = .right
        coinCountLabel?.position = CGPoint(x: frame.maxX - 45, y: frame.maxY - 43)
        coinCountLabel?.zPosition = 10 // ✅ التأكد من أن النص فوق جميع العناصر
        
        if let coinCountLabel = coinCountLabel {
            addChild(coinCountLabel)
        }
    }
    
    
    /// ✅ تحميل عدد العملات من iCloud وتحديث `coinCountLabel`
    func loadCoinsFromiCloud() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let savedCoinCount = CoinStorageHelper.shared.getCoinCount()
            let arabicNumber = self.convertToArabicNumerals(savedCoinCount) // تحويل الرقم إلى عربي
            self.coinCountLabel?.text = arabicNumber
            self.coinCountLabel?.fontColor = .black // ✅ تأكيد تعيين اللون بعد النص
            print("🔄 تم تحديث الكوينز: \(savedCoinCount) (بالأرقام العربية: \(arabicNumber))")
        }
    }

    /// ✅ تحديث عدد الكوينز عند تغييره في iCloud
    @objc func updateCoinLabel() {
        loadCoinsFromiCloud()
    }

    /// ✅ دالة تحويل الأرقام إلى الأرقام العربية يدويًا
    func convertToArabicNumerals(_ number: Int) -> String {
        let arabicDigits = ["٠", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"]
        let numberString = String(number) // تحويل الرقم إلى نص
        var arabicNumber = ""
        
        for digit in numberString {
            if let digitInt = Int(String(digit)) {
                arabicNumber.append(arabicDigits[digitInt]) // استبدال الرقم بالرقم العربي
            } else {
                arabicNumber.append(digit) // في حالة وجود أي رموز أخرى تبقى كما هي
            }
        }
        
        return arabicNumber
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNodes = self.nodes(at: location)
            
            for node in touchedNodes {
                if node == button || node.name == "start" {
                    changeScene()
                    return
                }
            }
        }
    }

    func changeScene() {
        if let scene = SKScene(fileNamed: "map") {
            scene.scaleMode = .aspectFill
            let transition = SKTransition.crossFade(withDuration: 0.2)
            self.view?.presentScene(scene, transition: transition)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
