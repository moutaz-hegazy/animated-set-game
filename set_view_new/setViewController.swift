//
//  ViewController.swift
//  set_card_display
//
//  Created by Moutaz_Hegazy on 3/24/20.
//  Copyright © 2020 Moutaz_Hegazy. All rights reserved.
//

import UIKit

protocol identity {
    func getCardIdentity(_ cardIdentifier : Int)
    func deal3NewCards()
}

class setViewController: UIViewController,identity {
    func deal3NewCards() {
        addThreeCards()
    }
    
    
    func getCardIdentity(_ cardIdentifier: Int) {
        selectedCardIdentifier = cardIdentifier
        getSelectedCards()
    }
    
    private var selectedCardIdentifier : Int?{
        didSet{
            let state = game.selectCard(of:self.selectedCardIdentifier!)
            switch state{
            case .cardSelected : print("card \(selectedCardIdentifier!) is selected")//break
            case .matching : print("matcing happend"); removeMatchedCardsFromScreen()
            case .notMatching : print("not matching cards"); UnselectCards()
            }
        }
    }
    
    var game = set()
    

    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        setGame.displayCardsOnScreen()
//    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setGame.displayCardsOnScreen()
    }
    private func removeMatchedCardsFromScreen(){
        
        setGame.removeMatchedCards()
    }
    private func UnselectCards(){
        for card in setGame.cards{
            if card.isSelected{
                card.isSelected = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for _ in 0 ..< 12{
            createNewCardView()
        }
//        setGame.displayCardsOnScreen()
    }

    @IBOutlet weak var setGame: setView!{
        didSet{
            setGame.passIdentity = self
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(addThreeCards))
            swipe.direction = [.left,.right]
            setGame.addGestureRecognizer(swipe)
            
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards(_:)))
            setGame.addGestureRecognizer(rotate)
        }
    }
    
    @objc func shuffleCards(_ sender : UIRotationGestureRecognizer){
        switch sender.state{
        case.ended : setGame.cards.shuffle()
        default : break
        }
    }
    
    @objc func addThreeCards(){
        
        for _ in 0..<3
        {
            createNewCardView()
        }
        setGame.displayCardsOnScreen()
    }
    private func createNewCardView(){
        if let card = game.drawCardFromDeck(){
            let newView = showCardOnView(card)
            setGame.createNewCard(newView)
        }
    }
    @objc func getSelectedCards(){
        
        if let selectedCard = selectedCardIdentifier{
            print("card \(selectedCard) is pressed")
        }
    }
//    private func searchForSelectedCardsInView(){
//        if
//    }
    
    private func showCardOnView(_ card : card) -> card_display{
        let view = card_display()
        switch card.cardColor{
        case .red : view.color = .red
        case .green : view.color = .green
        case .purple : view.color = .purple
        }
        switch card.cardShape{
        case .diamond : view.shape = .diamond
        case .oval : view.shape = .oval
        case .squiggle : view.shape = .squiggle
        }
        switch card.cardFilling{
        case .empty : view.filling = .empty
        case .solid : view.filling = .solid
        case .striped : view.filling = .striped
        }
        view.number = card.cardShapesNumber.rawValue
        view.cardIdentifier = card.cardIdentifier
        return view
    }
}

