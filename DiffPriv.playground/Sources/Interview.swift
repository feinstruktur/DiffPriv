import Foundation

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

public func createSample(trueConsumerFraction: Double, sampleSize: Int) -> [Interviewee] {
    return (0..<sampleSize).map { _ in Interviewee(hasConsumedMarijuana: random() < trueConsumerFraction) }
}

public func createSamples(trueConsumerFraction: Double, sampleSize: Int, iterations: Int) -> (responses: [Double], truths: [Double]) {
    let sampleSizeProgression = (0..<iterations).map { _ in createSample(trueConsumerFraction: trueConsumerFraction, sampleSize: sampleSize) }
    let responses = sampleSizeProgression.map { sample in yesRatio(values: sample.map { $0.response }) }
    let truths = sampleSizeProgression.map { sample in yesRatio(values: sample.map { $0.hasConsumedMarijuana }) }
    return (responses, truths)
}

