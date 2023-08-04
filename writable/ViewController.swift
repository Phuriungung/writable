import UIKit

class SmoothCanvas: UIView {
    
    var lineWidth: CGFloat = 50.0 // Change this to your desired line width
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setStrokeColor(UIColor.green.cgColor)
        context.setLineWidth(lineWidth) // Set the desired line width
        context.setLineCap(.round) // Use round line cap for smoother edges
        
        lines.forEach { line in
            guard let firstPoint = line.first else { return }
            let path = UIBezierPath()
            path.move(to: firstPoint)
            
            for i in 1..<line.count {
                let endPoint = line[i]
                path.addLine(to: endPoint)
            }
            
            path.stroke()
        }
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
    let canvas = SmoothCanvas()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(canvas)
        canvas.backgroundColor = .white
        canvas.frame = view.frame
    }
}
