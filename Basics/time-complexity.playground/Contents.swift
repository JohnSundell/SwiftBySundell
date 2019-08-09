// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/time-complexity
// (c) 2019 John Sundell
// Licensed under the MIT license

import Foundation

// --- Example types used throughout this playground ---

struct User: Hashable {
    let id: UUID
}

struct Event {
    var id: UUID
    var creator: User
    var date: Date
}

struct Calendar {
    var events: [Event]
}

// --- Constant time complexity: O(1) ---

extension Calendar {
    func isFirstEvent(scheduledAfter date: Date) -> Bool {
        guard let firstEvent = events.first else {
            return false
        }

        return firstEvent.date > date
    }
}

// --- Linear time complexity: O(N) ---

extension Calendar {
    func events(scheduledAfter date: Date) -> [Event] {
        return events.filter { event in
            event.date > date
        }
    }
}

// --- Linear time complexity: O(N), because of the worst case scenario ---

extension Calendar {
    func firstEvent(scheduledAfter date: Date) -> Event? {
        return events.first(where: { event in
            event.date > date
        })
    }
}

// --- Time complexity: O(N * M) ---

extension Calendar {
    func events(createdByAnyOf users: [User]) -> [Event] {
        return events.filter { event in
            users.contains(event.creator)
        }
    }
}

// --- An optimized version of the above function, now with linear O(N) complexity ---

extension Calendar {
    func optimized_events(createdByAnyOf users: Set<User>) -> [Event] {
        return events.filter { event in
            users.contains(event.creator)
        }
    }
}

// --- Quadratic time complexity: O(N^2) ---

extension Calendar {
    func conflictingEvents() -> [Event] {
        return events.filter { event in
            events.contains(where: { otherEvent in
                guard event.id != otherEvent.id else {
                    return false
                }

                return event.date == otherEvent.date
            })
        }
    }
}

// --- An optimized version of the above function, now with O(2N) complexity ---

extension Calendar {
    func optimized_conflictingEvents() -> [Event] {
        var eventCountsForDates = [Date : Int]()

        for event in events {
            eventCountsForDates[event.date, default: 0] += 1
        }

        return events.filter { event in
            eventCountsForDates[event.date, default: 0] > 1
        }
    }
}
