//
//  GameScene.swift
//  Project 17
//
//  Created by Pablo Rodrigues on 12/12/2022.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var startField : SKEmitterNode!
    var player : SKSpriteNode!
    var scoreLabel : SKLabelNode!
    var gameoverLabel : SKLabelNode!
    var newgameLabel : SKLabelNode!
    
    
    var gameTimer : Timer?
    let possibleEnemy = ["tv", "hammer", "ball"]
    var isGameOver = false
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score \(score)"
        }
    }
    
    var timerLoop = 0
    var timerInterval : Double = 1
    
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        startField = SKEmitterNode(fileNamed: "starfield")
        startField.position = CGPoint(x: 586, y: 150)
        startField.advanceSimulationTime(10)
        addChild(startField)
        startField.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: -293, y: 0)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: -300, y: -250)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        score = 0
        
        
        
        
        newGame()
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        
        
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard !isGameOver else {return}
        gameOver()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        
        if !isGameOver {
            gameOver()
            return
        }
        
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        for object in objects {
            if object.name == "newgame" {
                newGame()
            }
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -1024 {
                node.removeFromParent()
            }
            
            
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    @objc func createEnemy() {
        timerLoop += 1
        
        guard let enemy = possibleEnemy.randomElement() else {return}
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1024, y: Int.random(in: -386...384))
        sprite.name = "Enemy"
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
        if timerLoop >= 20 {
            timerLoop = 0
            
            if timerInterval >= 0.2 {
                timerInterval = 0.1
            }
            
            gameTimer?.invalidate()
            
            gameTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }
    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {return}
        var location = touch.location(in: self)
        
        if location.y < -250 {
            location.y = -250
        } else if location.y > 250 {
            location.y = 250
        }
        
        player.position = location
        
    }
    func gameOver() {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        isGameOver = true
        
        
        gameTimer?.invalidate()
        
        gameoverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameoverLabel.position = CGPoint(x: 0, y: 0)
        gameoverLabel.horizontalAlignmentMode = .center
        gameoverLabel?.fontSize = 50
        gameoverLabel.zPosition = 1
        gameoverLabel.color = .red
        gameoverLabel.text = "GAME OVER"
        addChild(gameoverLabel)
        
        newgameLabel = SKLabelNode(fontNamed: "Chalkduster")
        newgameLabel.position = CGPoint(x: -0, y: -150)
        newgameLabel.zPosition = 1
        newgameLabel.horizontalAlignmentMode = .center
        newgameLabel.fontSize = 40
        newgameLabel.name = "newgame"
        newgameLabel.text = "NEW GAME"
        addChild(newgameLabel)
        
    }
    
    func newGame() {
        guard isGameOver else { return }
        
        score = 0
        timerInterval = 1
        timerLoop = 0
        
        isGameOver = false
        
        if let gameoverLabel = gameoverLabel {
            gameoverLabel.removeFromParent()
        }
        if let newgameLabel = newgameLabel {
            newgameLabel.removeFromParent()
        }
        
        for node in children {
           if node.name == "Enemy" {
                node.removeFromParent()
            }
            
        }
        
        player.position = CGPoint(x: -293, y: 0)
        addChild(player)
        
        gameTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
    }
    
    
    
    
}
