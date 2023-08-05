import UIKit

class Canvas: UIView {
    var bezier = UIBezierPath()
    var strokeColor = UIColor.black
    var strokeWidth: CGFloat = 2.0
    
    override func draw(_ rect: CGRect) {
        strokeColor.setStroke()
        bezier.lineWidth = strokeWidth
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
        bezier.addLine(to: location)
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
