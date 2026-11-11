import Foundation

struct ActivityTimer {
    let duration: TimeInterval
    private(set) var hasStarted = false
    private(set) var deadline: Date?
    private var pausedRemaining: TimeInterval

    init(duration: TimeInterval) {
        self.duration = max(1, duration)
        pausedRemaining = max(1, duration)
    }

    func remaining(at date: Date) -> TimeInterval {
        max(0, deadline?.timeIntervalSince(date) ?? pausedRemaining)
    }
    func progress(at date: Date) -> Double {
        hasStarted ? min(1, max(0, 1 - remaining(at: date) / duration)) : 0
    }
    mutating func start(at date: Date = .now) {
        hasStarted = true
        deadline = date.addingTimeInterval(duration)
        pausedRemaining = duration
    }
    mutating func togglePause(at date: Date = .now) {
        if deadline != nil {
            pausedRemaining = remaining(at: date)
            deadline = nil
        } else if pausedRemaining > 0 {
            deadline = date.addingTimeInterval(pausedRemaining)
        }
    }
    mutating func reset(at date: Date = .now) {
        pausedRemaining = duration
        if deadline != nil { deadline = date.addingTimeInterval(duration) }
    }
}
