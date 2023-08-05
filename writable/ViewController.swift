//
//  QuadBezierCurveDrawView.swift
//  BezierCurveDrawing
//
//  Created by Nick Dalton on 2/17/17.
//

import UIKit


class QuadBezierCurveDrawView: BezierPathDrawView {

    var points = [CGPoint]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first, shouldUseTouchEventForDrawing(touch) else {
            return
        }
        
        let point = touch.preciseLocation(in: self)
        self.points.removeAll()
        self.points.append(point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first, shouldUseTouchEventForDrawing(touch) else {
            return
        }
        
        let point = touch.preciseLocation(in: self)
        self.points.append(point)
        
        if self.points.count == 4 {
            let middlePoint = CGPoint(x: (self.points[1].x + self.points[3].x) / 2.0,
                                      y: (self.points[1].y + self.points[3].y) / 2.0)
            
            currentPath()?.move(to: self.points[0])
            currentPath()?.addQuadCurve(to: middlePoint, controlPoint: self.points[1])
            
            // replace points and get ready to handle the next segment
            let lastPoint = self.points[3]
            self.points.removeAll()
            self.points.append(middlePoint)
            self.points.append(lastPoint)
            
            // This is not an optimal refresh algorithm. But it works well for short paths. And it's better than full screen refresh.
            let refreshRect = currentPath()?.bounds.insetBy(dx: -self.lineWidth, dy: -self.lineWidth) ?? self.bounds
            setNeedsDisplay(refreshRect)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, shouldUseTouchEventForDrawing(touch) else {
            return
        }
        
        // Draw remaining points
                if self.points.count == 1 {    // only one point acquired = user tapped on the screen
                    // draw "point"
                    currentPath()?.lineWidth = self.lineWidth / 2.0
                    currentPath()?.addArc(withCenter: self.points[0], radius: lineWidth / 4.0, startAngle: 0, endAngle: .pi * 2.0, clockwise: true)
                    setNeedsDisplay(CGRect(x: self.points[0].x - self.lineWidth, y: self.points[0].y - self.lineWidth,
                                           width: self.lineWidth * 2.0, height: self.lineWidth * 2.0))

                } else if self.points.count == 2 {
                    currentPath()?.move(to: self.points[0])
                    currentPath()?.addLine(to: self.points[1])
                    
                    // Create a CGRect from the two points
                    let rect = CGRect(x: min(self.points[0].x, self.points[1].x) - self.lineWidth,
                                      y: min(self.points[0].y, self.points[1].y) - self.lineWidth,
                                      width: abs(self.points[1].x - self.points[0].x) + 2 * self.lineWidth,
                                      height: abs(self.points[1].y - self.points[0].y) + 2 * self.lineWidth)
                    setNeedsDisplay(rect)
                    
                } else if self.points.count == 3 {
                    currentPath()?.move(to: self.points[0])
                    currentPath()?.addQuadCurve(to: self.points[2], controlPoint: self.points[1])
                    
                    // Create a CGRect from the three points
                    let minX = min(self.points[0].x, self.points[1].x, self.points[2].x) - self.lineWidth
                    let minY = min(self.points[0].y, self.points[1].y, self.points[2].y) - self.lineWidth
                    let maxX = max(self.points[0].x, self.points[1].x, self.points[2].x) + self.lineWidth
                    let maxY = max(self.points[0].y, self.points[1].y, self.points[2].y) + self.lineWidth
                    let rect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
                    setNeedsDisplay(rect)
                }
                
                self.points.removeAll()
                
                super.touchesEnded(touches, with: event)
    }

}
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an instance of QuadBezierCurveDrawView
        let drawView = QuadBezierCurveDrawView(frame: view.bounds)
        drawView.lineWidth = 10.0 // Set desired line width
        view.addSubview(drawView)
    }
}
