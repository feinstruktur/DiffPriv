import Foundation

public typealias ValueRange = (min: Double, max: Double)

public struct Histogram {
    public let nBins: Int
    public let range: ValueRange
    public let binSize: Double
    private var _counts: [Double]

    public var counts: [Double] {
        return _counts
    }

    public init?(values: [Double], nBins: Int, range: ValueRange? = nil) {
        guard values.count > 0 else { return nil }
        self.nBins = nBins
        self.range = range ?? (min(values)!, max(values)!)
        self.binSize = (self.range.max - self.range.min) / Double(nBins)
        guard self.binSize > 0 else { return nil }
        self._counts = Array<Double>(repeating: 0.0, count: nBins)
        for value in values {
            let bin = self.findBin(value)
            print(bin)
            self._counts[bin] = self._counts[bin] + 1.0
        }
    }

    private func findBin(_ value: Double) -> Int {
        if value == self.range.max {
            // make the last bin closed or else we'll return nBins
            return self.nBins - 1
        } else {
            return Int((value - self.range.min) / self.binSize)
        }
    }
}
