//
//  GameScene.swift
//  SKTest
//
//  Created by Mohammad Jeragh on 9/9/18.
//  Copyright © 2018 Mohammad Jeragh. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion
import os.log
import os.signpost

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
    var prevPos : CGPoint!
    var playableRect : CGRect
    var pegRedNode : PegNode!
    var selectedNode = SKSpriteNode()
    //var previousPan = CGPoint.zero
    var endPanState = true
    let blockFeedback = UIImpactFeedbackGenerator(style: .medium)
    let edgeFeedback = UIImpactFeedbackGenerator(style: .light)
    
    let motionManager = CMMotionManager()
    var xAcceleration = CGFloat(0)
    var yAcceleration = CGFloat(0)
    
    let motionLog = OSLog(subsystem: "com.lanterntech.sktest", category: "MotionOperation")
    
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



        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        debugDrawPlayableArea()

    }
    
    override func didMove(to view: SKView) {
        pegRedNode = childNode(withName: "peg") as? PegNode
        pos = pegRedNode.position
        physicsWorld.gravity =  CGVector(dx: xAcceleration, dy: yAcceleration)
        enumerateChildNodes(withName: "//*", using: {node, _ in if let eventListnerNode = node as? EventListnerNode {
            eventListnerNode.didMovetoScene()
            }
        })
       
        setupCoreMotion()
        
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
    
    
    
    //for the bug of moving beyond the boundaries,
    //we might update the location here after the simulation and before rendering on the screen
    //or maybe adding a constraint
    override func didSimulatePhysics() {
        //
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
//        if endPanState {
//            pegRedNode.removeAllActions()
//            pegRedNode.physicsBody?.affectedByGravity=true
//        }
        if  endPanState {
            os_signpost(.begin, log: motionLog, name: "motion X")
            physicsWorld.gravity =  CGVector(dx: xAcceleration, dy: yAcceleration)
            os_signpost(.end, log: motionLog, name: "motion X")
        }
    }
}

protocol EventListnerNode {
    func didMovetoScene()
}

extension GameScene {
    func setupCoreMotion(){
        motionManager.accelerometerUpdateInterval = 0.2
        let queue = OperationQueue()
        motionManager.startAccelerometerUpdates(to: queue, withHandler: {accelerometerData, error in
            guard let accelermeterData = accelerometerData else {
                return
            }
            let acceleration = accelermeterData.acceleration
            self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
            self.yAcceleration = CGFloat(acceleration.y) * 0.75 + self.yAcceleration * 0.25
        })
    }
}


extension GameScene {
    func didEnd(_ contact: SKPhysicsContact) {
        //
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        endPanState = true
        if collision == PhysicsCategory.Peg | PhysicsCategory.Block {
            os_log("SUCCESS")
            
            blockFeedback.impactOccurred()
            
        } else if collision == PhysicsCategory.Peg | PhysicsCategory.Edge {
            os_log("BABY")
            
            pegRedNode.removeAllActions()
            edgeFeedback.impactOccurred()
        }
    }
}


extension GameScene {
    
    @objc func panGestureHandler(_ recognizer: UIPanGestureRecognizer) {
        var touchLocation = recognizer.location(in: recognizer.view)
        touchLocation = self.convertPoint(fromView: touchLocation)
       
        if recognizer.state == .began {
            os_log("Touchdown")
            
            if (self.atPoint(touchLocation) is SKSpriteNode){
                selectedNode = self.atPoint(touchLocation) as! SKSpriteNode
                selectedNode.physicsBody?.affectedByGravity = false
                endPanState = false
                pos = selectedNode.position //judt added
            } else {
                recognizer.state = .failed //from https://goo.gl/ddzhTs
            }
            
            
        } else if recognizer.state == .changed {
            
            var translation = recognizer.translation(in: recognizer.view!)
            
            translation = CGPoint(x: translation.x, y: -translation.y)
            
            if endPanState {
              
                pegRedNode.removeAllActions()
                
                recognizer.state = .failed
                endPanState = !endPanState //I think this line is useless and should be removed
                selectedNode.position = CGPoint(x: pos.x - prevPos.x, y: pos.y - prevPos.y)
                selectedNode.physicsBody?.affectedByGravity = true
            }else{
            
            var translation = recognizer.translation(in: recognizer.view!)
            
            translation = CGPoint(x: translation.x, y: -translation.y)
            
            //the line below I was testing with touchlocation instead of pos on Sept 22, I believe it is faster not smoother
            selectedNode.position = CGPoint(x: pos.x + translation.x, y: pos.y + translation.y)
            prevPos = translation
            recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
            pos = touchLocation
            
            }
        }else if recognizer.state == .ended {
            recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
            
            selectedNode.physicsBody?.affectedByGravity = true
           
            endPanState = true
            
           // let scrollDuration = 0.2
            let velocity = recognizer.velocity(in: recognizer.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
            //print("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
            
            // 2
            let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
            // 3
            let finalPoint = CGPoint(x:recognizer.view!.center.x + (velocity.x * slideFactor),
                                     y:recognizer.view!.center.y + (velocity.y * slideFactor))
            // 4
//            finalPoint.x = min(max(finalPoint.x, 0), size.width)
//            finalPoint.y = min(max(finalPoint.y, 0), size.height-156)
            
            selectedNode.physicsBody?.applyImpulse(CGVector(dx: finalPoint.x, dy: -finalPoint.y))
            
            }//end state
    }// Pan Gesture
    

    
}
