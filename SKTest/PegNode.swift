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
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector(("handlePanFrom:")))
        //self.view!.addGestureRecognizer(gestureRecognizer)
        self.scene?.view?.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handlePanFrom(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
//            var touchLocation = recognizer.location(in:recognizer.view)
//            touchLocation = self.convertPointFromView(touchLocation)
            
//            self.selectNodeForTouch(touchLocation: touchLocation)
            print("Touchdown")
        } else if recognizer.state == .changed {
//            var translation = recognizer.translation(in:recognizer.view!)
//            translation = CGPoint(x: translation.x, y: -translation.y)
//
//            self.panForTranslation(translation: translation)
//
//            recognizer.setTranslation(CGRect.zero, inView: recognizer.view)
            print("Touching")
        } else if recognizer.state == .ended {
//            if selectedNode.name != kAnimalNodeName {
//                let scrollDuration = 0.2
//                let velocity = recognizer.velocity(in:recognizer.view)
//                let pos = selectedNode.position
//
//                // This just multiplies your velocity with the scroll duration.
//                let p = CGPoint(x: velocity.x * CGFloat(scrollDuration), y: velocity.y * CGFloat(scrollDuration))
//
//                var newPos = CGPoint(x: pos.x + p.x, y: pos.y + p.y)
//                newPos = self.boundLayerPos(newPos)
//                selectedNode.removeAllActions()
//
//                let moveTo = SKAction.moveTo(newPos, duration: scrollDuration)
//                moveTo.timingMode = .EaseOut
//                selectedNode.runAction(moveTo)
//
//            }
            print("Its Over")
        }
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
