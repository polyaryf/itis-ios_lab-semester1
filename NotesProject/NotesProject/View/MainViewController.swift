//
//  MainViewController.swift
//  NotesProject
//
//  Created by Полина Рыфтина on 27.11.2022.
//

import UIKit

protocol NotesDelegate: AnyObject {
    func refreshNotes()
    func deleteNote(with id: UUID)
}

class MainViewController: UIViewController {
    private let notesTableView: UITableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    private let searchController = UISearchController()
    
    var notes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupNavigationBar()
        configureSearchBar()
    }
    
    private func setup() {
        view.backgroundColor = UIColor(cgColor: CGColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1))
        notesTableView.backgroundColor = UIColor(cgColor: CGColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1))
        notesTableView.separatorColor = .systemGray3
        view.addSubview(notesTableView)
    
        notesTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            notesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            notesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
       
        notesTableView.dataSource = self
        notesTableView.delegate = self
        
        notesTableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
        
        notes = LocalStorageManager().getNotes()
    }
    
    func setupNavigationBar() {
        let origImage = UIImage(systemName: "square.and.pencil")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: tintedImage, style: .done,
                                                           target: self, action: #selector(addNewNote))
        navigationItem.leftBarButtonItem?.tintColor = .systemBlue
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.backgroundColor = UIColor(cgColor: CGColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1))
       
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    
        title = "Notes"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func configureSearchBar() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func indexForNote(id: UUID, in list: [Note]) -> IndexPath {
        let row = Int(list.firstIndex(where: { $0.id == id }) ?? 0)
        return IndexPath(row: row, section: 0)
    }
    
    @objc func addNewNote() {
        let note = createNewNote()
        toEditNote(note: note)
    }
    
    private func toEditNote(note: Note) {
        let editNoteVC = NoteViewController()
        editNoteVC.note = note
        editNoteVC.notes = notes
        editNoteVC.delegate = self
        navigationController?.pushViewController(editNoteVC, animated: true)
    }
    
    func createNewNote() -> Note {
        let note = Note()
        notes.insert(note, at: 0)
        
        LocalStorageManager().saveNotes(notes: notes)
        notesTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        return note
    }
    
    private func deleteNoteFromStorage(_ note: Note) {
        deleteNote(with: note.id)
        LocalStorageManager().saveNotes(notes: notes)
    }
}

//MARK: TableView Configuration
extension MainViewController:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notesTableView
            .dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as! NoteTableViewCell
        cell.set(note: notes[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toEditNote(note: notes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNoteFromStorage(notes[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension MainViewController: NotesDelegate {
    func refreshNotes() {
        notes = notes.sorted { $0.lastUpdated > $1.lastUpdated }
        notes = LocalStorageManager().getNotes()
        notesTableView.reloadData()
    }
    
    func deleteNote(with id: UUID) {
        let indexPath = indexForNote(id: id, in: notes)
        notes.remove(at: indexPath.row)
        notesTableView.deleteRows(at: [indexPath], with: .automatic)
        notes.remove(at: indexForNote(id: id, in: notes).row)
    }
}
