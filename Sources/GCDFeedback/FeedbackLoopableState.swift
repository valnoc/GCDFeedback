import Foundation

public protocol FeedbackLoopableState: Equatable {
    static func initial() -> Self
}
