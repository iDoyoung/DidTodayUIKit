import SwiftUI

@Observable
final class FetchedReminders {
    var isAccessReminders = false
    var items = [Reminder]()
}
