import UIKit

// random uniform [0, max[
public func random(_ max: UInt32) -> UInt32 {
    return arc4random_uniform(max + 1)
}

// random uniform [0,1[
public func random() -> Double {
    return Double(random(UINT32_MAX-1)) / Double(UINT32_MAX-1)
}

// random True, False
func coinIsTails() -> Bool {
    return random(1) == 1
}

// https://en.wikipedia.org/wiki/Randomized_response
func randomizedResponse(truth: Bool) -> Bool {
    if coinIsTails() {
        return coinIsTails()
    } else {
        return truth
    }
}

struct Interviewee {
    let hasConsumedMarijuana: Bool

    var response: Bool {
        return randomizedResponse(truth: self.hasConsumedMarijuana)
    }
}

func createSample(consumerFraction: Double, size: Int) -> [Interviewee] {
    return (0..<size).map { _ in Interviewee(hasConsumedMarijuana: random() < consumerFraction) }
}

func yesRatio(values: [Bool]) -> Double {
    let sum = values.reduce(0.0) { total, value in total + (value ? 1 : 0) }
    return sum/Double(values.count)
}

let n = 1
let fraction = 0.3

let sample30 = createSample(consumerFraction: fraction, size: n)
let responses = sample30.map { $0.response }
let truth = sample30.map { $0.hasConsumedMarijuana }
yesRatio(values: responses)
yesRatio(values: truth)

//let sampleSizeProgression = stride(from: 50, to: 1000, by: 50).map { createSample(consumerFraction: fraction, size: $0) }
//let responseProgression = sampleSizeProgression.map { sample in yesRatio(values: sample.map { $0.response }) }
//let truthProgression = sampleSizeProgression.map { sample in yesRatio(values: sample.map { $0.hasConsumedMarijuana }) }

func min<T: Comparable>(_ values: [T]) -> T? {
    guard values.count > 0 else { return nil }
    return values.reduce(values[0], combine: min)
}

func max<T: Comparable>(_ values: [T]) -> T? {
    guard values.count > 0 else { return nil }
    return values.reduce(values[0], combine: max)
}

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

public class Graph: UIView {

    public var x = [Double]() {
        didSet {
            self.setNeedsDisplay()
        }
    }

    public var y = [Double]() {
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

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func draw(_ rect: CGRect) {
        guard
            self.y.count > 0 && (self.x.count == self.y.count || self.x.count == 0),
            let ymin = min(self.y),
            let ymax = max(self.y) else { return }

        let x: [Double] = {
            if self.x.count == 0 {
                return (0..<self.y.count).map { Double($0) }
            } else {
                return self.x
            }
        }()

        guard
            let xmin = min(x),
            let xmax = max(x) else { return }

        let xRange = self.xRange ?? (xmin, xmax)
        let yRange = self.yRange ?? (ymin, ymax)

        let padding: CGFloat = 10
        let canvas = rect.insetBy(dx: padding, dy: padding)
        UIColor.white().setFill()
        UIBezierPath(rect: canvas).fill()

        let gColor = UIColor.blue()
        gColor.setFill()

        let toCoordinate = ValueCoordinateTransformer(valueRange: (xRange, yRange), frame: canvas)
        for val in zip(x, self.y) {
            let pos = toCoordinate(val.0, val.1)
            let radius: CGFloat = 3.0
            let r = CGRect(x: pos.0 - radius, y: pos.1 - radius, width: 2 * radius, height: 2 * radius)
            UIBezierPath(ovalIn: r).fill()
        }
    }

}

let graph = Graph(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
graph.y = [0.0, 0.2, 0.3, 0.1, 0.4, 1.0]
graph

















































