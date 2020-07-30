//
//  card.swift
//  Set
//
//  Created by Moutaz_Hegazy on 2/26/20.
//  Copyright © 2020 Moutaz_Hegazy. All rights reserved.
//

import Foundation
enum number : Int{
    case one = 1
    case two = 2
    case three = 3
    
    
}

enum shape{
    case diamond
    case oval
    case squiggle
    
}
enum color{
    
    case red
    case green
    case purple
    
}
enum filling{
    
    case solid
    case striped
    case empty
    
}

struct card : Equatable{
    
   // var hashValue : Int {return cardIdentifier}
    
    static func == (lhs:card , rhs:card) ->Bool
    {
        return lhs.cardIdentifier == rhs.cardIdentifier
    }
    
    private(set) var cardShape = shape.squiggle
    private(set) var cardColor = color.red
    private(set) var cardFilling = filling.solid
    private(set) var cardShapesNumber = number.one
    
    var Font : Float {
        
        switch cardShapesNumber {
        case .one   : return 40.0
        case .two   : return 30.0
        case .three : return 23.0
        }
    }
    
    var cardPositionOnScreen : Int?
    
    var cardIsOnScreen = false
    
    var cardIsMatched = false
    
    private(set) var cardIdentifier = Int()
    
    static private var cardCounter = 0
    
    static func getIdentifier() -> Int{
        cardCounter += 1
        return cardCounter
    }
    
    init (with cardIdentifier : Int){
        //cardIdentifier = card.getIdentifier()
        self.cardIdentifier = cardIdentifier
        defineCardCharacteristics(with : cardIdentifier)
    }
    
    private  mutating func defineCardCharacteristics(with cardIdentifier : Int)
    {

            
        var singleCardIdentifier = cardIdentifier
            
        if (singleCardIdentifier <= 27){
                
            cardShape = .oval
                
        }else if (singleCardIdentifier <= 54){
            cardShape = .squiggle
            singleCardIdentifier -= 27
                
        }else if (singleCardIdentifier <= 81){
            cardShape = .diamond
            singleCardIdentifier -= 54
                
        }else{}
        
        if ( singleCardIdentifier <= 9){
            
            cardColor = .red
            
        }else if (singleCardIdentifier <= 18){
            cardColor = .green
            singleCardIdentifier -= 9
            
        }else if (singleCardIdentifier <= 27){
            cardColor = .purple
            singleCardIdentifier -= 18
        }else{}
        
        if ( singleCardIdentifier <= 3 ){
            cardFilling = .empty
        }else if( singleCardIdentifier <= 6 ){
            cardFilling = .striped
            singleCardIdentifier -= 3
            
        }else if ( singleCardIdentifier <= 9 ){
            cardFilling = .solid
            singleCardIdentifier -= 6
            
        }else{}
        
        if ( singleCardIdentifier % 3 == 0){
            cardShapesNumber = .three
            
        }else if(singleCardIdentifier % 3 == 1){
            cardShapesNumber = .one
        }else if(singleCardIdentifier % 3 == 2){
            cardShapesNumber = .two
        }else{}
        
    }
}
