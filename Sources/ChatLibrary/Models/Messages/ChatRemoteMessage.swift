//
// ChatRemoteMessage.swift
// 
// 
// 

import Foundation

public class ChatRemoteMessage: ChatMessage {

    private(set) var identifier: String
    private(set) var agentName: String

    public init(_ content: String, identifier: String, agentName: String? = nil, date: Date = Date()) {
        self.identifier = identifier
        self.agentName = agentName ?? ""
        super.init(content.decodedHtmlEntities.removedHtmlTags, date: date)
    }

    public convenience init(_ info: NSDictionary) throws {
        var identifier: String
        var date: Date
        var content: String
        var agentName: String?
        if let clientId = info.value(forKeyPath: "ClientID.text") as? String {
            identifier = clientId
        } else {
            throw NSError(domain: "", code: 0, userInfo: ["reason": "'text' field does not exist in 'ClientID' field", "details": info])
        }

        if let greeting = info.value(forKeyPath: "Greeting.text") as? String {
            content = greeting
        } else if let message = info.value(forKeyPath: "Body.text") as? String {
            content = message
        } else {
            throw NSError(domain: "", code: 0, userInfo: ["reason": "No valid 'text' exists for 'Greeting' or 'Body'", "details": info])
        }

        if let name = info.value(forKeyPath: "Name.text") as? String {
            agentName = name
        }

        guard let dateText = info.value(forKeyPath: "CreatedTime.text") as? String else {
            self.init(content, identifier: identifier, agentName: agentName)
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let parsedDate = formatter.date(from: dateText) {
            date = parsedDate
        } else {
            date = Date()
        }

        self.init(content, identifier: identifier, agentName: agentName, date: date)
    }
}
