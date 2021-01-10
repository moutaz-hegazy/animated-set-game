//
//  setView.swift
//  set_card_display
//
//  Created by Moutaz_Hegazy on 3/24/20.
//  Copyright © 2020 Moutaz_Hegazy. All rights reserved.
//

import UIKit

class setView: UIView {

    
    var cards = [card_display]()
    var passIdentity : identity?
    
    var cardsHorizontalSpacing : CGFloat = 10.0
    var cardsVerticalSpacing : CGFloat = 20.0
    
    var maxCardsPerRow : Int = 2
    var numberOfRaws = 2
    
    private var cardWidth : CGFloat = 40.0
    // MARK : setup orientation.
    private var startRect : CGRect{
        var rect = CGRect()
        if UIDevice.current.orientation.isPortrait{
            rect.origin = CGPoint(x: bounds.minX + 20, y: bounds.maxY - 120)
        }else{
            rect.origin = CGPoint(x: bounds.maxX - 100, y: bounds.minY + 20)
        }
        rect.size = CGSize(width: 70, height: 100)
        return rect
    }
    
    private var pileRect : CGRect{
        var rect = CGRect()
        if UIDevice.current.orientation.isPortrait{
            rect.origin = CGPoint(x: bounds.maxX - 100, y: bounds.maxY - 120)
        }else{
            rect.origin = CGPoint(x: bounds.maxX - 100, y: bounds.maxY - 120)
        }
        rect.size = CGSize(width: 70, height: 100)
        return rect
    }
    
    private var remainingdCardsInDeck = 81{
        didSet{
            if remainingdCardsInDeck <= 0{
                cardDeckView.isHidden = true
            }
        }
    }
    
    private var matchedSets = 0{
        didSet{
            let text = centeredAttributedString("\(matchedSets)\nSets", 30.0)
            cardPile.attributedText = text
        }
    }
    
    private lazy var cardPile : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        let text = centeredAttributedString("\(matchedSets)\nSets", 30.0)
        label.attributedText = text
        
