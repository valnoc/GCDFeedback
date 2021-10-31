import UIKit

protocol FeedbackLoopableState: Equatable {
    static func initial() -> Self
}
