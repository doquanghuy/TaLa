//
//  RoundViewController.swift
//  TaLa
//
//  Created by huydoquang on 1/7/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

class RoundViewController: BaseViewController {
    @IBOutlet weak var roundOrderView: RoundOrderView!
    @IBOutlet weak var roundPlayersView: RoundPlayerView!
    @IBOutlet weak var resetBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var undoBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var roundResultView: RoundResultView!

    private let viewModel: RoundViewModelInterface = RoundViewModel()
    private var undo: UndoManager?
    private var isAnimating = false {
        didSet {
            self.configureBarButtons(didChanged: self.didChanged, isAnimating: self.isAnimating, isEndRound: self.isEndRound)
        }
    }
    private var didChanged = false {
        didSet {
            self.configureBarButtons(didChanged: self.didChanged, isAnimating: self.isAnimating, isEndRound: self.isEndRound)
        }
    }
    private var isEndRound = false

    class var instance: RoundViewController {
        return UIStoryboard(name: Constants.Storyboards.main.name, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboards.main.viewControllers[self.name]!) as! RoundViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    
    private func setupData() {
        self.undo = UndoManager(receiver: self)
        self.undo?.delegate = self
        self.viewModel.setup()
    }
    
    private func setupUI() {
        self.viewModel.title.bind {[weak self] (title) in self?.navigationItem.title = title}
        self.tabBarController?.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.roundPlayersView.delegate = self
        self.unableBarButtons(excludeButtons: [self.menuBarButtonItem])
        self.roundOrderView.delegate = self
        self.roundOrderView.datasource = self
        self.view.bringSubview(toFront: roundPlayersView)
        self.viewModel.menuConfig.bind {[weak self] (enableSwap, isClockWise) in
            self?.configMenu(enableSwap: enableSwap, isClockWise: isClockWise)
        }
    }
    
    private func configureBarButtons(didChanged: Bool, isAnimating: Bool, isEndRound: Bool) {
        if didChanged && isAnimating {
            self.roundPlayersView.setDirectionImgView(isHidden: true)
            self.unableBarButtons()
        } else if didChanged && !isAnimating {
            self.roundPlayersView.setDirectionImgView(isHidden: isEndRound)
            let excludeButtons = isEndRound ? [self.undoBarButtonItem, self.resetBarButtonItem, self.saveBarButtonItem] : [self.undoBarButtonItem, self.resetBarButtonItem]
            self.unableBarButtons(excludeButtons: excludeButtons as! [UIBarButtonItem])
        } else if !didChanged && isAnimating {
            self.roundPlayersView.setDirectionImgView(isHidden: true)
            self.unableBarButtons(excludeButtons: [self.undoBarButtonItem, self.resetBarButtonItem])
        } else {
            self.roundPlayersView.setDirectionImgView(isHidden: false)
            self.unableBarButtons(excludeButtons: [self.menuBarButtonItem])
        }
    }
    
    @IBAction func clickUndo(_ sender: Any) {
        self.undo?.undo()
    }
    
    @IBAction func clickReset(_ sender: Any) {
        self.undo?.reset()
        self.isEndRound = false
    }
    
    @IBAction func clickSave(_ sender: Any) {
        self.viewModel.save()
        let newRoundVC = UIStoryboard(name: Constants.Storyboards.main.name, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboards.main.viewControllers[RoundViewController.name]!)
        guard let oldVCs = self.navigationController?.viewControllers else {return}
        var newVCs = oldVCs[0..<oldVCs.count - 1]
        newVCs.append(newRoundVC)
        self.navigationController?.viewControllers = Array(newVCs)
    }
    
    @IBAction func clickMenu(_ sender: Any) {
        self.viewModel.menuPressed()
    }
        
    @discardableResult fileprivate func addRoundOrderView(resultType: Result) -> RoundOrderView {
        self.isAnimating = true
        self.isEndRound = true
        self.roundOrderView.reloadData(resultType: resultType)
        return roundOrderView
    }
    
