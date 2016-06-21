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

let sampleSizeProgression = stride(from: 50, to: 1000, by: 50).map { createSample(consumerFraction: fraction, size: $0) }
//let responseProgression = sampleSizeProgression.map { sample in yesRatio(values: sample.map { $0.response }) }
let truthProgression = sampleSizeProgression.map { sample in yesRatio(values: sample.map { $0.hasConsumedMarijuana }) }

func min<T: Comparable>(_ values: [T]) -> T? {
    guard values.count > 0 else { return nil }
    return values.reduce(values[0], combine: min)
}

func max<T: Comparable>(_ values: [T]) -> T? {
    guard values.count > 0 else { return nil }
    return values.reduce(values[0], combine: max)
}

func GraphCoordinateTransformer(graphRange: CGFloat, valueRange: CGFloat) -> (CGFloat) -> (CGFloat) {
    return { value in
        return graphRange - value * graphRange / valueRange
    }
}

public class Graph: UIView {

    public var y = [Double]() {
        didSet {
            self.setNeedsDisplay()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func draw(_ rect: CGRect) {
        guard
            self.y.count > 0,
//            let minimum = min(self.y),
            let maximum = max(self.y) else { return }
        let n = CGFloat(self.y.count)
        let yRange = CGFloat(maximum)
        let xStep = rect.width / n
        let gColor = UIColor.blue()
        gColor.setFill()
        var xPos: CGFloat = 0

        let toHeight = GraphCoordinateTransformer(graphRange: rect.height, valueRange: yRange)
        for val in self.y {
            let yPos = toHeight(CGFloat(val))
            let radius: CGFloat = 3.0
            let r = CGRect(x: xPos - radius, y: yPos - radius, width: 2 * radius, height: 2 * radius)
            UIBezierPath(ovalIn: r).fill()
            xPos += xStep
        }
    }

}

let graph = Graph(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
graph.y = truthProgression
graph






















































