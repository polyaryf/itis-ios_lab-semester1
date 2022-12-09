//
//  LocalFileManager.swift
//  MixedNotesProject
//
//  Created by Полина Рыфтина on 09.12.2022.
//

import Foundation
import UIKit

enum NoteServiceError: Error {
    case fileNotFound
    case couldNotReadFile
    case couldNotCreateFileName
    case couldNotCreateImageData
}


class LocalFileManager {
    private let fileManager: FileManager
    private let documentsDirectory: URL
    private let noteExtension: String = "json"
    private let imageExtension: String = "png"
    
    init() {
        fileManager = .default

        guard let documentsDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("Could not load documents directory")
        }
        self.documentsDirectory = documentsDirectory
        print("Initialized documents directory at \(documentsDirectory.path())")
    }
    
    func save(image: UIImage, fileName: String) throws {
        guard let data = image.pngData() else {
            throw NoteServiceError.couldNotCreateImageData
        }
        guard let imageTitle = encode(string: "\(fileName).\(imageExtension)") else {
            throw NoteServiceError.couldNotCreateFileName
        }

        let path = documentsDirectory.appending(path: imageTitle).path()
        fileManager.createFile(atPath: path, contents: data)
    }
    
    private func encode(string: String) -> String? {
        string.addingPercentEncoding(
            withAllowedCharacters: .init(charactersIn: " ()")
                .union(.urlPathAllowed)
        )
    }
    
    func getPhoto(id: String) throws -> UIImage {
        let path = documentsDirectory.appending(path: "\(id).\(imageExtension)").path()
        guard fileManager.fileExists(atPath: path) else {
            throw NoteServiceError.fileNotFound
        }
     
        guard let data = fileManager.contents(atPath: path) else {
            throw NoteServiceError.couldNotReadFile
        }
        print("get data")
        return  UIImage(data: data) ?? UIImage(systemName: "square")!
    }
}
