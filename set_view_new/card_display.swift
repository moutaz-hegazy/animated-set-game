//
//  card_display.swift
//  set_card_display
//
//  Created by Moutaz_Hegazy on 3/24/20.
//  Copyright © 2020 Moutaz_Hegazy. All rights reserved.
//

import UIKit

enum Shape{
    case diamond
    case oval
    case squiggle
}

enum Color{
    case red
    case green
    case purple
    
    var shapeColor : UIColor{
        switch self{
        case .red : return UIColor.red
        case .green : return UIColor.green
        case .purple : return UIColor.purple
        }
    }
}

enum Fill{
    case empty
    case solid
    case striped
}
class card_display: UIView {
    
    var shape : Shape = .oval
    var color : Color = .green
    var filling : Fill = .striped
    var number : Int = 3
    var cardIdentifier = 0
    var isSelected = false{
        didSet{
            if isSelected{
                self.layer.borderWidth = 30*scaleRatio
                self.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            }else{
                self.layer.borderWidth = 10*scaleRatio
                self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }
    var isFaceUp = false{
        didSet{setNeedsDisplay()}
    }
    var passIdentity : identity?

    var scaleRatio : CGFloat {
        var ratio = bounds.height/UIScreen.main.bounds.height
        if(UIDevice.current.orientation.isLandscape){
            ratio *= 0.4
        }
        return ratio
    }
    
    @objc func select_DeselectCard(_ sender: UITapGestureRecognizer){
        switch sender.state{
        case .ended : isSelected = !isSelected
        default : break
        }
        passIdentity?.getCardIdentity(cardIdentifier)
    }
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        if isFaceUp{
            let cardsSpace = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0*scaleRatio)
            UIColor.white.setFill()
            cardsSpace.fill()
            
            let segment = bounds.height/CGFloat(number)
            
            if let context = UIGraphicsGetCurrentContext(){
                
                for index in 0..<number{
                    
                    context.saveGState()
                    getShapeDrawn((CGFloat(index)+0.5)*segment)
                    context.restoreGState()
                }
            }
        }else{
            if let cardBack = UIImage(named: "cardBack"){
                cardBack.draw(in: bounds)
            }
        }
    }
    
    private func getShapeDrawn(_ y: CGFloat){
        
        switch shape{
        case .diamond : drawDiamond(fromY: y)
        case .oval : drawOval(fromY: y)
        case .squiggle : drawSquiggle(fromY: y)
        }
    }
    private func getFilling(in path : UIBezierPath){
        switch filling{
        case .empty : break
        case .solid : color.shapeColor.setFill();      path.fill()
        case .striped : path.addClip();    path.striping(with: color.shapeColor,scale : scaleRatio)
        }
    }
    
    private func drawDiamond(fromY startY : CGFloat) {
        let diamond = UIBezierPath()
        let safeZone : CGFloat = 50
        let movementInY : CGFloat = 100
//        if UIDevice.current.orientation.isLandscape{
//            safeZone = 20
//            movementInY = 40
//        }
        diamond.move(to: CGPoint(x: bounds.minX + safeZone*scaleRatio, y: startY))
        diamond.addLine(to: CGPoint(x: bounds.midX, y: startY - movementInY*scaleRatio))
        diamond.addLine(to: CGPoint(x: bounds.maxX - safeZone*scaleRatio, y: startY))
        diamond.addLine(to: CGPoint(x: bounds.midX,y: startY + movementInY*scaleRatio))
        diamond.close()
        
        
        diamond.lineWidth = 5.0 * scaleRatio
        
        color.shapeColor.setStroke()
        diamond.stroke()
        
        getFilling(in: diamond)
    }
    
    private func drawOval(fromY startY : CGFloat){
        let oval = UIBezierPath()
        
        let safeZone : CGFloat = 50
        
        let radius : CGFloat = safeZone*scaleRatio
        let safeArea = consts.HspaceToBounds * scaleRatio
        
        oval.addArc(withCenter: CGPoint(x: bounds.minX+safeArea+radius,y: startY), radius: radius,
                    startAngle: CGFloat.pi/2, endAngle: -CGFloat.pi/2, clockwise: true)
        oval.addLine(to: CGPoint(x: bounds.maxX - safeArea-radius,y: startY - radius))
        oval.addArc(withCenter: CGPoint(x: bounds.maxX-safeArea-radius,y: startY), radius: radius,
                    startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi/2, clockwise: true)
        oval.close()
        
        oval.lineWidth = 5.0 * scaleRatio
        
        color.shapeColor.setStroke()
        oval.stroke()
        getFilling(in: oval)
    }
    
