import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var obstacles: [SKSpriteNode] = []
    var groundNodes: [SKSpriteNode] = []
    var backgroundNodes: [SKSpriteNode] = []
    var coins: [SKSpriteNode] = []
    
    var coinCount = 0
    var coinImage: SKSpriteNode!
    var coinCountLabel: SKLabelNode!
    var runningSoundAction: SKAction!
    
    var gameOverLabel: SKLabelNode!
    var isGameOver = false
    
    let playerCategory: UInt32 = 0x1 << 0
    let obstacleCategory: UInt32 = 0x1 << 1
    let groundCategory: UInt32 = 0x1 << 2
    let coinCategory: UInt32 = 0x1 << 3
    
    var camel: SKSpriteNode!
    var homeNode: SKSpriteNode!
    
    var speedIncreaseTimer: TimeInterval = 0
    var currentSpeed: CGFloat = 3.0
    
    let homeIcon = SKSpriteNode(imageNamed: "homeIcon")
    let retry = SKSpriteNode(imageNamed: "retrry")
    
    var jumpCount = 0 // newwwwww
    let maxJumps = 2
    
    var runningSoundNode: SKAudioNode? // لإدارة صوت المشي

    override func didMove(to view: SKView) {
        player = childNode(withName: "player") as? SKSpriteNode
        guard player != nil else { return }
        
        runningSoundAction = SKAction.playSoundFileNamed("coinSound.mp3", waitForCompletion: false)

        // إضافة صوت المشي
        if let runningSoundNode = self.runningSoundNode {
            runningSoundNode.removeFromParent()
        }
        let runningNode = SKAudioNode(fileNamed: "Running.mp3")
        runningNode.autoplayLooped = true
        runningNode.isPositional = false
        addChild(runningNode)
        self.runningSoundNode = runningNode

        coinCount = 0
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        setupPlayer()
        setupCamel()
        startRunningAnimation()
        setupGround()
        setupBackground()
        setupCoinImage()
        setupCoinCountLabel()
        setupHomeNode()
        
        
        let obstacleWaitAction = SKAction.wait(forDuration: 2.0)
        let coinWaitAction = SKAction.wait(forDuration: 1.0)
        
        let spawnObstacleAction = SKAction.run { [weak self] in
            self?.spawnObstacle()
        }
        let spawnCoinAction = SKAction.run { [weak self] in
            self?.spawnCoin()
        }
        
        let obstacleSequence = SKAction.sequence([spawnObstacleAction, obstacleWaitAction])
        let coinSequence = SKAction.sequence([spawnCoinAction, coinWaitAction])
        
        run(SKAction.repeatForever(obstacleSequence))
        run(SKAction.repeatForever(coinSequence))
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isGameOver { return }
        
        speedIncreaseTimer += 1 / 60 // زيادة المؤقت بناءً على معدل الإطارات (60 إطارًا في الثانية)
        
        if speedIncreaseTimer >= 10 {
            speedIncreaseTimer = 0
            increaseSpeed()
        }
        
        // منع اللاعب من الخروج من حدود الشاشة newwwwwwwwwwwwwwwwww
        if let player = player {
            let minX = frame.minX + player.size.width / 2
            let maxX = frame.maxX - player.size.width / 2
            let minY = frame.minY + player.size.height / 2
            let maxY = frame.maxY - player.size.height / 2
            var newPosition = player.position
            newPosition.x = max(minX, min(maxX, newPosition.x))
            newPosition.y = max(minY, min(maxY, newPosition.y))
            player.position = newPosition
        }
    }
    
    func increaseSpeed() {
        currentSpeed *= 0.9 // زيادة السرعة (تقليل المدة يجعل الحركة أسرع)
        
        // تحديث سرعة العقبات
        for obstacle in obstacles {
            obstacle.removeAllActions()
            let moveAction = SKAction.moveBy(x: -1000, y: 0, duration: currentSpeed)
            let disappearAction = SKAction.removeFromParent()
            obstacle.run(SKAction.sequence([moveAction, disappearAction]))
        }
        
        // تحديث سرعة اللاعب (إذا كنت تريد زيادة سرعة اللاعب)
        player.removeAllActions()
        let runningAnimation = SKAction.animate(with: [SKTexture(imageNamed: "run1.png"), SKTexture(imageNamed: "run2.png"), SKTexture(imageNamed: "run3.png")], timePerFrame: 0.1)
        let repeatAnimation = SKAction.repeatForever(runningAnimation)
        player.run(repeatAnimation)
    }
    
    func setupCamel() {
        camel = SKSpriteNode(imageNamed: "player22")
        camel.position = CGPoint(x: player.position.x - 160, y: player.position.y + 20)
        camel.size = CGSize(width: 200, height: 150)
        camel.zPosition = 1
        addChild(camel)
        startCamelAnimation()
    }
    
    func setupCoinImage() {
        coinImage = SKSpriteNode(imageNamed: "coins")
        coinImage.size = CGSize(width: 30, height: 30)
        coinImage.position = CGPoint(x: frame.minX + 600, y: frame.maxY - 40)
        addChild(coinImage)
    }
    
    
    func setupCoinCountLabel() {
        coinCountLabel = SKLabelNode(fontNamed: "Arial")
        coinCountLabel.fontSize = 24
        coinCountLabel.fontColor = .white
        coinCountLabel.position = CGPoint(x: coinImage.position.x - 30, y: coinImage.position.y - 10)
        coinCountLabel.text = convertToArabicNumerals(coinCount)
        addChild(coinCountLabel)
    }
    
    func setupHomeNode() {
        let homeTexture = SKTexture(imageNamed: "Home")
        homeNode = SKSpriteNode(texture: homeTexture, size: CGSize(width: 227.744, height: 319.812))
        homeNode.position = CGPoint(x: frame.maxX - 66, y: frame.midY)
        homeNode.isHidden = true
        homeNode.zPosition = 2
        addChild(homeNode)
    }
    
    func startCamelAnimation() {
        let camelTexture1 = SKTexture(imageNamed: "player22")
        let camelTexture2 = SKTexture(imageNamed: "player222")
        
        let animation = SKAction.animate(with: [camelTexture1, camelTexture2], timePerFrame: 0.2)
        let repeatAnimation = SKAction.repeatForever(animation)
        camel.run(repeatAnimation)
    }
    
    func setupPlayer() {
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = obstacleCategory | groundCategory | coinCategory
        player.physicsBody?.collisionBitMask = obstacleCategory | groundCategory
        player.zPosition = 1
    }
    
    func startRunningAnimation() {
        let texture1 = SKTexture(imageNamed: "run1.png")
        let texture2 = SKTexture(imageNamed: "run2.png")
        let texture3 = SKTexture(imageNamed: "run3.png")
        
        let animation = SKAction.animate(with: [texture1, texture2, texture3], timePerFrame: 0.1)
        let repeatAnimation = SKAction.repeatForever(animation)
        player.run(repeatAnimation)
    }
    
    func setupGround() {
        if let ground = childNode(withName: "ground") as? SKSpriteNode {
            groundNodes.append(ground)
            
            for i in 1...2 {
                let newGround = ground.copy() as! SKSpriteNode
                newGround.position.x = ground.position.x + ground.size.width * CGFloat(i)
                addChild(newGround)
                groundNodes.append(newGround)
            }
            
            for ground in groundNodes {
                ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
                ground.physicsBody?.isDynamic = false
                ground.physicsBody?.categoryBitMask = groundCategory
                ground.zPosition = -1
            }
            
            // سرعة ثابتة للأرض (بدون تأثر بـ currentSpeed)
            let moveAction = SKAction.moveBy(x: -ground.size.width, y: 0, duration: 5.0) // سرعة ثابتة
            let resetAction = SKAction.run { [weak self] in
                guard let self = self else { return }
                for ground in self.groundNodes {
                    if ground.position.x + ground.size.width < 0 {
                        ground.position.x += ground.size.width * CGFloat(self.groundNodes.count)
                    }
                }
            }
            let sequence = SKAction.sequence([moveAction, resetAction])
            let repeatAction = SKAction.repeatForever(sequence)
            
            for ground in groundNodes {
                ground.run(repeatAction)
            }
        }
    }
    
    func setupBackground() {
        if let background = childNode(withName: "background") as? SKSpriteNode {
            background.zPosition = -2
            backgroundNodes.append(background)
            
            for i in 1...2 {
                let newBackground = background.copy() as! SKSpriteNode
                newBackground.position.x = background.position.x + background.size.width * CGFloat(i)
                newBackground.zPosition = -2
                addChild(newBackground)
                backgroundNodes.append(newBackground)
            }
            
            // سرعة ثابتة للخلفية (بدون تأثر بـ currentSpeed)
            let moveAction = SKAction.moveBy(x: -background.size.width, y: 0, duration: 5.0) // سرعة ثابتة
            let resetAction = SKAction.run { [weak self] in
                guard let self = self else { return }
                for background in self.backgroundNodes {
                    if background.position.x + background.size.width < 0 {
                        background.position.x += background.size.width * CGFloat(self.backgroundNodes.count)
                    }
                }
            }
            let sequence = SKAction.sequence([moveAction, resetAction])
            let repeatAction = SKAction.repeatForever(sequence)
            
            for background in backgroundNodes {
                background.run(repeatAction)
            }
        }
    }
    
    func spawnCoin() {
        let coin = SKSpriteNode(imageNamed: "coins")
        coin.size = CGSize(width: 30, height: 30)
        coin.name = "coins"
        
        let randomY = GKRandomDistribution(lowestValue: -80, highestValue: 100)
        let coinX = frame.size.width + coin.size.width
        let coinY = CGFloat(randomY.nextInt())
        var positionIsSafe = true
        // تحقق من عدم تداخل الكوين مع أي عقبة
        for obstacle in obstacles {
            let obstacleFrame = obstacle.frame.insetBy(dx: -14, dy: -40) // هامش رأسي أكبر لمنع القرب الشديد
            let coinFrame = CGRect(x: coinX - coin.size.width/2, y: coinY - coin.size.height/2, width: coin.size.width, height: coin.size.height)
            if obstacleFrame.intersects(coinFrame) {
                positionIsSafe = false
                break
            }
        }
        if !positionIsSafe {
            return // لا تضع الكوين إذا كان فوق عقبة
        }
        coin.position = CGPoint(x: coinX, y: coinY)
        let move = SKAction.moveBy(x: -1000, y: 0, duration: currentSpeed)
        let disappear = SKAction.removeFromParent()
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.size.width / 4)
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.categoryBitMask = coinCategory
        coin.zPosition = 1
        coin.run(SKAction.sequence([move, disappear]))
        addChild(coin)
        coins.append(coin)
    }
    
    
    func spawnObstacle() {
        let obstacleTypes = ["grass", "rock"]
        let randomType = obstacleTypes.randomElement()!
        
        let randomX = GKRandomDistribution(lowestValue: 300, highestValue: 400)
        let move = SKAction.moveBy(x: -1000, y: 0, duration: currentSpeed)
        let disappear = SKAction.removeFromParent()
        
        let obstacle = SKSpriteNode(imageNamed: randomType)
        obstacle.size = CGSize(width: 32, height: 32)
        obstacle.name = randomType
        
        if let ground = groundNodes.first {
            let groundTopY = ground.position.y + (ground.size.height / 3)
            let obstacleY = groundTopY + (obstacle.size.height / 3)
            obstacle.position = CGPoint(x: randomX.nextInt(), y: Int(obstacleY))
        }
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = obstacleCategory
        obstacle.zPosition = 1
        
        obstacle.run(SKAction.sequence([move, disappear]))
        addChild(obstacle)
        obstacles.append(obstacle)
    }
    
    


    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = self.nodes(at: location)

        for node in touchedNodes {
            if node.name == "homeIcon" {
                goToHomeScene()
                return
            }
            if node.name == "retry" {
                restartGame()
                return
            }
        }

        guard let player = player else { return }
        if isGameOver { return } // newwwwwwwwwwwwwwwwww
        if jumpCount < maxJumps {
            let maxJumpVelocity: CGFloat = 300
            let jumpVelocity = min(320, maxJumpVelocity)
            player.physicsBody?.velocity.dy = 0 // حتى يكون القفز الثاني قوي
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpVelocity))
            jumpCount += 1
            // تشغيل صوت القفز
            run(SKAction.playSoundFileNamed("jump.mp3", waitForCompletion: false))
        }
    }


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

    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == obstacleCategory) ||
            (contact.bodyB.categoryBitMask == playerCategory && contact.bodyA.categoryBitMask == obstacleCategory) {
            
            gameOver()
        } else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == coinCategory) ||
                    (contact.bodyB.categoryBitMask == playerCategory && contact.bodyA.categoryBitMask == coinCategory) {
            
            if contact.bodyA.categoryBitMask == coinCategory {
                contact.bodyA.node?.removeFromParent()
                coinCount += 1
            } else {
                contact.bodyB.node?.removeFromParent()
                coinCount += 1
            }
            
            run(SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false))


            coinCountLabel.text = convertToArabicNumerals(coinCount)

            if coinCount >= 70 {
                homeNode.isHidden = false
                winGame()
            }
        } else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == groundCategory) ||
                  (contact.bodyB.categoryBitMask == playerCategory && contact.bodyA.categoryBitMask == groundCategory) {
            // اللاعب لمس الأرض newwwwwwwwwwww
            jumpCount = 0
        }
    }
    
    func restartGame() {
        if let scene = GameScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.5))
        }
    }
    
    
   func goToHomeScene() {
      if let homeScene = SKScene(fileNamed: "homepage") {
          homeScene.scaleMode = .aspectFill
        self.view?.presentScene(homeScene, transition: SKTransition.fade(withDuration: 0.2))
 }
                }
    
    func gameOver() {
        if isGameOver { return }
        
        let blurNode = SKEffectNode()
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        
        blurFilter?.setValue(10.0, forKey: kCIInputRadiusKey)
        
        blurNode.filter = blurFilter
        blurNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        blurNode.zPosition = 5
        
         blurNode.blendMode = .alpha
        let blurredBackground = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.4), size: self.size)
         blurredBackground.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        blurredBackground.zPosition = 5
        
         blurNode.addChild(blurredBackground)
        self.addChild(blurNode)
            
            let winImage = SKSpriteNode(imageNamed: "recMap loss")
            winImage.size = CGSize(width: 300, height: 200)
            winImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            winImage.zPosition = 6
            self.addChild(winImage)
        
        
        retry.name = "retry"
        retry.size = CGSize(width: 25, height: 25)
        retry.position = CGPoint(x: -40, y:-50)
        retry.zPosition = 7
        self.addChild(retry)
        
        homeIcon.name = "homeIcon"
        homeIcon.size = CGSize(width: 30, height: 30)
        homeIcon.position = CGPoint(x: 40, y:-50)
        homeIcon.zPosition = 7
        self.addChild(homeIcon)
          
        isGameOver = true
        self.isPaused = true
        // جمع الكوينز الجديدة مع الكوينز القديمة
        let totalCoins = CoinStorageHelper.shared.getCoinCount() + self.coinCount
        CoinStorageHelper.shared.saveCoinCount(totalCoins)
        print("✅ حفظ الكوينز: \(totalCoins)")
        
        // إيقاف صوت المشي عند الخسارة
        runningSoundNode?.run(SKAction.stop())
    }
    

    func winGame() {
        if isGameOver { return }
        
        for ground in groundNodes {
            ground.removeAllActions()
        }
        for background in backgroundNodes {
            background.removeAllActions()
        }
        
        for obstacle in obstacles {
            obstacle.removeAllActions()
            obstacle.physicsBody = nil
        }
        for coin in coins {
            coin.removeAllActions()
        }
        
        for obstacle in obstacles {
            obstacle.isHidden = true
        }
        for coin in coins {
            coin.isHidden = true
        }
        
        self.removeAllActions()
        
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.velocity.dy = 0
        camel.removeAllActions()
        
        if let ground = groundNodes.first {
            let groundTopY = ground.position.y + (ground.size.height / 2)
            let moveToGround = SKAction.move(to: CGPoint(x: player.position.x, y: groundTopY + (player.size.height / 2)), duration: 0.5)
            player.run(moveToGround) {
                let waitAction = SKAction.wait(forDuration: 0.5)
                let moveToHome = SKAction.move(to: CGPoint(x: self.homeNode.position.x - 100, y: self.player.position.y), duration: 3.0)
                let sequence = SKAction.sequence([waitAction, moveToHome])
                
                self.player.run(sequence) {
                             let blurNode = SKEffectNode()
                             let blurFilter = CIFilter(name: "CIGaussianBlur")
                             blurFilter?.setValue(10.0, forKey: kCIInputRadiusKey) // تحديد درجة البلور
                             blurNode.filter = blurFilter
                             blurNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                             blurNode.zPosition = 5
                             blurNode.blendMode = .alpha

                             // إضافة صورة للخلفية مع البلور
                             let blurredBackground = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.4), size: self.size)
                             blurredBackground.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                             blurredBackground.zPosition = 5
                    
                             blurNode.addChild(blurredBackground)
                             self.addChild(blurNode)
                    
                    // جمع الكوينز الجديدة مع الكوينز القديمة
                    let totalCoins = CoinStorageHelper.shared.getCoinCount() + self.coinCount
                    CoinStorageHelper.shared.saveCoinCount(totalCoins)
                    print("✅ حفظ الكوينز: \(totalCoins)")
                    
                    let winImage = SKSpriteNode(imageNamed: "recMap Win")
                    winImage.size = CGSize(width: 300, height: 200)
                    winImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                    winImage.zPosition = 6
                    self.addChild(winImage)
                   
                    self.homeIcon.name = "homeIcon"
                                 self.homeIcon.size = CGSize(width: 30, height: 30)
                                 self.homeIcon.position = CGPoint(x: 0, y: -50)
                                 self.homeIcon.zPosition = 7
                                 self.addChild(self.homeIcon)
                    
                    self.isGameOver = true
                    self.isPaused = true
                }
            }
        }
        
        isGameOver = true
        
        // إيقاف صوت المشي عند الفوز
        runningSoundNode?.run(SKAction.stop())
    }}

