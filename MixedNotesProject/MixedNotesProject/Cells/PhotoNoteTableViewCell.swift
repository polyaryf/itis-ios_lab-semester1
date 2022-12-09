//
//  PhotoNoteTableViewCell.swift
//  MixedNotesProject
//
//  Created by Полина Рыфтина on 09.12.2022.
//

import UIKit

class PhotoNoteTableViewCell: UITableViewCell {
    static let identifier = "PhotoNoteCell"
    
    private var titleLabel: UILabel = .init()
    private var photoNameLabel: UILabel = .init()
    
    func set(note: Note) {
        titleLabel.text = note.title
        photoNameLabel.text = note.descriotion
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        titleLabel.font = .boldSystemFont(ofSize: 16)
        photoNameLabel.font = .systemFont(ofSize: 14)
        photoNameLabel.textColor = .systemGray
        
        let stackView = UIStackView(
            arrangedSubviews: [ titleLabel, photoNameLabel]
        )
        stackView.spacing = 2
        stackView.axis = .vertical
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
}
