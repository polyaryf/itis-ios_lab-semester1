////
////  ViewController.swift
////  Networking
////
////  Created by Teacher on 29.10.2022.
////
//
//import UIKit
//
//class ViewController: UIViewController {
//    private let imageView = UIImageView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        loadImage()
//    }
//
//    private func loadImage() {
//        view.addSubview(imageView)
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            imageView.leadingAnchor
//                .constraint(equalTo: view.leadingAnchor),
//            imageView.trailingAnchor
//                .constraint(equalTo: view.trailingAnchor),
//            imageView.topAnchor
//                .constraint(
//                    equalTo: view.safeAreaLayoutGuide.topAnchor,
//                    constant: 20
//                ),
//        ])
//
//        guard
//            let imageUrl = URL(
//                string: "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/guinea-pig-1663940975.jpg"
//            )
//        else { return }
//
//        URLSession.shared
//            .dataTask(with: imageUrl) { [self] data, _, _ in
//                guard let data else {
//                    print("could not load image")
//                    return
//                }
//
//                let image = UIImage(data: data)
//                DispatchQueue.main.async { [self] in
//                    guard let image else { return }
//
//                    imageView.image = image
//                    imageView.widthAnchor
//                        .constraint(
//                            equalTo: imageView.heightAnchor,
//                            multiplier: image.size.width / image.size.height
//                        )
//                        .isActive = true
//                }
//            }
//            .resume()
//    }
//}
//
