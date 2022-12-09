//
//  PhotoNoteViewController.swift
//  MixedNotesProject
//
//  Created by Полина Рыфтина on 09.12.2022.
//

import UIKit
import PhotosUI

class PhotoNoteViewController: UIViewController, PHPickerViewControllerDelegate, UITextFieldDelegate {
    private let titleTextField: UITextField = .init()
    private let imageView: UIImageView = .init()
    
    var note: Note?
    var notes: [Note]?
    weak var delegate: NotesDelegate?
    let fileManager = LocalFileManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        titleTextField.backgroundColor = .systemGray6
        titleTextField.layer.cornerRadius = 5
        titleTextField.placeholder = "Title"
        titleTextField.text = note?.text
        titleTextField.font = UIFont.systemFont(ofSize: 22)
        titleTextField.delegate = self
        
        try? imageView.image = fileManager.getPhoto(id: note?.photoName ?? "")
        
        view.addSubview(imageView)
        view.addSubview(titleTextField)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            titleTextField.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -10),
    
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 400),
            imageView.heightAnchor.constraint(equalToConstant: 450)
        ])
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "photo.on.rectangle.fill"), style: .done,
                                                            target: self, action: #selector(addPhoto))
    }
    
    private func updateNote() {
        if let notes {
            try? imageView.image = fileManager.getPhoto(id: note?.photoName ?? "")
            LocalStorageManager().saveTextNotes(notes: notes)
        }
        delegate?.refreshNotes()
    }
        
    private func deleteNote() {
        if let note {
            delegate?.deleteNote(with: note.id)
        }
        if let notes {
            LocalStorageManager().saveTextNotes(notes: notes)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = titleTextField.text  else {
            deleteNote()
            return
        }
        note?.text = text
        if note?.title.isEmpty ?? true  {
            deleteNote()
        } else {
            updateNote()
        }
    }
    
    @objc func addPhoto() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        let phPicker = PHPickerViewController(configuration: configuration)
        phPicker.delegate = self
        present(phPicker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { [self] reading, error in
                if let error {
                    print("Got error loading image: \(error)")
                } else if let image = reading as? UIImage {
                    DispatchQueue.main.async { [self] in
                        imageView.image = image
                        let fileName = UUID().uuidString
                        note?.photoName = fileName
                        try? fileManager.save(image: image, fileName: fileName)
                    }
                }
            }
        }
    }
}

