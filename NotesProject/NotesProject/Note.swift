//
//  Note.swift
//  NotesProject
//
//  Created by Полина Рыфтина on 02.12.2022.
//

import Foundation

class Note: Codable {
    var id: UUID = UUID()
    var text: String = ""
    var lastUpdated: Date = Date()
    
    var title: String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).first ?? ""
    }
        
    var descriotion: String {
        var lines = text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
        lines.removeFirst()
        return "\(lastUpdated.format()) \(lines.first ?? "")"
    }
}

extension Date {
    func format() -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(self) {
            formatter.dateFormat = "h:mm a"
        } else {
            formatter.dateFormat = "dd/MM/yy"
        }
        return formatter.string(from: self)
    }
}
