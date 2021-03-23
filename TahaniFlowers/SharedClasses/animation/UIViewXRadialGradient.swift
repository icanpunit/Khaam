//
//  UIViewXRadialGradient.swift
//  DesignableXTesting
//
//  Created by Mark Moeykens on 1/27/17.
//  Copyright © 2017 Moeykens. All rights reserved.
//

import UIKit

@IBDesignable
class UIViewXRadialGradient: UIView {
    
    @IBInspectable var InsideColor: UIColor = UIColor.clear
    @IBInspectable var OutsideColor: UIColor = UIColor.clear
    
    override func draw(_ rect: CGRect) {
        let colors = [InsideColor.cgColor, OutsideColor.cgColor] as CFArray
        let endRadius = min(frame.width, frame.height) / 2
        let radialCenter = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        UIGraphicsGetCurrentContext()!.drawRadialGradient(gradient!, startCenter: radialCenter, startRadius: 0.0, endCenter: radialCenter, endRadius: endRadius, options: CGGradientDrawingOptions.drawsAfterEndLocation)
    }
}


@IBDesignable
 class ZigZiagView: UIImageView {

   override func draw(_ rect: CGRect) {
        super.draw(rect)

         zigZagShape()
    }

    func zigZagShape() {

        let width = self.frame.size.width
        let height = self.frame.size.height
        //let givenFrame = self.frame

        let zigZagWidth = CGFloat(6)
        let zigZagHeight = CGFloat(4)

        var yInitial = height-zigZagHeight
        let zigZagPath = UIBezierPath()
        zigZagPath.move(to: CGPoint(x:0, y:0))
        zigZagPath.addLine(to: CGPoint(x:0, y:yInitial))

        var slope = -1
        var x = CGFloat(0)
        var i = 0
        while x < width {
            x = zigZagWidth * CGFloat(i)
            let p = zigZagHeight * CGFloat(slope)
            let y = yInitial + p
            let point = CGPoint(x: x, y: y)
            zigZagPath.addLine(to: point)
            slope = slope*(-1)
            i += 1
        }

        zigZagPath.addLine(to: CGPoint(x:width,y: 0))

       // draw the line from top right to Bottom
        zigZagPath.addLine(to: CGPoint(x:width,y:height))

        yInitial = 0 + zigZagHeight
        x = CGFloat(width)
        i = 0
        while x > 0 {
            x = width - (zigZagWidth * CGFloat(i))
            let p = zigZagHeight * CGFloat(slope)
            let y = yInitial + p
            let point = CGPoint(x: x, y: y)
            zigZagPath.addLine(to: point)
            slope = slope*(-1)
            i += 1
        }

     // Now Close the path
        zigZagPath.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = zigZagPath.cgPath
        self.layer.mask = shapeLayer
    }

}

@IBDesignable
class UIImageViewWithMask: UIImageView {
    var maskImageView = UIImageView()

    @IBInspectable
    var maskImage: UIImage? {
        didSet {
            maskImageView.image = maskImage
            updateView()
        }
    }

    // This updates mask size when changing device orientation (portrait/landscape)
    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }

    func updateView() {
        if maskImageView.image != nil {
            maskImageView.frame = bounds
            mask = maskImageView
        }
    }
}

public class applyZigZagEffect: UIImageView {


    required public init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

       
         let width = self.frame.size.width + 100
               let height = self.frame.size.height
               //let givenFrame = self.frame

               let zigZagWidth = CGFloat(6)
               let zigZagHeight = CGFloat(4)

               var yInitial = height-zigZagHeight
               let zigZagPath = UIBezierPath()
               zigZagPath.move(to: CGPoint(x:0, y:0))
               zigZagPath.addLine(to: CGPoint(x:0, y:yInitial))

               var slope = -1
               var x = CGFloat(0)
               var i = 0
               while x < width {
                   x = zigZagWidth * CGFloat(i)
                   let p = zigZagHeight * CGFloat(slope)
                   let y = yInitial + p
                   let point = CGPoint(x: x, y: y)
                   zigZagPath.addLine(to: point)
                   slope = slope*(-1)
                   i += 1
               }

               zigZagPath.addLine(to: CGPoint(x:width,y: 0))

              // draw the line from top right to Bottom
               zigZagPath.addLine(to: CGPoint(x:width,y:height))

               yInitial = 0 + zigZagHeight
               x = CGFloat(width)
               i = 0
               while x > 0 {
                   x = width - (zigZagWidth * CGFloat(i))
                   let p = zigZagHeight * CGFloat(slope)
                   let y = yInitial + p
                   let point = CGPoint(x: x, y: y)
                   zigZagPath.addLine(to: point)
                   slope = slope*(-1)
                   i += 1
               }

            // Now Close the path
               zigZagPath.close()

               let shapeLayer = CAShapeLayer()
               shapeLayer.path = zigZagPath.cgPath
               self.layer.mask = shapeLayer
    }

}

