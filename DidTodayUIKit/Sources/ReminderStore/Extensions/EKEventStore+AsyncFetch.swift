import EventKit
import Foundation

enum TodayError: Error {
    case failedReadingReminders
    case accessDenied
    case accessRestricted
    case unknown
    case reminderHasNoDueDate
}

extension EKEventStore {
    func reminders(matching predicate: NSPredicate) async throws -> [EKReminder] {
        try await withCheckedThrowingContinuation { continuation in
            fetchReminders(matching: predicate) { reminders in
                if let reminders {
                    continuation.resume(returning: reminders)
                } else {
                    continuation.resume(throwing: TodayError.failedReadingReminders)
                }
            }
        }
    }
}
