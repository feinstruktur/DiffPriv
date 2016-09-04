import UIKit


func createGraph(sampleSize: Int) -> Graph {
    let graph = Graph()
    let (responses, _) = createSamples(trueConsumerFraction: 0.3, sampleSize: sampleSize, iterations: 100)
    if let hist = Histogram(values: responses, nBins: 50, range: (0.3, 0.5)) {
        graph.ySeries = [hist.counts]
    }
    return graph
}


let size = CGSize(width: 300, height: 800)

let samples = stride(from: 1000, through: 10000, by: 2000)
Array(samples)

let columns = 2
let plots = samples.map { createGraph(sampleSize: $0) }
let plotsPerRow = stride(from: 0, through: plots.count, by: columns).map { start in
     Array(plots[start..<(start + columns < plots.count ? start + columns : plots.count)])
}
let stackViews: [UIStackView] = plotsPerRow.map { row in
    let s = UIStackView()
    s.axis = .horizontal
    s.distribution = .fillEqually
    row.forEach(s.addArrangedSubview)
    return s
}
let canvas = UIStackView(frame: CGRect(x: 0, y: 0, width: 100 * stackViews.count, height: 400))
canvas.distribution = .fillEqually
canvas.axis = .vertical
stackViews.forEach(canvas.addArrangedSubview)
canvas



















