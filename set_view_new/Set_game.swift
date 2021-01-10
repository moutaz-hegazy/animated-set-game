//
//  Set_game.swift
//  Set
//
//  Created by Moutaz_Hegazy on 3/1/20.
//  Copyright © 2020 Moutaz_Hegazy. All rights reserved.
//

import Foundation

enum matchingState{
    case matching
    case notMatching
    case cardSelected
    
}

//new comment
// session git

struct set{
    
    private(set) var cards = [card]()
    
    private var lastCardOnScreen = 0
    
    //private var numberOfSelectedcards = 0
    
    private var firstSelectedCard  : card?
    private var secondSelectedCard : card?
    
    
    init(){
        for index in 1 ... 81{
            let newCard = card(with: index)
            //print("cycle no. \(index) : \(newCard.cardIdentifier)")
            cards += [newCard]
        }
        cards.shuffle()
    }
    mutating func selectCard(of cardIdentfier : Int) -> matchingState {
        
        let selectedCard = getSelectedCard(of: cardIdentfier)
        //print("selectedCard -> \(selectedCard?.cardIdentifier ?? 0)")
        if selectedCard != nil {
            if (firstSelectedCard == selectedCard){
                firstSelectedCard = nil
                return .cardSelected
            }else if (secondSelectedCard == selectedCard){
                secondSelectedCard = nil
                return .cardSelected
            }else if (firstSelectedCard == nil){
                firstSelectedCard = selectedCard
                return .cardSelected
            }else if (secondSelectedCard == nil){
                secondSelectedCard = selectedCard
                return .cardSelected
            }else{
                let matchingResult = checkCardsMatching(with : selectedCard!)
                
                if (matchingResult >= 2){
                    
                    print("a match !!!")
                    
                    getMatchedCardsOff(plus : selectedCard!)
                    
                    firstSelectedCard = nil
                    secondSelectedCard = nil
                    return .matching
                }else{
                    print("not a match!")
                    firstSelectedCard = nil
                    secondSelectedCard = nil
                    return .notMatching
                }
            }
        }
        return .notMatching
    }
    private mutating func getMatchedCardsOff(plus thirdCard : card){
        
        for card in cards{
            if (card == firstSelectedCard){
                cards.remove(at: cards.index(of: card)!)
            }
            if (card == secondSelectedCard){
                cards.remove(at: cards.index(of: card)!)
            }
            if (card == thirdCard){
                cards.remove(at: cards.index(of: card)!)
            }
        }
    }
    private func checkCardsMatching(with thirdCard : card) -> Int{
        
        var checkingValue = 0
        if (firstSelectedCard?.cardColor != secondSelectedCard?.cardColor) && (firstSelectedCard?.cardColor != thirdCard.cardColor) && (secondSelectedCard?.cardColor != thirdCard.cardColor){
            print("-> not matching color")
            checkingValue += 1
        }
        if (firstSelectedCard?.cardFilling != secondSelectedCard?.cardFilling) && (firstSelectedCard?.cardFilling != thirdCard.cardFilling) && (secondSelectedCard?.cardFilling != thirdCard.cardFilling){
            print("-> not matching filling")
            checkingValue += 1
        }
        if (firstSelectedCard?.cardShapesNumber != secondSelectedCard?.cardShapesNumber) && (firstSelectedCard?.cardShapesNumber != thirdCard.cardShapesNumber) && (secondSelectedCard?.cardShapesNumber != thirdCard.cardShapesNumber){
            checkingValue += 1
            print("-> not matching Number")
        }
        if (firstSelectedCard?.cardShape != secondSelectedCard?.cardShape) && (firstSelectedCard?.cardShape != thirdCard.cardShape) && (secondSelectedCard?.cardShape != thirdCard.cardShape){
            checkingValue += 1
            print("-> not matching shape")
        }
        return checkingValue
    }
    
    private mutating func getSelectedCard (of cardIdentifier : Int) -> card? {
        
        //print("searching with \(cardIdentifier)")
        for card in cards{
           // print("cardIdentifier = \(card.cardIdentifier)")
            if card.cardIdentifier == cardIdentifier{
               // print("card with \(card.cardIdentifier) is found")
                return card
            }
        }
        return nil
    }
    
    mutating func drawCardFromDeck() -> card?{
        if cards.count > 0{
            for index in cards.indices{
                if !cards[index].cardIsOnScreen{
                    cards[index].cardIsOnScreen = true
                    return cards[index]
                }else{}
            }
        }
        return nil
    }
	
	//mido sabry added here ya mo3tez.
}

