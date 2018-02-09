//
//  HistoryViewModel.swift
//  TaLa
//
//  Created by huydoquang on 2/7/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

protocol HistoryViewModelInterface {
    var didLoadHistories: Dynamic<[History]> {get}
    var didDeleteHistory: Dynamic<IndexPath> {get}
    
    func loadHistories()
    func deleteHistory(at indexPath: IndexPath)
    func editHistory(at indexPath: IndexPath)
    func desciption(at indexPath: IndexPath)
    func numberOfRows(section: Int) -> Int
    func historyCellViewModel(at indexPath: IndexPath) -> HistoryTableViewCellModelInterface?
}

class HistoryViewModel: HistoryViewModelInterface {
    var didLoadHistories: Dynamic<[History]> = Dynamic([])
    var didDeleteHistory: Dynamic<IndexPath> = Dynamic(IndexPath(item: 0, section: 0))
    private lazy var game: Game = {
        return GameManager.shared.currentGame!
        }()
    
    private var rounds: [Round] {
        return self.game.rounds?.sorted {$0.id < $1.id} ?? []
    }
    
    private var histories: [History] = [] {
        didSet {
            self.didLoadHistories.value = self.histories
        }
    }
    func loadHistories() {
        self.histories = self.rounds
            .sorted {$0.id < $1.id}
            .flatMap {History(round: $0)}
    }
    
    func deleteHistory(at indexPath: IndexPath) {
        self.histories.remove(at: indexPath.row)
    }
    
    func editHistory(at indexPath: IndexPath) {
        
    }
    
    func desciption(at indexPath: IndexPath) {
        
    }
    
    func numberOfRows(section: Int) -> Int {
        return self.histories.count
    }
    
    func historyCellViewModel(at indexPath: IndexPath) -> HistoryTableViewCellModelInterface? {
        let history = self.histories[indexPath.row]
        return HistoryTableViewCellModel(history: history)
    }
}
