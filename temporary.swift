import SwiftUI

struct ContentView: View {
    @State private var points: [CGPoint] = []
    var b = 1
    @State private var integerValue: Int = 10
    @State private var stringValue: String = "0"
    @State private var showPaths = true
    
    
    
    var body: some View {
        
        VStack {
            TextField("Enter an integer", text: $stringValue)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
            
            Toggle("Show Paths", isOn: $showPaths)
            
            Button("Convert and Update") {
                if let newValue = Int(stringValue) {
                    integerValue = newValue
                }
            }
            
            Button("Clear lines")  {
                points.removeAll()
            }
            
            Text("Entered Integer: \(integerValue)")
            
            
            GeometryReader { geometry in
                ZStack {
                    Color.white
                    Path { path in
                        //                    if points.count % 4 == 0 && points.count != 0 {
                        //
                        //                        var a = points.count - 3
                        //
                        //                        if a != 1 {
                        //                            let connectcontrol = CGPoint(x: (points[a-1].x+points[a-2].x)/2 , y: (points[a-1].y+points[a-2].y)/2)
                        //                            points[a-1] = connectcontrol
                        //                        }
                        //
                        //                        path.move(to: points[a-1])
                        //                        let ucontrol1 = CGPoint(x: points[a].x , y: points[a].y)
                        //                        let ucontrol2 = CGPoint(x: points[a+1].x , y: points[a+1].y)
                        //                        path.addCurve(to: points[a-1], control1: ucontrol1, control2: ucontrol2)
                        
                        path.move(to: CGPoint(x: 100, y: 500))
                        path.addCurve(
                            to: CGPoint(x:200, y: 100),
                            control1: CGPoint(x: 75, y: 0),
                            control2: CGPoint(x: 75, y: 100))
                        path.addLine(to: CGPoint(x: 200, y: 500))
                        path.closeSubpath()
                        
                        
                        //                    if points.count >= 3 {
                        //                        path.addCurve(to: points[2], control1: points[0], control2: points[1])
                        //                    }
                        
                        
                        //                    if points.count >= 6{
                        //
                        //                        var middle3 = CGPoint(x: (points[1].x+points[3].x)/2, y: (points[1].y+points[3].y)/2)
                        //
                        //
                        //
                        //                        path.addCurve(to: middle3, control1: points[0], control2: points[1])
                        //
                        //
                        //                        path.addCurve(to: points[5], control1: points[3], control2: points[4])
                        //                        }
                        
                        //                    if points.count >= 9{
                        //
                        //                        var middle2 = CGPoint(x: (points[1].x+points[3].x)/2, y: (points[1].y+points[3].y)/2)
                        //                        var middle5 = CGPoint(x: (points[4].x+points[6].x)/2, y: (points[4].y+points[6].y)/2)
                        //
                        //
                        //
                        //                        path.addCurve(to: middle2, control1: points[0], control2: points[1])
                        //
                        //
                        //                        path.addCurve(to: middle5, control1: points[3], control2: points[4])
                        //
                        //                        path.addCurve(to: points[8], control1: points[6], control2: points[7])
                        //                        }
                        
                        //                    var a = 9
                        //
                        //                    if points.count >= 9{
                        //
                        //                        var middle2 = CGPoint(x: (points[1].x+points[3].x)/2, y: (points[1].y+points[3].y)/2)
                        //                        var middle5 = CGPoint(x: (points[4].x+points[6].x)/2, y: (points[4].y+points[6].y)/2)
                        //
                        //
                        //                        path.addCurve(to: middle2, control1: points[0], control2: points[1])
                        //
                        //                        path.addCurve(to: middle5, control1: points[3], control2: points[4])
                        //
                        //                        path.addCurve(to: points[8], control1: points[6], control2: points[7])
                        //                        }
                        
                        var num = integerValue
                        
                        if points.count >= num {
                            for i in 1...(num-1)/3 {
                                var m = 3 * i
                                path.addCurve(to: CGPoint(x: (points[m-2].x+points[m].x)/2, y: (points[m-2].y+points[m].y)/2), control1: points[m-3], control2: points[m-2])
                                
                            }
                        }
                        for allpoint in points {
                            print(allpoint)
                        }
                    }
                    
                    .stroke(Color.blue, lineWidth: 2)
                    .background(Color.white)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            let point = value.location
                            points.append(point)
                            print("change \(points)")
                            
                        })
                            .onEnded({ _ in
                                //                                points.removeAll()
                            }))
                    
                    Path { path in
                        
                        path.move(to: CGPoint(x: 700, y: 1000))
                        path.addCurve(
                            to: CGPoint(x:200, y: 800),
                            control1: CGPoint(x: 75, y: 0),
                            control2: CGPoint(x: 75, y: 100))
                        path.addLine(to: CGPoint(x: 700, y: 500))
                        path.closeSubpath()
                        
                    }
                    
                    .stroke(Color.red, lineWidth: 5)
                    //                    .background(Color.blue)
                    
                    ForEach(1...10, id: \.self) { i in
                        Path { path in
                            path.move(to: CGPoint(x: i, y: 1000))
                            path.addCurve(
                                to: CGPoint(x: 100 * i * i, y: 800),
                                control1: CGPoint(x: 75, y: 0),
                                control2: CGPoint(x: 75, y: 100))
                            path.addLine(to: CGPoint(x: 700, y: 500))
                            path.closeSubpath()
                        }
                        .stroke(Color.green, lineWidth: CGFloat(i))
                    }
                    
                    
                    
                    if showPaths {
                        ForEach(1...10, id: \.self) { i in
                            Path { path in
                                
                                path.move(to: CGPoint(x: 200, y: 300))
                                
                                
                                
                                //                            path.addLine(to: CGPoint(x: 500, y: 1000))
                                
                                //                            if points.count >= 2 {
                                //                                path.addLine(to: points[1])
                                //                            }
                                
//                                if points.count >= 9{
//
//                                    var middle2 = CGPoint(x: (points[1].x+points[3].x)/2, y: (points[1].y+points[3].y)/2)
//                                    var middle5 = CGPoint(x: (points[4].x+points[6].x)/2, y: (points[4].y+points[6].y)/2)
//
//
//
//                                    path.addCurve(to: middle2, control1: points[0], control2: points[1])
//
//
//                                    path.addCurve(to: middle5, control1: points[3], control2: points[4])
//
//                                    path.addCurve(to: points[8], control1: points[6], control2: points[7])
//                                }
                                
                                var num = integerValue
                                
                                if points.count >= num {
                                    for i in 1...(num-1)/3 {
                                        var m = 3 * i
                                        path.addCurve(to: CGPoint(x: (points[m-2].x+points[m].x)/2, y: (points[m-2].y+points[m].y)/2), control1: points[m-3], control2: points[m-2])
                                        
                                    }
                                }
                                
                            }
                            .stroke(Color.black, lineWidth: CGFloat(20))
                        }
                    }
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

