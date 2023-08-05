import UIKit

class Canvas: UIView {
    var path = UIBezierPath()
    var strokeColor = UIColor.black
    var strokeWidth: CGFloat = 10.0
    var previousPoint: CGPoint?
    var points = [CGPoint]() // Store points for Catmull-Rom spline
    
    override func draw(_ rect: CGRect) {
        strokeColor.setStroke()
        path.lineWidth = strokeWidth
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        path.move(to: location)
        previousPoint = location
        points.append(location) // Add point for Catmull-Rom spline
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let previousPoint = previousPoint else { return }
        let location = touch.location(in: self)
        
        addSmoothCurve(to: location, from: previousPoint)
        
        points.append(location) // Add point for Catmull-Rom spline
        
        self.previousPoint = location
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        points.removeAll() // Clear points when touch ends
    }
    
    private func addSmoothCurve(to endPoint: CGPoint, from startPoint: CGPoint) {
        let interpolatedPoints = interpolatePoints(p0: startPoint, p1: endPoint)
        
        for i in 1..<interpolatedPoints.count - 1 { // Adjusted iteration range
            path.addQuadCurve(to: interpolatedPoints[i],
                              controlPoint: controlPointForPoints(p0: interpolatedPoints[i - 1],
                                                                 p1: interpolatedPoints[i],
                                                                 p2: interpolatedPoints[i + 1]))
        }
    }

    
    private func interpolatePoints(p0: CGPoint, p1: CGPoint) -> [CGPoint] {
        let numInterpolatedPoints = 5 // Adjust as needed
        var points = [CGPoint]()
        
        for t in stride(from: 0.0, through: 1.0, by: 1.0 / Double(numInterpolatedPoints)) {
            let x = p0.x + (p1.x - p0.x) * CGFloat(t)
            let y = p0.y + (p1.y - p0.y) * CGFloat(t)
            points.append(CGPoint(x: x, y: y))
        }
        
        return points
    }
    
    private func controlPointForPoints(p0: CGPoint, p1: CGPoint, p2: CGPoint) -> CGPoint {
        let x = p1.x + (p0.x - p2.x) / 4.0
        let y = p1.y + (p0.y - p2.y) / 4.0
        return CGPoint(x: x, y: y)
    }
}

class ViewController: UIViewController {
    var canvas: Canvas!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvas = Canvas()
        canvas.isMultipleTouchEnabled = true
        view.addSubview(canvas)
        canvas.backgroundColor = .white
        canvas.frame = view.frame
    }
}
