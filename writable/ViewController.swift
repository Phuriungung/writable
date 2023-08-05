import UIKit

class Canvas: UIView {
    var path = UIBezierPath()
    var strokeColor = UIColor.black
    var strokeWidth: CGFloat = 10.0
    var previousPoint: CGPoint?
    
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
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let previousPoint = previousPoint else { return }
        let location = touch.location(in: self)
        
        addSmoothCurve(to: location, from: previousPoint)
        self.previousPoint = location
        
        setNeedsDisplay()
    }
    
    private func addSmoothCurve(to endPoint: CGPoint, from startPoint: CGPoint) {
        let controlPoint = CGPoint(x: startPoint.x + (endPoint.x - startPoint.x) / 3,
                                   y: startPoint.y + (endPoint.y - startPoint.y) / 3)
        
        path.addQuadCurve(to: endPoint, controlPoint: controlPoint)
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