        addSubview(label)
        return label
    }()
    
    private func centeredAttributedString(_ string :String,_ fontSize :CGFloat) -> NSAttributedString{
        
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        
        return NSAttributedString(string: string, attributes: [.paragraphStyle : textStyle ,.font : font])
    }
    
    private lazy var cardDeckView : card_display = {
        let view = card_display()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Deal3Cards)))
        addSubview(view)
        return view
    }()
    
    private lazy var animator = UIDynamicAnimator(referenceView: self)
    
    lazy var rotate : UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.elasticity = 1.0
        behavior.angularResistance = 1.0
        behavior.allowsRotation = true
        animator.addBehavior(behavior)
        return behavior
    }()

    lazy var collision : UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(behavior)
        return behavior
    }()
    
    private var snapAction : UISnapBehavior?
    
    var facedDownCards : [card_display]?
    
    var selectedCards : [card_display]?{
        return cards.filter{$0.isSelected}
    }
    
    
    
    func removeMatchedCards(){
        selectedCards?.forEach{
            card in
            UIView.transition(with: card, duration: 0.5, options: [.allowAnimatedContent],
                              animations: { [weak self] in
                                self?.rotate.addItem(card)
                                self?.rotate.addAngularVelocity(10.0, for: card)
                              })
        }
        delay(0.5, closure: {
            [weak self] in
            self?.selectedCards?.forEach{ card in
                UIViewPropertyAnimator
                    .runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState,.curveEaseIn],
                    animations: {
                        card.frame = (self?.pileRect)!
                        self?.rotate.removeItem(card)
                    }, completion:{ finished in
                        self?.cards.remove(at: (self?.cards.index(of:card))!)
                        card.removeFromSuperview()
                    })
            }
        })
        matchedSets += 1
        delay(1.1, closure: {
            //displayCardsOnScreen()
            self.passIdentity?.deal3NewCards()
        })
    }
    
    private var animate = true
    
    @objc func Deal3Cards(){
        animate = false
        passIdentity?.deal3NewCards()
    }
    
    
    private func getCardsSize(){
        if (cards.count > 0){
            if(UIDevice.current.orientation.isPortrait){
                var raws = Int(ceil(sqrt(Double(cards.count))))
                var maxCardsPerRow = CGFloat(ceil(Double(cards.count)/Double(raws)))
                
                var newWidth = bounds.width / maxCardsPerRow
                let rowSpacing : CGFloat = 10 * (newWidth/bounds.width)
                let columnSpacing : CGFloat = 20 * ((newWidth * 1.6)/bounds.height)
                newWidth = (self.bounds.width - rowSpacing * (maxCardsPerRow + 1)) / maxCardsPerRow
                let height = newWidth * 1.6
                
                if bounds.height - 140 < (height * CGFloat(raws) + columnSpacing * CGFloat(raws + 1)){
                    raws -= 1
                    maxCardsPerRow = CGFloat(ceil(Double(cards.count)/Double(raws)))
                    newWidth = (self.bounds.width - rowSpacing * (maxCardsPerRow + 1)) / maxCardsPerRow
                }
                cardsHorizontalSpacing = rowSpacing
                cardsVerticalSpacing = columnSpacing
                self.maxCardsPerRow = Int(maxCardsPerRow)
                numberOfRaws = raws
                cardWidth = newWidth
            }else{
                var raws = 1
                var height = bounds.height - 30
                var width = height / 1.6
                var maxCardsPerRow = bounds.width / width
                var rawSpacing = 10.0 * (width/bounds.width)
                var columnSpacing = 20.0 * (height/bounds.height)
                
                while(bounds.width - 120 < (width * maxCardsPerRow)+((maxCardsPerRow+1)*rawSpacing)){
                    
                    raws += 1
                    height = bounds.height / CGFloat(raws)
                    columnSpacing = 20.0 * (height/bounds.height)
                    height = (bounds.height - columnSpacing * CGFloat(raws+1)) / CGFloat(raws)
                    width = height / 1.6
                    rawSpacing = 10.0 * (width/bounds.width)
                    maxCardsPerRow = CGFloat((cards.count / raws) + (cards.count % raws))
                }
                cardsHorizontalSpacing = rawSpacing
                cardsVerticalSpacing = columnSpacing
                self.maxCardsPerRow = Int(maxCardsPerRow)
                numberOfRaws = raws
                cardWidth = width
            }
        }else{}
    }
    
    func createNewCard(_ card : card_display) {
        facedDownCards = nil
        card.backgroundColor = UIColor.clear
        card.isOpaque = false
        card.passIdentity = self.passIdentity
        let tap = UITapGestureRecognizer(target: card, action: #selector(card.select_DeselectCard(_:)))
        card.addGestureRecognizer(tap)
        addSubview(card)
        cards += [card]
        remainingdCardsInDeck -= 1
    }

    
    
    func displayCardsOnScreen(){
        getCardsSize()
        for card in cards{
            if !card.isFaceUp{
                card.frame = startRect
            }
        }
        cardDeckView.frame = startRect
        cardPile.frame = pileRect
        var originPoint = CGPoint(x: bounds.minX + cardsHorizontalSpacing,
                                  y: bounds.minY + cardsVerticalSpacing)
        var cardNumberInRaw = 0
        let cardSize = CGSize(width: cardWidth, height: cardWidth*1.6)
        
        facedDownCards = cards.filter{!$0.isFaceUp}
        
        cards.forEach{
            card in
            if card.isFaceUp{
                UIView.transition(with: card, duration: 0.3, options: [.curveEaseIn],
                                  animations: {
                                        card.frame.origin = originPoint
                                        card.frame.size = cardSize
                                })
                cardNumberInRaw += 1
                if cardNumberInRaw >= self.maxCardsPerRow{
                    originPoint.x = self.bounds.minX + self.cardsHorizontalSpacing
                    originPoint.y +=  (self.cardWidth * 1.6 + self.cardsVerticalSpacing)
                    cardNumberInRaw = 0
                }else{
                    originPoint.x += (self.cardWidth + self.cardsHorizontalSpacing)
                }
            }
        }
        
        if facedDownCards != nil{
            animate = true
            nextAnimation(index: 0, cardNumberInRaw: cardNumberInRaw, originPoint: originPoint)
        }
    }
    
    func nextAnimation(index: Int, cardNumberInRaw: Int, originPoint: CGPoint) {
        var cardNumberInRaw = cardNumberInRaw
        var originPoint = originPoint
        if (index < (facedDownCards?.count)!) , animate {
            let card = (facedDownCards?[index])!
            
            let cardSize = CGSize(width: cardWidth, height: cardWidth*1.6)
            delay(0.3) {
                UIViewPropertyAnimator
                    .runningPropertyAnimator(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut],
                                             animations: {
                                                card.frame.origin = originPoint
                                                card.frame.size = cardSize
                    },completion:{
                        finished in
                        if !card.isFaceUp{
                            UIView.transition(with: card, duration: 1.0, options: [.transitionFlipFromLeft],
                                              animations: {
                                                card.isFaceUp = true
                            })
                        }
                    })
                
                cardNumberInRaw += 1
                if cardNumberInRaw >= self.maxCardsPerRow{
                    originPoint.x = self.bounds.minX + self.cardsHorizontalSpacing
                    originPoint.y +=  (self.cardWidth * 1.6 + self.cardsVerticalSpacing)
                    cardNumberInRaw = 0
                }else{
                    originPoint.x += (self.cardWidth + self.cardsHorizontalSpacing)
                }
                self.setNeedsLayout()
                self.layoutIfNeeded()
                if index != (self.facedDownCards)!.count - 1 {
                    self.nextAnimation(index: index+1, cardNumberInRaw: cardNumberInRaw, originPoint: originPoint)
                }else{
                    self.facedDownCards = nil
                }
            }
        }else{
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
}
// setttt 4848425