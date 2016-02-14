//
//  PersonGraphics.swift
//  simpleTableView
//
//  Created by bob.ashmore on 14/02/2016.
//  Copyright © 2016 bob.ashmore. All rights reserved.
//

import UIKit

enum textAlignTypes {
    case ctAlignTopLeft
    case ctAlignTopCenter
    case ctAlignTopRight
    case ctAlignCenterLeft
    case ctAlignCenterCenter
    case ctAlignCenterRight
    case ctAlignBottomLeft
    case ctAlignBottomCenter
    case ctAlignBottomRight
}

// Global Functions for generating the thumbnail image for a person
// This function returns an optional
func drawPersonThumnail(initials:String) -> UIImage? {
    
    let rgbColorSpace:CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
    if let context:CGContextRef = CGBitmapContextCreate(nil, 50, 50, 8, 0, rgbColorSpace, CGImageAlphaInfo.NoneSkipFirst.rawValue) {
        CGContextSetLineWidth(context, 1.5)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextTranslateCTM(context, 25, 25)
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextSetRGBFillColor(context, 1.0, 0, 0, 1.0)
        CGContextFillRect(context, CGRectMake(-25, -25, 50, 50))
        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0)
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        
        CGContextMoveToPoint(context, -19 , 10)
        CGContextAddLineToPoint(context, 19, 10)
        CGContextStrokePath(context)
        drawNormalText(initials, context: context, origin: CGPointMake(0, 0), x1: 0, y1: 0, align: .ctAlignCenterCenter, fontName: "Helvetica", fontSize: 18, textColor: UIColor.whiteColor())
        
        if let cgImage:CGImageRef = CGBitmapContextCreateImage(context) {
            let newImage:UIImage = UIImage(CGImage:cgImage)
            return newImage
        }
        else {
            return nil
        }
    }
    else {
        return nil
    }
}

func measureLine(line: CTLineRef, context: CGContextRef) ->CGSize {
    var textHeight: CGFloat = 0.0
    var ascent:CGFloat = 0.0
    var descent:CGFloat = 0.0
    var leading:CGFloat = 0.0
    var width:Double = 0.0
    
    width = CTLineGetTypographicBounds(line, &ascent,  &descent, &leading)
    textHeight = floor(ascent * 0.8)
    return CGSizeMake(ceil(CGFloat(width)), ceil(textHeight))
}

func drawNormalText(text:String, context:CGContextRef, origin:CGPoint, x1:CGFloat, y1:CGFloat, align:textAlignTypes, fontName:String, fontSize:CGFloat, textColor:UIColor) {
    CGContextSaveGState(context)
    
    let shadowColor = UIColor(red:0.151, green:0.152, blue:0.151, alpha:1.000)
    CGContextSetShadowWithColor(context, CGSizeMake(1, 1), 0, shadowColor.CGColor)
    CGContextTranslateCTM(context, origin.x, origin.y) // move origin to center
    CGContextScaleCTM(context, 1.0, -1.0) // Reverse Y axis only
    
    // Create an attributed string
    let fontRef = CTFontCreateWithName(fontName, fontSize, nil)
    let attributes = [ NSFontAttributeName: fontRef, NSForegroundColorAttributeName: textColor ]
    let attString = NSAttributedString(string: text, attributes: attributes)
    
    // Create a text line from the attributed string
    let line:CTLineRef = CTLineCreateWithAttributedString(attString)
    let runArray = ((CTLineGetGlyphRuns(line) as [AnyObject]) as! [CTRunRef])
    let lineMetrics:CGSize = measureLine(line,context:context)
    for runIndex in 0..<CFArrayGetCount(runArray) {
        let run: CTRunRef = runArray[runIndex]
        var textMatrix:CGAffineTransform = CTRunGetTextMatrix(run)
        switch (align) {
        case .ctAlignTopLeft:
            textMatrix.tx = x1
            textMatrix.ty = y1 - lineMetrics.height
            
        case .ctAlignTopCenter:
            textMatrix.tx = x1 + (lineMetrics.width / 2.0)
            textMatrix.ty = y1 - lineMetrics.height
            
        case .ctAlignTopRight:
            textMatrix.tx = x1 + lineMetrics.width
            textMatrix.ty = y1 - lineMetrics.height
            
        case .ctAlignCenterLeft:
            textMatrix.tx = x1
            textMatrix.ty = y1 - (lineMetrics.height / 2.0)
            
        case .ctAlignCenterCenter:
            textMatrix.tx = x1 - (lineMetrics.width / 2.0)
            textMatrix.ty = y1 - (lineMetrics.height / 2.0)
            
        case .ctAlignCenterRight:
            textMatrix.tx = x1 - lineMetrics.width
            textMatrix.ty = y1 - (lineMetrics.height / 2.0)
            
        case .ctAlignBottomLeft:
            textMatrix.tx = x1
            textMatrix.ty = y1
            
        case .ctAlignBottomCenter:
            textMatrix.tx = x1 - (lineMetrics.width / 2.0)
            textMatrix.ty = y1
            
        case .ctAlignBottomRight:
            textMatrix.tx = x1 - lineMetrics.width
            textMatrix.ty = y1
            
        }
        CGContextSetTextMatrix(context, textMatrix)
        CTRunDraw(run, context, CFRangeMake(0, 0))
    }
    CGContextRestoreGState(context)
}