    fileprivate func undoResult() {
        self.isEndRound = false
        self.roundResultView.isHidden = true
        self.roundOrderView.undo()
        self.roundPlayersView.undoResult()
        self.view.bringSubview(toFront: roundPlayersView)
    }
    
    fileprivate func unableBarButtons(excludeButtons: [UIBarButtonItem] = []) {
        let allButtons = [self.undoBarButtonItem, self.resetBarButtonItem, self.saveBarButtonItem, self.menuBarButtonItem]
        allButtons
            .filter {!excludeButtons.contains($0!)}
            .forEach {$0!.isEnabled = false}
        allButtons
            .filter {excludeButtons.contains($0!)}
            .forEach {$0!.isEnabled = true}
    }
    
    fileprivate func configMenu(enableSwap: Bool, isClockWise: Bool) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let changeDirection = UIAlertAction(title: Constants.String.changeDirection, style: .default) {[weak self] (action) in
            self?.changeDirection()
        }
        
        let changePosition = UIAlertAction(title: Constants.String.changePosition, style: .default) {[weak self] (action) in
            self?.changePosition()
        }
        
        let endGame = UIAlertAction(title: Constants.String.endGame, style: .default) {[weak self] (action) in
            self?.endGame()
        }
        
        let cancel = UIAlertAction(title: Constants.String.cancel, style: .cancel, handler: nil)
        
        if enableSwap {
            actionSheet.addAction(changePosition)
        }
        actionSheet.addAction(changeDirection)
        actionSheet.addAction(endGame)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    fileprivate func endGame() {
        let confirmAlertController = UIAlertController(title: Constants.String.endGameTitle, message: Constants.String.endGameMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.String.ok, style: .default, handler: {[weak self] (action) in
            self?.viewModel.save()
            self?.comeToRoot()
        })
        let cancelAction = UIAlertAction(title: Constants.String.cancel, style: .cancel, handler: nil)
        confirmAlertController.addAction(okAction)
        confirmAlertController.addAction(cancelAction)
        self.present(confirmAlertController, animated: true, completion: nil)
    }
    
