//
//  NoteViewController.swift
//  NotesProject
//
//  Created by Полина Рыфтина on 30.11.2022.
//

import UIKit

class NoteViewController: UIViewController {
    private let textView: UITextView = .init()
    
    var note: Note?
    var notes: [Note]?
    weak var delegate: NotesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setup() {
        view.backgroundColor = .white
        textView.text = note?.text
        textView.font = .systemFont(ofSize: 16)
        textView.delegate = self
        
        view.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func updateNote() {
        if let notes {
            LocalStorageManager().saveNotes(notes: notes)
        }
        delegate?.refreshNotes()
    }
        
    private func deleteNote() {
        if let note {
            delegate?.deleteNote(with: note.id)
        }
        if let notes {
            LocalStorageManager().saveNotes(notes: notes)
        }
    }
}

//MARK: UITextView Delegate
extension NoteViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        note?.text = textView.text
        if note?.title.isEmpty ?? true {
            deleteNote()
        } else {
            updateNote()
        }
    }
}
