import Foundation

// MARK: - FeedbackLoopSystem
class FeedbackLoopSystem<TState: Equatable, TEvent> {
    typealias Feedback = (_ newState: TState, _ oldState: TState, _ action: @escaping (TEvent) -> Void) -> Void
    
    private var queue = DispatchQueue(label: "FeedbackLoopSystem_queue")
    
    private var state: TState
    private let reducer: (TState, TEvent) -> TState
    private let feedbacks: [Feedback]
    
    init(initialState: TState,
         reducer: @escaping (TState, TEvent) -> TState,
         feedbacks: [Feedback]) {
        self.state = initialState
        self.reducer = reducer
        self.feedbacks = feedbacks
    }

    func acceptEvent(_ event: TEvent) {
        queue.async { [weak self] in
            guard let __self = self else { return }
            
            let oldState = __self.state
            let newState = __self.reducer(oldState, event)
            
            guard newState != oldState else { return }
            __self.state = newState
            
            __self.feedbacks.forEach { $0(newState, oldState, { [weak self] (event) in
                self?.acceptEvent(event)
            }) }
        }
    }
}
