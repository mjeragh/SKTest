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
    
  
}
