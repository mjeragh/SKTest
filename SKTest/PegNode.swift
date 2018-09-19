//
//  PegNode.swift
//  SKTest
//
//  Created by Mohammad Jeragh on 9/16/18.
//  Copyright © 2018 Mohammad Jeragh. All rights reserved.
//

import SpriteKit

class PegNode: SKSpriteNode, EventListnerNode {
    
    
    func didMovetoScene() {
        print("Red Peg")
        //adding Pan Gesture
        isUserInteractionEnabled = true
        
    }
    
    
    
//    func panForTranslation(translation: CGPoint) {
//        let position = selectedNode.position
//
//        if selectedNode.name! == kAnimalNodeName {
//            selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
//        } else {
//            let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
//            background.position = self.boundLayerPos(aNewPosition)
//        }
//    }

//    func degToRad(degree: Double) -> CGFloat {
//        return CGFloat(Double(degree) / 180.0 * M_PI)
//    }

//    func selectNodeForTouch(touchLocation: CGPoint) {
//        // 1
//        let touchedNode = self.nodeAtPoint(touchLocation)
//
//        if touchedNode is SKSpriteNode {
//            // 2
//            if !selectedNode.isEqual(touchedNode) {
//                selectedNode.removeAllActions()
//                selectedNode.runAction(SKAction.rotateToAngle(0.0, duration: 0.1))
//
//                selectedNode = touchedNode as! SKSpriteNode
//
//                // 3
//                if touchedNode.name! == kAnimalNodeName {
//                    let sequence = SKAction.sequence([SKAction.rotateByAngle(degToRad(-4.0), duration: 0.1),
//                                                      SKAction.rotateByAngle(0.0, duration: 0.1),
//                                                      SKAction.rotateByAngle(degToRad(4.0), duration: 0.1)])
//                    selectedNode.runAction(SKAction.repeatActionForever(sequence))
//                }
//            }
//        }
//    }
}
