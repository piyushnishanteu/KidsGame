//
//  DrawView.swift
//  Drawing
//
//  Created by Piyush Nishant on 23/05/17.
//  Copyright © 2017 Piyush Nishant. All rights reserved.
//

import UIKit

protocol drawViewDelegate:class {
    func isLineIntersect(isIntersect:Bool)
}


class DrawView: UIView {

    var isDrawing:Bool = false{
        didSet{
            self.setNeedsDisplay()
        }
    }
    var points = [CGPoint]()
    weak var delegate:drawViewDelegate?
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        guard isDrawing,points.count>0 else {
            return
        }
       /* let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
        let color = CGColor(colorSpace: colorSpace, components: components)
        context?.setStrokeColor(color!)
        //context?.addLine(to: CGPoint(x: points[1].x, y: points[1].y))
        //context?.strokePath()
        for i in 0..<points.count{
            if i == 0{
                context?.move(to: points[0])
            }else{
                context?.move(to: points[i-1])
                context?.addLine(to: points[i])
            }
//            if points.count > 2{
//                let test = getIntersectionOfLines(line1: (a: points[i-2], b: points[i-1]), line2: (a: points[i-1], b: points[i]))
//                print(test)
//            }
        
            context?.strokePath()
            
        }*/
        
        let path = UIBezierPath()
        UIColor.clear.setStroke()
        path.move(to: points[0])
        for i in 1..<points.count{
            path.addLine(to: points[i])
            path.stroke()
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock {
             self.isLineIntersect()
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1).cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.path = path.cgPath
        
        // animate it
        
        self.layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 1
        shapeLayer.add(animation, forKey: "MyAnimation")
        
        // save shape layer
        
        //self.shapeLayer = shapeLayer
        CATransaction.commit()
       
        
    }
    
    private func isLineIntersect(){
        //print(points)
        if points.count > 0{
            var isIntersect = false
            for i in 0..<(points.count-1){
                if points.count > 1{
                    
                    for j in i+1..<points.count-1{
                        let test = getIntersectionOfLines(line1: (a: points[i], b: points[i+1]), line2: (a: points[j], b: points[j+1]))
                        if test{
                            isIntersect = true
                            break
                        }
                    }
                    if isIntersect{
                        guard let delegate = self.delegate else {
                            break
                        }
                        delegate.isLineIntersect(isIntersect: true)
                        break
                    }else if !isIntersect && i == points.count - 2{
                        delegate?.isLineIntersect(isIntersect: false)
                    }
                }else{
                    break
                }
            }
        }else{
            return
        }
        
    }
    
    //MARK:Intesect of two Line
    func getIntersectionOfLines(line1: (a: CGPoint, b: CGPoint), line2: (a: CGPoint, b: CGPoint)) -> Bool {
        let distance = (line1.b.x - line1.a.x) * (line2.b.y - line2.a.y) - (line1.b.y - line1.a.y) * (line2.b.x - line2.a.x)
        if distance == 0 {
            print("error, parallel lines")
            //return CGPoint.zero
            return false
        }
        
        let u = ((line2.a.x - line1.a.x) * (line2.b.y - line2.a.y) - (line2.a.y - line1.a.y) * (line2.b.x - line2.a.x)) / distance
        let v = ((line2.a.x - line1.a.x) * (line1.b.y - line1.a.y) - (line2.a.y - line1.a.y) * (line1.b.x - line1.a.x)) / distance
        
        if (u < 0.0 || u > 1.0) {
            print("error, intersection not inside line1")
            // return CGPoint.zero
            return false
        }
        if (v < 0.0 || v > 1.0) {
            print("error, intersection not inside line2")
            //return CGPoint.zero
            return false
        }
        if line2.a == line1.b{
            return false
        }
        
        print( CGPoint(x:line1.a.x + u * (line1.b.x - line1.a.x),y: line1.a.y + u * (line1.b.y - line1.a.y)))
        return true
        
        
    }

}
