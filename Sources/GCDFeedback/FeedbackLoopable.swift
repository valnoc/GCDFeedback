import Foundation

protocol FeedbackLoopable: AnyObject {
    associatedtype TState: FeedbackLoopableState
    associatedtype TEvent
    
    var feedbackLoopSystem: FeedbackLoopSystem<TState, TEvent>? { get set }
    
    static func reduce(state: TState, event: TEvent) -> TState
    func feedbacks() -> [FeedbackLoopSystem<TState, TEvent>.Feedback]
}

extension FeedbackLoopable {
    func driveFeedbackLoopSystem() {
        feedbackLoopSystem = .init(initialState: TState.initial(),
                                   reducer: Self.reduce,
                                   feedbacks: feedbacks())
    }
}
