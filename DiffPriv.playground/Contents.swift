import UIKit

typealias ValueRange = (min: Double, max: Double)

// transform from value coordinates to graphics canvas coordinates
func ValueCoordinateTransformer(valueRange: (x: ValueRange, y: ValueRange), frame: CGRect) -> (Double, Double) -> (CGFloat, CGFloat) {
    return { (x, y) in
        return (
            frame.origin.x + CGFloat((x - valueRange.x.min) / valueRange.x.max) * frame.size.width,
            frame.size.height + frame.origin.y - CGFloat((y - valueRange.y.min) / valueRange.y.max) * frame.size.height
        )
    }
}

func randomColor() -> UIColor {
    let hue = CGFloat(random(from: 210, to: 270)/360)
    let sat = CGFloat(random(from: 0.4, to: 1))
    return UIColor(hue: hue, saturation: sat, brightness: 1.0, alpha: 1.0)
}

public class Graph: UIView {

    public var x = [Double]() {
        didSet {
            self.setNeedsDisplay()
        }
    }

    public var ySeries = [[Double]]() {
        didSet {
            self.setNeedsDisplay()
        }
    }

    public var xRange: (min: Double, max: Double)? {
        didSet {
            self.setNeedsDisplay()
        }
    }

    public var yRange: (min: Double, max: Double)? {
        didSet {
            self.setNeedsDisplay()
        }
    }

    public var colors = [UIColor]() {
        didSet {
            self.setNeedsDisplay()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func plot(canvas: CGRect, x: [Double], y: [Double], xRange: ValueRange, yRange: ValueRange, color: UIColor) {
        color.setFill()
        let toCoordinate = ValueCoordinateTransformer(valueRange: (xRange, yRange), frame: canvas)
        for val in zip(x, y) {
            let pos = toCoordinate(val.0, val.1)
            let radius: CGFloat = 3.0
            let r = CGRect(x: pos.0 - radius, y: pos.1 - radius, width: 2 * radius, height: 2 * radius)
            UIBezierPath(ovalIn: r).fill()
        }
    }

    public override func draw(_ rect: CGRect) {
        let padding: CGFloat = 10
        let canvas = rect.insetBy(dx: padding, dy: padding)
        UIColor.white().setFill()
        UIBezierPath(rect: canvas).fill()

        guard self.ySeries.count > 0 else { return }
        let counts = self.ySeries.map { $0.count }
        guard min(counts) == max(counts) else {
            print("all y series must have same length")
            return
        }
        guard counts[0] > 0 else {
            print("no values in y series")
            return
        }

        let x: [Double] = {
            if self.x.count == 0 {
                return (0..<ySeries[0].count).map { Double($0) }
            } else {
                return self.x
            }
        }()

        guard counts[0] == x.count else {
            print("x and y series must have same length")
            return
        }

        guard
            let xmin = min(x),
            let xmax = max(x) else { return }
        guard
            let ymin = min(ySeries.map { min($0)! }),
            let ymax = max(ySeries.map { max($0)! }) else { return }

        let xRange = self.xRange ?? (xmin, xmax)
        let yRange = self.yRange ?? (ymin, ymax)

        var colors = self.colors.makeIterator()
        for y in self.ySeries {
            let color = colors.next() ?? randomColor()
            plot(canvas: canvas, x: x, y: y, xRange: xRange, yRange: yRange, color: color)
        }
    }

}

let fraction = 0.3

//let n = 1
//let sample30 = createSample(consumerFraction: fraction, size: n)
//let responses = sample30.map { $0.response }
//let truth = sample30.map { $0.hasConsumedMarijuana }
//yesRatio(values: responses)
//yesRatio(values: truth)

let sampleSizeProgression = stride(from: 50, to: 1000, by: 50).map { createSample(consumerFraction: fraction, size: $0) }
let responseProgression = sampleSizeProgression.map { sample in yesRatio(values: sample.map { $0.response }) }
let truthProgression = sampleSizeProgression.map { sample in yesRatio(values: sample.map { $0.hasConsumedMarijuana }) }

let graph = Graph(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
//graph.ySeries = [
//    [0.0, 0.2, 0.3, 0.1, 0.4, 0.8],
//    [0.1, 0.4, 0.4, 0.2, 0.6, 0.9]
//]
graph.ySeries = [
    responseProgression,
    truthProgression
]
graph.colors = [UIColor.blue(), UIColor.red()]
graph.yRange = (0.0, 1.0)
graph
















































