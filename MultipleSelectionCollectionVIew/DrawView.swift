//
//  DrawView.swift
//  Drawing
//
//  Created by Piyush Nishant on 23/05/17.
//  Copyright © 2017 Piyush Nishant. All rights reserved.
//

import UIKit

class DrawView: UIView {

    var isDrawing:Bool = false{
        didSet{
            self.setNeedsDisplay()
        }
    }
    var points = [CGPoint]()
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        guard isDrawing else {
            return
        }
        let context = UIGraphicsGetCurrentContext()
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
            context?.strokePath()
        }
//        let path = UIBezierPath()
//        UIColor.black.setStroke()
//        path.move(to: points[0])
//        for i in 1..<points.count{
//            path.addLine(to: points[i])
//            path.stroke()
//        }
    }
    

}
