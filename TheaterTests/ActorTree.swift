//
//  ActorTree.swift
//  Actors
//
//  Created by Dario Lencina on 12/12/15.
//  Copyright © 2015 dario. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Theater

class ActorTreeGuy: Actor {
    
    class CreateChildren : Message {
        let count : Int
        
        init(count : Int, sender: Optional<ActorRef>) {
            self.count = count
            super.init(sender: sender)
        }
    }
    
    override func receive(msg: Actor.Message) {
        switch (msg) {
            case let m as CreateChildren:
                for _ in 1...m.count {
                    self.actorOf(ActorTreeGuy.self)
                }
        default:
            super.receive(msg)
        }
    }
}

class ActorTree: QuickSpec {
    
    override func spec() {
        
        describe("find a children in a remote node") {
            
            
            it("should be able to find a children in a fifth level") {
                let system = TestActorSystem(name: "World")
                let firstRef = system.actorOf(Actor.self, name : "first")
                let first = system.actorForRef(firstRef)!
                
                let secondRef = first.actorOf(Actor.self, name: "second")
                let second = system.actorForRef(secondRef)!
                
                let thirdRef = second.actorOf(Actor.self, name: "third")
                let third = system.actorForRef(thirdRef)!
                
                let fourthRef = third.actorOf(Actor.self, name: "fourth")
                let fourth = system.actorForRef(fourthRef)!
                
                let fifthRef = fourth.actorOf(Actor.self, name: "fifth")
                let fifth = system.actorForRef(fifthRef)!
                
                expect(system.actorForRef(fifthRef)).toEventually(beIdenticalTo(fifth), timeout: 10, pollInterval: 1, description: "Unable to create children")
            }
            
        }

        describe("ActorTree2") {
            let system  = TestActorSystem(name: "ActorTree")
            it("Create 25 actors") {
                let root = system.actorOf(ActorTreeGuy.self)
                    root ! ActorTreeGuy.CreateChildren(count:4, sender:nil)
                
                let root2 = system.actorOf(ActorTreeGuy.self)
                    root2 ! ActorTreeGuy.CreateChildren(count:19, sender:nil)
                if let r = system.actorForRef(root) {                    expect(r.getChildrenActors().count).toEventually(equal(Int(4)), timeout: 10, pollInterval: 1, description: "Unable to create children")
                }
                if let r = system.actorForRef(root2) {                    expect(r.getChildrenActors().count).toEventually(equal(Int(19)), timeout: 10, pollInterval: 1, description: "Unable to create children")
                }
            }
            
            it ("should stop when required"){
                system.stop()
                
                expect(system.selectActor("ActorTree/user")).toEventually(beNil(), timeout: 10, pollInterval: 1, description: "Unable to create children")
            }
        }
    }
}