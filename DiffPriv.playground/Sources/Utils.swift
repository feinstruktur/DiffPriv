import Foundation

// random uniform [0, max[
public func random(_ max: UInt32) -> UInt32 {
    return arc4random_uniform(max + 1)
}

// random uniform [0,1[
public func random() -> Double {
    return Double(random(UINT32_MAX-1)) / Double(UINT32_MAX-1)
}

// Uniform randum number from [a, b[, where b >= a
public func random(from: Double, to: Double) -> Double {
    assert(to >= from, "upper bound must be greater than or equal to lower bound")
    return from + (to-from) * random()
}

// random True, False
public func coinIsTails() -> Bool {
    return random(1) == 1
}

// https://en.wikipedia.org/wiki/Randomized_response
public func randomizedResponse(truth: Bool) -> Bool {
    if coinIsTails() {
        return coinIsTails()
    } else {
        return truth
    }
}

public struct Interviewee {
    public let hasConsumedMarijuana: Bool

    public var response: Bool {
        return randomizedResponse(truth: self.hasConsumedMarijuana)
    }
}

public func createSample(consumerFraction: Double, size: Int) -> [Interviewee] {
    return (0..<size).map { _ in Interviewee(hasConsumedMarijuana: random() < consumerFraction) }
}

public func yesRatio(values: [Bool]) -> Double {
    let sum = values.reduce(0.0) { total, value in total + (value ? 1 : 0) }
    return sum/Double(values.count)
}

public func min<T: Comparable>(_ values: [T]) -> T? {
    guard values.count > 0 else { return nil }
    return values.reduce(values[0], combine: min)
}

public func max<T: Comparable>(_ values: [T]) -> T? {
    guard values.count > 0 else { return nil }
    return values.reduce(values[0], combine: max)
}

