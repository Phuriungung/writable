import UIKit

class Canvas: UIView {
    
    override func draw(_ rect: CGRect) {
        // custom drawing
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(10)
        context.setLineCap(.butt)
        
        lines.forEach { (line) in
            for (i, p) in line.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
        }
        
        context.strokePath()
    }
    
    var lines = [[CGPoint]]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append([CGPoint]())
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
    }
    
    // Additional method to handle Pencil touches
    func handlePencilTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        // Only accept touches from the Apple Pencil
        if touch.type == .pencil {
            let point = touch.location(in: self)
            
            guard var lastLine = lines.popLast() else { return }
            lastLine.append(point)
            lines.append(lastLine)
            
            setNeedsDisplay()
        }
    }
    
    // Combining touch and Apple Pencil handling
    func handleTouches(_ touches: Set<UITouch>) {
        if touches.contains(where: { $0.type == .pencil }) {
            handlePencilTouches(touches)
        } else {
            guard let point = touches.first?.location(in: nil) else { return }
            
            guard var lastLine = lines.popLast() else { return }
            lastLine.append(point)
            lines.append(lastLine)
            
            setNeedsDisplay()
        }
    }
}

class ViewController: UIViewController {
    let canvas = Canvas()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(canvas)
        canvas.backgroundColor = .white
        canvas.frame = view.frame
    }
}