    private func drawSquiggle(fromY startY : CGFloat){
        let squiggle = UIBezierPath()
        
        let safeArea = consts.HspaceToBounds * scaleRatio
        
        squiggle.move(to: CGPoint(x: bounds.minX+safeArea, y: startY))
        squiggle.addCurve(to: CGPoint(x: bounds.midX-(20*scaleRatio), y: startY - 40*scaleRatio),
                          controlPoint1: CGPoint(x: bounds.minX+(60.0*scaleRatio), y: startY-100*scaleRatio),
                          controlPoint2: CGPoint(x: bounds.minX+(150.0*scaleRatio), y: startY-70*scaleRatio))
        
        squiggle.addCurve(to: CGPoint(x: bounds.maxX-safeArea-50*scaleRatio, y: startY - 40*scaleRatio),
                          controlPoint1: CGPoint(x: bounds.midX+20*scaleRatio, y: startY),
                          controlPoint2: CGPoint(x: bounds.midX+(60*scaleRatio), y: startY-10*scaleRatio))
        
        squiggle.addCurve(to: CGPoint(x: bounds.maxX-safeArea, y: startY-40*scaleRatio),
                          controlPoint1: CGPoint(x: bounds.maxX-safeArea-30*scaleRatio, y: startY-60*scaleRatio),
                          controlPoint2: CGPoint(x: bounds.maxX-safeArea-15*scaleRatio, y: startY-100*scaleRatio))
        
        squiggle.addCurve(to: CGPoint(x: bounds.midX+80*scaleRatio, y: startY + 74.2*scaleRatio),
                          controlPoint1: CGPoint(x: bounds.midX+140.0*scaleRatio, y: startY+90*scaleRatio),
                          controlPoint2: CGPoint(x: bounds.midX+60.0*scaleRatio, y: startY+70*scaleRatio))
        
        squiggle.addCurve(to: CGPoint(x: bounds.midX-20*scaleRatio, y: startY + 60*scaleRatio),
                          controlPoint1: CGPoint(x: bounds.midX+60*scaleRatio, y: startY+80*scaleRatio),
                          controlPoint2: CGPoint(x: bounds.midX+30*scaleRatio, y: startY+90*scaleRatio))
        
        squiggle.addCurve(to: CGPoint(x: bounds.minX+safeArea+70*scaleRatio, y: startY + 30*scaleRatio),
                          controlPoint1: CGPoint(x: bounds.midX-60.0*scaleRatio, y: startY+20*scaleRatio),
                          controlPoint2: CGPoint(x: bounds.midX-80.0*scaleRatio, y: startY+30*scaleRatio))
        
        squiggle.addCurve(to: CGPoint(x: bounds.minX+safeArea, y: startY),
                          controlPoint1: CGPoint(x: bounds.minX+90.0*scaleRatio, y: startY+30*scaleRatio),
                          controlPoint2: CGPoint(x: bounds.minX+60.0*scaleRatio, y: startY+150*scaleRatio))
        
        
        squiggle.lineWidth = 5.0 * scaleRatio
        
        color.shapeColor.setStroke()
        squiggle.stroke()
        getFilling(in: squiggle)
    }
    
    struct consts{
        static let HspaceToBounds :CGFloat = 50.0
        static let VspaceToBounds :CGFloat = 100.0
    }
}

extension UIBezierPath  {
    func striping(with color : UIColor,scale : CGFloat){
        var position = self.bounds.minX
        let spacing = bounds.maxX / (100*scale)
        let line = UIBezierPath()
        color.setStroke()
        
        while position < bounds.maxX {
            position += spacing
            line.move(to: CGPoint(x: position,y: self.bounds.minY))
            line.addLine(to: CGPoint(x: position, y: self.bounds.maxY))
            line.stroke()
        }
    }
}




