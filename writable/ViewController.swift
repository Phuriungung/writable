import UIKit

class Canvas: UIView {
    var bezier = UIBezierPath()
    var strokeColor = UIColor.black
    var strokeWidth: CGFloat = 10.0
    
    override func draw(_ rect: CGRect) {
        strokeColor.setStroke()
        bezier.lineWidth = strokeWidth
        bezier.lineCapStyle = .round
        bezier.lineJoinStyle = .round
        bezier.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        bezier.move(to: location)
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let midPoint = CGPoint(x: (bezier.currentPoint.x + location.x) / 2, y: (bezier.currentPoint.y + location.y) / 2)
        bezier.addQuadCurve(to: location, controlPoint: midPoint)
        
        setNeedsDisplay()
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
