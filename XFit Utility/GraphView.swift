//
//  GraphView.swift
//  XFit Utility
//
//  Created by Sam Hopkins on 8/26/15.
//  Copyright (c) 2015 Sam Hopkins. All rights reserved.
//

import UIKit
@IBDesignable class GraphView: UIView{
    
    //1 - the properties for the gradient
    @IBInspectable var startColor: UIColor = UIColor.blueColor()
    @IBInspectable var middleColor: UIColor = UIColor.blackColor()
    @IBInspectable var endColor: UIColor = UIColor.blueColor()
    
    var samplePoints :[Double] = []
    var pointsArray :[CGPoint] = []
    override func drawRect(rect: CGRect) {
        pointsArray = []
        let width = rect.width
        let height = rect.height
        
        //set up background clipping area
        let path = UIBezierPath(roundedRect: rect,
            byRoundingCorners: UIRectCorner.AllCorners,
            cornerRadii: CGSize(width: 8.0, height: 8.0))
        path.addClip()
        
        //2 - get the current context
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, middleColor.CGColor, endColor.CGColor]
        
        //3 - set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //4 - set up the color stops
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        //5 - create the gradient
        let gradient = CGGradientCreateWithColors(colorSpace,
            colors,
            colorLocations)
        
        //6 - draw the gradient
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x:0, y:self.bounds.height)
        CGContextDrawLinearGradient(context,
            gradient,
            startPoint,
            endPoint,
            CGGradientDrawingOptions(rawValue: 0))
        
        let margin:CGFloat = 25.0
        if !(samplePoints.isEmpty){
            
        let columnXPoint = { (column:Int) -> CGFloat in
            
            let spacer = (width - margin*2 - 4) / CGFloat((self.samplePoints.count - 1))
            var x:CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        
        let topBorder:CGFloat = 60
        let bottomBorder:CGFloat = 50
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = samplePoints.maxElement()
        let minValue = samplePoints.minElement()
        let columnYPoint = { (graphPoint:Double) -> CGFloat in
            var y:CGFloat = (CGFloat(graphPoint) - CGFloat(minValue!)) / (CGFloat(maxValue!) - CGFloat(minValue!)) * graphHeight
        y = graphHeight + topBorder - y
        return y
        }
        
        // draw the line graph
        
        UIColor.blackColor().setFill()
        UIColor.blackColor().setStroke()
        
        //set up the points line
        let graphPath = UIBezierPath()
        //go to start of line
        print(samplePoints)
        graphPath.moveToPoint(CGPoint(x:columnXPoint(0),
            y:columnYPoint(samplePoints[0])))
        
        //add points for each item in the graphPoints array
        //at the correct (x, y) for the point
        for i in 1..<samplePoints.count {
            let nextPoint = CGPoint(x:columnXPoint(i),
                y:columnYPoint(samplePoints[i]))
            graphPath.addLineToPoint(nextPoint)
        }
        
        //Create the clipping path for the graph gradient
        
        //1 - save the state of the context (commented out for now)
        CGContextSaveGState(context)
        
        //2 - make a copy of the path
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        //3 - add lines to the copied path to complete the clip area
        clippingPath.addLineToPoint(CGPoint(
            x: columnXPoint(samplePoints.count - 1),
            y:height))
        clippingPath.addLineToPoint(CGPoint(
            x:columnXPoint(0),
            y:height))
        clippingPath.closePath()
        
        //4 - add the clipping path to the context
        clippingPath.addClip()
        let highestYPoint = columnYPoint(maxValue!)
        startPoint = CGPoint(x:margin, y: highestYPoint)
        endPoint = CGPoint(x:margin, y:self.bounds.height)
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions(rawValue: 0))
        CGContextRestoreGState(context)
        
        //draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        //Draw the circles on top of graph stroke
        for i in 0..<samplePoints.count {
            var point = CGPoint(x:columnXPoint(i), y:columnYPoint(samplePoints[i]))
            pointsArray.append(point)
            point.x -= 5.0/2
            point.y -= 5.0/2
            
            let circle = UIBezierPath(ovalInRect:
                CGRect(origin: point,
                    size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
        }
        
        //Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        //top line
        linePath.moveToPoint(CGPoint(x:margin, y: topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin,
            y:topBorder))
        
        //center line
        linePath.moveToPoint(CGPoint(x:margin,
            y: graphHeight/2 + topBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y:graphHeight/2 + topBorder))
        
        //bottom line
        linePath.moveToPoint(CGPoint(x:margin,
            y:height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y:height - bottomBorder))
        let color = UIColor.blackColor().colorWithAlphaComponent(0.3)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
        }
    }
}
