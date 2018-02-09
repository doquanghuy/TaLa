//
//  UndoManager.swift
//  TaLa
//
//  Created by huydoquang on 1/20/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

protocol UndoManagerDelegate: class {
    func historyIsEmpty(isEmpty: Bool)
}

class UndoManager {
    private var history: [Command] {
        didSet {
            self.delegate?.historyIsEmpty(isEmpty: history.isEmpty)
        }
    }
    weak var receiver: RoundViewController?
    weak var delegate: UndoManagerDelegate?
    
    init(receiver: RoundViewController) {
        self.receiver = receiver
        self.history = [Command]()
    }
    
    func addUndoCommandPlayerDidEatCard(method: @escaping (RoundViewController) -> (Int, UIView, Int, UIView) -> Void, eatingIndex: Int, eatingView: UIView, ateIndex: Int, ateView: UIView) {
        self.history.append(GenericCommand.createCommand(receiver: self.receiver, instruction: { (receiver) in
            method(receiver)(eatingIndex, eatingView, ateIndex, ateView)
        }))
    }
    
    func addUndoCommandPlayerDidEndNormalResult(method: @escaping (RoundViewController) -> ([UIView], [Int], [UIView], [Int]) -> Void, orderIndexs: [Int], orderViews: [UIView], notEatIndexs: [Int], notEatViews: [UIView]) {
        self.history.append(GenericCommand.createCommand(receiver: self.receiver, instruction: { (receiver) in
            method(receiver)(orderViews, orderIndexs, notEatViews, notEatIndexs)
        }))
    }
    
    func addUndoCommandPlayerDidWin(method: @escaping (RoundViewController) -> (Int, UIView, [Int], [UIView], Bool, Bool) -> Void, eatingIndex: Int, eatingView: UIView, ateIndexs: [Int], ateViews: [UIView], isCircle: Bool, isDry: Bool) {
        self.history.append(GenericCommand.createCommand(receiver: self.receiver, instruction: { (receiver) in
            method(receiver)(eatingIndex, eatingView, ateIndexs, ateViews, isCircle, isDry)
        }))
    }
    
    func addUndoCommandPlayerDidWinLost(method: @escaping (RoundViewController) -> (Int, Int, Bool) -> Void, eatingIndex: Int, ateIndex: Int, isCircle: Bool) {
        self.history.append(GenericCommand.createCommand(receiver: self.receiver, instruction: { (receiver) in
            method(receiver)(eatingIndex, ateIndex, isCircle)
        }))
    }
    
    func undo() {
        guard !self.history.isEmpty else { return }
        let recentHistory = self.history.removeLast()
        recentHistory.excute()
    }
    
    func reset() {
        let reverseHistory = self.history.reversed()
        for event in reverseHistory {
            event.excute()
            self.history.removeLast()
        }
    }
    
    func combineCommands(numberToLast: Int) {
        let range = self.history.count - numberToLast..<self.history.count
        let commands = self.history[range]
        self.history.removeSubrange(range)
        let combineCommand = GenericCommand.createCommand(receiver: self.receiver) { (receiver) in
            for command in commands.reversed() {
                command.excute()
            }
        }
        self.history.append(combineCommand)
    }
}
