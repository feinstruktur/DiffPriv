import UIKit
import PlaygroundSupport

let rect = CGRect(x: 0, y: 0, width: 300, height: 900)

let canvas = UIView(frame: rect)
canvas.backgroundColor = UIColor.white
PlaygroundPage.current.liveView = canvas

func createGraph(trueConsumerFraction: Double, sampleSize: Int) -> Graph {
    let graph = Graph()
    let (responses, _) = createSamples(trueConsumerFraction: trueConsumerFraction, sampleSize: sampleSize, iterations: 400)
    if let hist = Histogram(values: responses, nBins: 500, range: (0.0, 1.0)) {
        graph.ySeries = [hist.counts]
    }
    return graph
}


let size = CGSize(width: 300, height: 800)

let samples = stride(from: 1000, through: 11000, by: 2000)
Array(samples)
let truths = stride(from: 0.0, through: 1.0, by: 0.1)
Array(truths)

//let plots = samples.map { createGraph(trueConsumerFraction: 0.3, sampleSize: $0) }
let plots = truths.map { createGraph(trueConsumerFraction: $0, sampleSize: 2000) }

let stackView: UIStackView = {
    let s = UIStackView()
    s.axis = .vertical
    s.distribution = .fillEqually
    plots.forEach(s.addArrangedSubview)
    return s
}()

let container = UIStackView(frame: canvas.bounds)
container.addArrangedSubview(stackView)

canvas.addSubview(container)

func mean(_ values: [Double]) -> Double {
    return values.reduce(0, +) / Double(values.count)
}

let diffs = truths.map { truth -> Double in
    let (responses, _) = createSamples(trueConsumerFraction: truth, sampleSize: 2000, iterations: 400)
    return mean(responses) - truth
}
diffs












