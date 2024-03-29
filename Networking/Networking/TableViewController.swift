//
//  TableViewController.swift
//  Networking
//
//  Created by Teacher on 29.10.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet private var customImageView: UIImageView!
    @IBOutlet private var customTextLabel: UILabel!
    
    var loadingTask: Task<Void, Never>?
    
    func set(text: String, imageUrl: URL) {
        customTextLabel.text = text
        loadingTask?.cancel()
        loadingTask = Task {
            await loadImage(url: imageUrl)
        }
    }
    
    @MainActor
        private func loadImage(url: URL) async {
            customImageView.image = nil
            let urlRequest = URLRequest(
                url: url,
                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData
            )
            do {
                let (data, _) = try await URLSession.shared.data(for: urlRequest)
                guard !Task.isCancelled else { return }
                customImageView.image = UIImage(data: data)
            } catch {
                print(error)
            }
        }
}

class TableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var array: [JsonData] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            await loadJson(url: URL(string: "https://reqres.in/api/users")!)
        }
    }
    
    @MainActor
    private func loadJson(url: URL) async {
        let urlRequest = URLRequest(url: url)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(ParseStruct.self, from: data)
            self.array = jsonData.data
        } catch {
            print("could not load json")
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
         array.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView
                .dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                as? TableViewCell
        else {
            fatalError("Could not deque cell")
        }

        let data = array[indexPath.row]
        cell.set(text: data.first_name, imageUrl: data.avatar)
        return cell
    }
}