    fileprivate func changePosition() {
        let editPlayerVC = EditPlayerViewController.instance as! EditPlayerViewController
        editPlayerVC.delegate = self
        let navVC = UINavigationController(rootViewController: editPlayerVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
    fileprivate func changeDirection() {
        let confirmAlertController = UIAlertController(title: Constants.String.changeDirectionTitle, message: Constants.String.changeDirectionMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.String.ok, style: .default, handler: {[weak self] (action) in
            self?.viewModel.changeDirection()
            self?.roundPlayersView.reverse()
        })
        let cancelAction = UIAlertAction(title: Constants.String.cancel, style: .cancel, handler: nil)
        confirmAlertController.addAction(okAction)
        confirmAlertController.addAction(cancelAction)
        self.present(confirmAlertController, animated: true, completion: nil)
    }
    
    deinit {
        print("deinit")
    }
}

extension RoundViewController: RoundOrderViewDatasource {
    func roundLevelViewModel(at tag: Int) -> RoundLevelViewModel {
        return self.viewModel.roundLevelViewModel(at: tag)
    }
}

extension RoundViewController: RoundOrderViewDelegate {    
    func willDisplayLevelView(orderView: RoundOrderView, with levelView: RoundLevelView, at tag: Int, total: Int) {
        let viewMatched = self.roundPlayersView.view(at: tag)
        viewMatched?.animationToMatch(with: levelView.imgView) {[weak self] in
            guard let strongSelf = self, let roundResultViewModel = strongSelf.viewModel.roundResultViewModel, tag == total else {return}
            strongSelf.roundResultView.viewModel = roundResultViewModel
            strongSelf.view.bringSubview(toFront: strongSelf.roundResultView)
            strongSelf.roundResultView.isHidden = false
            strongSelf.isAnimating = false
        }
    }
}

extension RoundViewController: RoundPlayerViewDelegate {
    func playerDidEat(eatingPlayerIndex: Int, eatingPlayerView: UIView, atePlayerIndex: Int, atePlayerView: UIView) {
        self.undo?.addUndoCommandPlayerDidEatCard(method: RoundViewController.undoPlayerDidEat(eatingPlayerIndex:eatingPlayerView:atePlayerIndex:atePlayerView:), eatingIndex: eatingPlayerIndex, eatingView: eatingPlayerView, ateIndex: atePlayerIndex, ateView: atePlayerView)
        self.viewModel.playerDidEat(eatingPlayerIndex: eatingPlayerIndex, atePlayerIndex: atePlayerIndex) {[weak self] (times, eatType) in
            self?.roundPlayersView.setupLinkEatingView(from: eatType, times: times, eatingPlayerView: eatingPlayerView, atePlayerView: atePlayerView)
            if times == 3 {
                self?.roundPlayersView.processWhenResultIsWinLostByAteThreeCards(winView: eatingPlayerView, lostView: atePlayerView)
            }
        }
    }
    
    func playerDidEatLastCard(eatingPlayerIndex: Int, eatingPlayerView: UIView, atePlayerIndex: Int, atePlayerView: UIView) {
        self.undo?.addUndoCommandPlayerDidEatCard(method: RoundViewController.undoPlayerDidEatLastCard(eatingPlayerIndex:eatingPlayerView:atePlayerIndex:atePlayerView:), eatingIndex: eatingPlayerIndex, eatingView: eatingPlayerView, ateIndex: atePlayerIndex, ateView: atePlayerView)
        self.viewModel.playerDidEatLast(eatingPlayerIndex: eatingPlayerIndex, atePlayerIndex: atePlayerIndex) {[weak self] (times) in
            self?.roundPlayersView.setupLinkEatingView(from: .last, times: times, eatingPlayerView: eatingPlayerView, atePlayerView: atePlayerView)
            if times == 3 {
                self?.roundPlayersView.processWhenResultIsWinLostByAteThreeCards(winView: eatingPlayerView, lostView: atePlayerView)
            }
        }
    }
    
    func didEndRoundWinAll(winPlayerIndex: Int, winPlayerView: UIView, lostPlayerIndexs: [Int], lostPlayerViews: [UIView], isCircle: Bool, isDry: Bool) {
        self.undo?.addUndoCommandPlayerDidWin(method: RoundViewController.undoDidEndRoundWinAll(winPlayerIndex:winPlayerView:lostPlayerIndexs:lostPlayerViews:isCircle:isDry:), eatingIndex: winPlayerIndex, eatingView: winPlayerView, ateIndexs: lostPlayerIndexs, ateViews: lostPlayerViews, isCircle: isCircle, isDry: isDry)
        self.viewModel.didEndRoundWinAll(winPlayerIndex: winPlayerIndex, isCircle: isCircle, isDry: isDry){[weak self] in
            self?.addRoundOrderView(resultType: .winAll)
        }
    }

    func didEndRoundWinLost(winPlayerIndex: Int, winPlayerView: UIView, lostPlayerIndex: Int, lostPlayerView: UIView, ateThreeCards: Bool) {
        let confirmView = ConfirmWinView(frame: self.view.bounds, sourceWinViewTag: winPlayerIndex, sourceLostViewTag: lostPlayerIndex, ateThreeCards: ateThreeCards)
        confirmView.delegate = self
        self.view.addSubview(confirmView)
        self.isAnimating = true
        confirmView.animation(sourceWinView: winPlayerView, sourceLostView: lostPlayerView)
        confirmView.contentView.transform = CGAffineTransform.identity.scaledBy(x: 0.0001, y: 0.0001)
        UIView.animate(withDuration: 0.25, animations: {
            confirmView.contentView.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }) { (finished) in
            confirmView.contentView.transform = CGAffineTransform.identity
        }
    }
    
    func didEndRoundNormalResult(orderViews: [UIView], orderIndexs: [Int], notEatViews: [UIView], notEatIndexs: [Int]) {
        self.undo?.addUndoCommandPlayerDidEndNormalResult(method: RoundViewController.undoDidEndRoudNormalResult(orderViews:orderIndexs:notEatViews:notEatIndexs:), orderIndexs: orderIndexs, orderViews: orderViews, notEatIndexs: notEatIndexs, notEatViews: notEatViews)
        self.viewModel.didEndRoundNormal(orderIndexs: orderIndexs, notEatIndexs: notEatIndexs) {[weak self] in
            self?.addRoundOrderView(resultType: .normal(numberNotEat: notEatIndexs.count))
        }
    }
}

extension RoundViewController: ConfirmWinViewDelegate {
    func processWhenResultIsWinLost(confirmView: ConfirmWinView, winViewTag: Int, lostViewTag: Int, isCirle: Bool, ateThreeCards: Bool) {
       self.undo?.addUndoCommandPlayerDidWinLost(method: RoundViewController.undoDidEndRoundWinLost(winPlayerIndex: lostPlayerIndex: isCircle:), eatingIndex: winViewTag, ateIndex: lostViewTag, isCircle: isCirle)
        if ateThreeCards {
            self.undo?.combineCommands(numberToLast: 2)
        }
        self.viewModel.didEndRoundWinLost(winPlayerIndex: winViewTag, lostPlayerIndex: lostViewTag, isCircle: isCirle){[weak self] in
            confirmView.removeFromSuperview()
            self?.addRoundOrderView(resultType: .winLost)
        }
    }
}

extension RoundViewController {
    func undoPlayerDidEat(eatingPlayerIndex: Int, eatingPlayerView: UIView, atePlayerIndex: Int, atePlayerView: UIView) {
        self.viewModel.undoPlayerDidEat(eatingPlayerIndex: eatingPlayerIndex, atePlayerIndex: atePlayerIndex) {[weak self] (times, eatType) in
            self?.roundPlayersView.undoSetupLinkEatingView(from: eatType, times: times, eatingPlayerView: eatingPlayerView, atePlayerView: atePlayerView)
        }
    }
    
    func undoPlayerDidEatLastCard(eatingPlayerIndex: Int, eatingPlayerView: UIView, atePlayerIndex: Int, atePlayerView: UIView) {
        self.viewModel.undoPlayerDidEatLast(eatingPlayerIndex: eatingPlayerIndex, atePlayerIndex: atePlayerIndex) { [weak self] (times) in
            self?.roundPlayersView.undoSetupLinkEatingView(from: .last, times: times, eatingPlayerView: eatingPlayerView, atePlayerView: atePlayerView)
        }
    }
    
    func undoDidEndRoudNormalResult(orderViews: [UIView], orderIndexs: [Int], notEatViews: [UIView], notEatIndexs: [Int]) {
        self.viewModel.undoDidEndRoundNormal(orderIndexs: orderIndexs, notEatIndexs: notEatIndexs) {[weak self] in
            self?.undoResult()
        }
    }
    
    func undoDidEndRoundWinAll(winPlayerIndex: Int, winPlayerView: UIView, lostPlayerIndexs: [Int], lostPlayerViews: [UIView], isCircle: Bool, isDry: Bool) {
        self.viewModel.undoDidEndRoundWinAll(winPlayerIndex: winPlayerIndex, isCircle: isCircle, isDry: isDry) {[weak self] in
            self?.undoResult()
        }
    }
    
    func undoDidEndRoundWinLost(winPlayerIndex: Int, lostPlayerIndex: Int, isCircle: Bool) {
        self.viewModel.undoDidEndRoundWinLost(winPlayerIndex: winPlayerIndex, lostPlayerIndex: lostPlayerIndex, isCircle: isCircle) {[weak self] in
            self?.undoResult()
        }
    }
}

extension RoundViewController: EditPlayerViewControllerDelegate {
    func dismissViewController(animated: Bool, completion: (() -> Void)?) {
        self.dismiss(animated: animated, completion: completion)
    }
    
    func didSaveEditRule(animated: Bool, completion: (() -> Void)?) {
        self.roundPlayersView.reload()
        self.dismiss(animated: animated, completion: completion)
    }
}

extension RoundViewController: UndoManagerDelegate {
    func historyIsEmpty(isEmpty: Bool) {
        self.didChanged = !isEmpty
    }
}
