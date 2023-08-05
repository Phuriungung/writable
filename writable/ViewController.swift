import UIKit
import CoreGraphics


class Canvas: UIView {
    
    var bezier = UIBezierPath()
    var firstPoint: CGPoint?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
                    let location = touch.location(in: self)
                        print(location)
                    firstPoint = location
                    bezier.move(to: firstPoint!)
                    
                }
        print(event?.timestamp)
        print(event?.type)
        print("\n L")
    }
    
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
                    let location = touch.location(in: self)
                    print("touch move \(location)")
                }

    }
    
    override func draw(_ rect: CGRect) {
        UIColor.black.setStroke()
        bezier.stroke()
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

