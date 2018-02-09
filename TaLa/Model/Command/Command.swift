//
//  Command.swift
//  TaLa
//
//  Created by huydoquang on 1/20/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import Foundation

protocol Command {
    func excute()
}

class GenericCommand<T>: Command where T: NSObject {
    private var instruction: ((T) -> Void)
    private weak var receiver: T?
    
    init(receiver: T?, instruction: @escaping((T) -> Void)) {
        self.instruction = instruction
        self.receiver = receiver
    }
    
    func excute() {
        guard let receiver = self.receiver else {return}
        instruction(receiver)
    }
    
    static func createCommand(receiver: T?, instruction: @escaping((T)  -> Void)) -> Command {
        return GenericCommand(receiver: receiver, instruction: instruction)
    }
}
