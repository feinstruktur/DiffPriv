import Foundation

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

let n = 100

let sample30 = createSample(consumerFraction: 0.3, size: n)
let responses = sample30.map { $0.response }
let truth = sample30.map { $0.hasConsumedMarijuana }
yesRatio(values: responses)
yesRatio(values: truth)


