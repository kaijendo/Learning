//
//  GameSence.swift
//  ColorSpin
//
//  Created by Thuy Truong Quang on 7/5/18.
//  Copyright © 2018 Thuy Truong Quang. All rights reserved.
//

import UIKit
import SpriteKit
struct PhysicsCategory {
    static let Player: UInt32 = 1
    static let Obstacle: UInt32 = 2
    static let Edge: UInt32 = 4
}

class GameScene: SKScene {
    // MARK: - Properties
    let colorsPartern: [SKColor] = [SKColor.hexStringToColor(<#T##UIColor#>), SKColor.green, SKColor.yellow, SKColor.white]
    let player = SKShapeNode(circleOfRadius: (75))
//    let buttonLeft = SKShapeNode(fileNamed: <#T##String#>)
    var obstacles: [SKNode] = []
    let cameraNode = SKCameraNode()
    var score = 0
    
    // MARK: - Life Circle
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.setupPlayerAndObstacles()
        
//        let playerBody = SKPhysicsBody(circleOfRadius: 30)
//        playerBody.mass = 1.5
//        playerBody.categoryBitMask = PhysicsCategory.Player
//        playerBody.collisionBitMask = 4
//        player.physicsBody = playerBody
        
//        let ledge = SKNode()
//        ledge.position = CGPoint(x: size.width/2, y: 160)
//        let ledgeBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 10))
//        ledgeBody.isDynamic = false
//        ledgeBody.categoryBitMask = PhysicsCategory.Edge
//        ledge.physicsBody = ledgeBody
//        addChild(ledge)
//        
//        physicsWorld.gravity.dy = -22
        physicsWorld.contactDelegate = self
    }
    override init(size: CGSize) {
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.physicsBody?.velocity.dy = 800.0
    }
    
    // MARK: - Functions
    private func prepareInit() {
        
    }
    
    private func addPlayer(color: SKColor) {
        player.fillColor = color
        player.strokeColor = player.fillColor
        player.position = CGPoint(x: size.width / 2, y: size.height / 1.7)
        addChild(player)
    }
    
    private func randomColor() -> SKColor {
        let colorTemp = arc4random_uniform(UInt32(colorsPartern.count))
        return colorsPartern[Int(colorTemp)]
    }
    
    private func obstacleByDuplicatingPath(_ path: UIBezierPath, clockwise: Bool) -> SKNode {
        let container = SKNode()
        var rotationFactor = CGFloat(Double.pi / 2)
        if !clockwise {
            rotationFactor *= -1
        }
        for i in 0...5 {
            let section = SKShapeNode(path: path.cgPath)
            section.fillColor = colorsPartern[i]
            section.strokeColor = colorsPartern[i]
            section.zRotation = rotationFactor * CGFloat(i);
            
            container.addChild(section)
            
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = PhysicsCategory.Obstacle
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = PhysicsCategory.Player
            sectionBody.affectedByGravity = false
            section.physicsBody = sectionBody
        }
        return container
    }
    
    private func addShape() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: (size.width / 3)))
        path.addArc(withCenter: CGPoint.zero,
                    radius: size.width / 3,
                    startAngle: CGFloat(3.0 * Double.pi / 2),
                    endAngle: CGFloat(0),
                    clockwise: true)
        path.addLine(to: CGPoint(x: 200, y: 0))
        path.addArc(withCenter: CGPoint.zero,
                    radius: (size.width / 3) - 30,
                    startAngle: CGFloat(0.0),
                    endAngle: CGFloat(3.0 * Double.pi / 2),
                    clockwise: false)
        
        let obstacle = obstacleByDuplicatingPath(path, clockwise: true)
        obstacles.append(obstacle)
        obstacle.position = CGPoint(x: size.width/2, y: size.height/1.7)
        addChild(obstacle)
        
    }
    
    func dieAndRestart() {
        print("boom")
        player.physicsBody?.velocity.dy = 0
        player.removeFromParent()
        
        // TODO: Remove obstacles
        for node in obstacles {
            node.removeFromParent()
        }
        obstacles.removeAll()
        setupPlayerAndObstacles()
        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
        score = 0
    }
    
    private func setupPlayerAndObstacles() {
        addShape()
        addPlayer(color: randomColor())
    }
    
    func addButton(arrrow: UIButton) {
        
    }
}

// MARK: - <#SKPhysicsContactDelegate#>
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node as? SKShapeNode, let nodeB = contact.bodyB.node as? SKShapeNode {
            if nodeA.fillColor != nodeB.fillColor {
                dieAndRestart()
            } else {
                
            }
        }
    }
}
