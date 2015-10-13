//
//  Message.swift
//  Actors
//
//  Created by Dario Lencina on 9/26/15.
//  Copyright © 2015 dario. All rights reserved.
//

import Foundation

@objc public class Message : NSObject {
    
    public let sender : Optional<ActorRef>
    
     public init(sender : Optional<ActorRef>) {
        self.sender = sender
    }
    
}

/**
Harakiri is the default Message that forces an Actor to commit suicide, this behaviour can be changed once you override the #Actor.receive method.
*/

public class Harakiri : Message {
    
    public override init(sender: Optional<ActorRef>) {
        super.init(sender: sender)
    }
}

/**
Convenient Message subclass which has an operationId that can be used to track a transaction or some sort of message that needs to be tracked
*/

public class MessageWithOperationId : Message {
    public let operationId : NSUUID
    
    public init(sender: Optional<ActorRef>, operationId : NSUUID) {
        self.operationId = operationId
        super.init(sender : sender)
    }
}

/**
This is an Actor System generated message that is sent to the sender when it tries to send a message to an Actor that has been stopped beforehand.
*/

public class DeadLetter : Message {
    
    public let deadActor : ActorRef
    public let message : Message
    
    public init(message : Message, sender: Optional<ActorRef>, deadActor : ActorRef) {
        self.deadActor = deadActor
        self.message = message
        super.init(sender: sender)
    }
}

