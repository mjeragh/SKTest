//
//  GameScene.swift
//  SKTest
//
//  Created by Mohammad Jeragh on 9/9/18.
//  Copyright © 2018 Mohammad Jeragh. All rights reserved.
//

import SpriteKit
import GameplayKit


struct PhysicsCategory {
    static let None:    UInt32 = 0
    static let Peg:     UInt32 = 0b1        //1
    static let Block:   UInt32 = 0b10       //2
    static let Hole:    UInt32 = 0b100      //4
    static let Edge:    UInt32 = 0b1000     //8
    static let Label:   UInt32 = 0b10000    //16
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var pos : CGPoint!
    var playableRect : CGRect
    var pegRedNode : PegNode!
    var selectedNode = SKSpriteNode()
    //var previousPan = CGPoint.zero
    
    required init?(coder aDecoder: NSCoder) {
        //        let playableRect = CGRect(x: 0, y: 0, width: size.height, height: size.width)
        //        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        //        physicsBody.
        
        playableRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        super.init(coder: aDecoder)
        let maxAspectRatio : CGFloat = 16.0/9.0 //iPhone5
        let maxAspectRatioWidth = size.height / maxAspectRatio
        let playableMargin : CGFloat = (size.width - maxAspectRatioWidth)/2
        //let playableRect = CGRect(x: playableMargin, y: 0, width: maxAspectRatioWidth, height: size.height)
         playableRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        //
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            //iPhone X
            //https://goo.gl/YkocFU
            let maxAspectRatio: CGFloat = 2.16
            let playableHeight = (size.height) / maxAspectRatio
            let margin = (size.height - playableHeight) / 2
            // self.keyboardInAppOffset.constant = -34.0
            playableRect = CGRect(x: 0, y: 56, width: size.width, height: size.height-156)
        } else {
            let maxAspectRatio: CGFloat = 16.0/9.0
            let playableWidth = size.height / maxAspectRatio
            let margin = (size.width - playableWidth) / 2
            playableRect = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        }


        //




        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        debugDrawPlayableArea()

    }
    
    override func didMove(to view: SKView) {
        pegRedNode = childNode(withName: "peg") as? PegNode
        pos = pegRedNode.position
        enumerateChildNodes(withName: "//*", using: {node, _ in if let eventListnerNode = node as? EventListnerNode {
            eventListnerNode.didMovetoScene()
            }
        })
       
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler(_:)))
        gestureRecognizer.minimumNumberOfTouches = 1
        gestureRecognizer.maximumNumberOfTouches = 1
        self.view!.addGestureRecognizer(gestureRecognizer)
        //self.scene?.view?.addGestureRecognizer(gestureRecognizer)
    }
    
    func debugDrawPlayableArea() {
        let shape = SKShapeNode(rect: playableRect)
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    
    
    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

protocol EventListnerNode {
    func didMovetoScene()
}


extension GameScene {
    func didEnd(_ contact: SKPhysicsContact) {
        //
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Peg | PhysicsCategory.Block {
            print("SUCCESS")
            
        } else if collision == PhysicsCategory.Peg | PhysicsCategory.Edge {
            print("BABY")
            pegRedNode.removeAllActions()
        }
    }
}


extension GameScene {
    
    @objc func panGestureHandler(_ recognizer: UIPanGestureRecognizer) {
        var touchLocation = recognizer.location(in: recognizer.view)
        touchLocation = self.convertPoint(fromView: touchLocation)
       
        if recognizer.state == .began {
            print("Touchdown")
            
            if (self.atPoint(touchLocation) is SKSpriteNode){
                selectedNode = self.atPoint(touchLocation) as! SKSpriteNode
                selectedNode.physicsBody?.affectedByGravity = false
            } else {
                recognizer.state = .failed //from https://goo.gl/ddzhTs
            }
            
            
        } else if recognizer.state == .changed {
            
            var translation = recognizer.translation(in: recognizer.view!)
            
            translation = CGPoint(x: translation.x, y: -translation.y)
            
            //the line below I was testing with touchlocation instead of pos on Sept 22, I believe it is faster not smoother
            selectedNode.position = CGPoint(x: pos.x + translation.x, y: pos.y + translation.y)
            recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
             pos = touchLocation
            
        } else if recognizer.state == .ended {
            recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
            
            selectedNode.physicsBody?.affectedByGravity = true
            
            let scrollDuration = 0.2
            let velocity = recognizer.velocity(in: recognizer.view)
            
            let p = CGPoint(x: velocity.x * CGFloat(scrollDuration), y: velocity.y * CGFloat(scrollDuration))
            let newPos = CGPoint(x: pos.x + p.x, y: pos.y - p.y)
           
            
            let moveTo = SKAction.move(to: newPos, duration: scrollDuration)
            
            selectedNode.run(moveTo)
            }//end state
    }// Pan Gesture
    

    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(degree / 180.0 * Double.pi)
    }
    
}
