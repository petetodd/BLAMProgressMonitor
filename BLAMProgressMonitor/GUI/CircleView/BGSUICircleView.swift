//
//  BGSUICircleView.swift
//  BLAMProgressMonitor
//
//  Created by Peter Todd Air on 08/03/2015.
//  Copyright (c) 2015 Bright Green Star. All rights reserved.
//
/*
 Create a stroked circle to give a circle shape.  Then create a second part-circle with a wider line width.
 The 2nd circle is a progress indicator e..g if the progress is 10% then the 2nd cirle will only go 10% around
 the 1st circle.
 
 Core graphics is Lower left origin based (LLO) but UIKit is Upper left origin based (ULO)
 
 // start angle and end angle, measured in radians where zero is horizontally to the right—the “positive x-axis”
 
 */

import UIKit

class BGSUICircleView: UIView {
    var lineWidth : NSNumber!
    var percentageComplete : NSNumber!
    var indicatorArcColor : UIColor!
    var fillColor : UIColor!
    var fillAlpha : Float!
   
    var lblText = ""
    // Percent Display
    var showPercentage = false
    var fontNamePercent = "Arial"
    var fontsizePercent : Float = 45
    // Label text
    var fontNameLabel = "Arial"
    var fontsizeLabel : Float = 25


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
   override func drawRect(rect: CGRect) {
        // Populate defaults if required
        if lineWidth == nil{
            lineWidth = NSNumber(integer: 1)
        }
        
        if indicatorArcColor == nil{
            indicatorArcColor = UIColor.redColor()
        }
        
        if fillAlpha == nil{
            fillAlpha = 1
        }
        
        if fillColor == nil{
            fillColor = UIColor.lightGrayColor()
        }
        
        let fillColorWithAlpha = fillColor.colorWithAlphaComponent(CGFloat(fillAlpha))

        if percentageComplete == nil{
            percentageComplete = 0
        }
    
        // Drawing code
        let ctx = UIGraphicsGetCurrentContext()
        // X value
        let x = self.frame.size.width/2;
        let y = self.frame.size.height/2;
        
        var widthLine : Float = 1;

        if (self.lineWidth.floatValue > 1){
            widthLine = self.lineWidth.floatValue;
        }
        // Radius - we want as big a circle as will fit centered in the view
        var radius : Float = (min(Float(self.frame.size.width), Float(self.frame.size.height)))/2;
        
        
        
        radius = radius - (widthLine / 2);
        // Staert angle
        //  float startAngle = (180 * M_1_PI)/180;
        
        /* a UIView flips the Y-coordinate by scaling the Y values by -1. In a flipped coordinate system, specifying a clockwise arc results in a counterclockwise arc after the transformation is applied.
         4.71 = Midday (1.5 M_PI)
         1.75 = 6 (0.5 M_PI)
         6.28 = 3 (2 M_PI) - max value (radius = 2 M_PI)
         3.14 = 9 (M_PI)
         If midday is 4.71 and 6 is 1.75 and 3 is 6.28(max) then need to work out how to represent percentage after midday.
         So 1/4 past = ((2 * M_PI) / 4) + 4.71
         */
        let startAngle = 4.71;
        
        var endAngleArc : Float = 0;
        if (Float(self.percentageComplete) > 0){
            endAngleArc = ((2 * Float(M_PI)) * Float(self.percentageComplete)) + 4.71;
        }
        
        
        
        // end angle
        let endAngle = 2 * M_PI; // Used for outline 360 circle
        
        
        CGContextSetLineWidth(ctx, CGFloat(widthLine));
        
        //  CGContextSetRGBFillColor(ctx,  0.5, 1, 0.5, 1.0);
        
        CGContextAddArc(ctx, x, y, CGFloat(radius), 0, CGFloat(endAngle), 1);
        //set the fill or stroke color
        CGContextSetFillColorWithColor(ctx,fillColorWithAlpha.CGColor);
           //fill or draw the path
        CGContextFillPath(ctx);
        
        // Give the circle and outline
        CGContextSetLineWidth(ctx, 3);
        CGContextSetRGBStrokeColor(ctx, 0.7, 0.7, 0.7, 1.0);
        CGContextAddArc(ctx, x, y, CGFloat(radius), 0, CGFloat(endAngle), 0);
        CGContextDrawPath(ctx, .Stroke);
        
        if (endAngleArc > 0){
            // Stroke the path
            CGContextSetLineWidth(ctx, CGFloat(widthLine));
            CGContextSetStrokeColorWithColor(ctx, indicatorArcColor.CGColor);
            // CGContextSetRGBStrokeColor(ctx, 0.5, 1, 0.5, 1.0);
            
            CGContextAddArc(ctx, x, y, CGFloat(radius), CGFloat(startAngle), CGFloat(endAngleArc), 0)
            CGContextDrawPath(ctx, .Stroke);
        }
    // Draw any label in the bottom quarter of the view
    let yPt = (rect.height / 2)
    let rectText = CGRect(x: 0, y: yPt, width: rect.width, height: (rect.width / 2))
    attributedTextDraw(rectText)
    
    if showPercentage == true{
        // Draw any label in the bottom quarter of the view
        let rectPercentage = CGRect(x: 0, y: 0, width: rect.width, height: ((rect.width / 4) * 3))
        attributedTextPercentageCompleteDraw(rectPercentage)

    }
    
    
    }
    
    // Add text if required
    private func attributedTextDraw(rect: CGRect) {
        let font = UIFont(name: fontNameLabel, size: CGFloat(fontsizeLabel))

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        
        
        var multipleAttributes = [String : NSObject]()
        multipleAttributes[NSParagraphStyleAttributeName] = paragraphStyle
        multipleAttributes[NSFontAttributeName] = font
        
        let size: CGSize = NSString(string: lblText).sizeWithAttributes(multipleAttributes)
        
        let r = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - size.height)/2.0,
                           rect.size.width, size.height)
        
        let attribString = NSAttributedString(
            string: lblText,
            attributes: multipleAttributes
        )

        attribString.drawInRect(r)

    }
    
    private func attributedTextPercentageCompleteDraw(rect: CGRect) {
        
        let font = UIFont(name: fontNamePercent, size: CGFloat(fontsizePercent))
     
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        
        var multipleAttributes = [String : NSObject]()
        multipleAttributes[NSParagraphStyleAttributeName] = paragraphStyle
        multipleAttributes[NSFontAttributeName] = font

//        var attributes = [NSParagraphStyleAttributeName:paragraphStyle]
  
        let percentage = percentageComplete.floatValue * 100
        let strPercentNbr = String(format: "%.2f",percentage)
        let strPercent = String("\(strPercentNbr)%")

        let size: CGSize = NSString(string: strPercent).sizeWithAttributes(multipleAttributes)
        let r = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - size.height)/2.0,
                           rect.size.width, size.height)
        
        
        let attribString = NSAttributedString(
            string: strPercent,
            attributes: multipleAttributes
        )
        
        attribString.drawInRect(r)

        
    }



}


