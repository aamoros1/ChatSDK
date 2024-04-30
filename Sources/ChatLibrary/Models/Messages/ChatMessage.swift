//
// ChatMessage.swift
// 
// 
//

import Foundation
import Observation

@Observable
public class ChatMessage: Comparable {

    private(set) var date: Date
    private(set) var uuid: UUID
    private(set) var content: String

    /**
     Formatter for the date's timestamp representation. Formats only the time in "short" format
     */
    @ObservationIgnored
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    var timestamp: String {
        formatter.string(from: date)
    }

    public init(_ content: String, date: Date = Date()) {
        uuid = UUID()
        self.date = date
        self.content = content
    }
}

public func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
    lhs.uuid == rhs.uuid
}

public func < (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
    lhs.date < rhs.date
}
