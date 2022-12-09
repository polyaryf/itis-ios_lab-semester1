//
//  LocalStorageManager.swift
//  NotesProject
//
//  Created by Полина Рыфтина on 03.12.2022.
//

import Foundation

class LocalStorageManager {
    
    public func saveNotes(notes: [Note]) {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(notes)
            let json = String(data: jsonData, encoding: .utf8) ?? "{}"
            let defaults = UserDefaults.standard
            defaults.set(json, forKey: "notes")
            defaults.synchronize()
        } catch {
            print(error.localizedDescription, "save")
        }
    }
    
    public func getNotes() -> [Note] {
        do{
            if UserDefaults.standard.object(forKey: "notes") == nil{
                return []
            } else {
                let json = UserDefaults.standard.string(forKey: "notes") ?? "{}"
                let jsonDecoder = JSONDecoder()
                guard let jsonData = json.data(using: .utf8) else { return [] }
                
                let notes: [Note] = try jsonDecoder.decode([Note].self, from: jsonData)
                return notes
            }
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
}
