//
//  ReviewSinglePhotoVC.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 17.04.2025.
//

import Foundation
import UIKit

final class ReviewSinglePhotoVC: UIViewController {
    var reviewPresenter: ReviewSinglePhotoPresenter?

    var cancelAction: (() -> Void)?
    private var switchTemp: Bool = false
    
    private lazy var bigView: UIControl = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 1, alpha: 0)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(tapOnView), for: .touchUpInside)
        return view
    }()
    private lazy var bigImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 24
        button.backgroundColor = .colorFromHex("#0A84FF")
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override func viewDidLoad() {
        reviewPresenter?.attachView(false, view: self)
        reviewPresenter?.getReviewView()
    }
 
    @objc private func handleBack() {
        dismiss(animated: true) {
            self.cancelAction?()
        }
    }
    @objc private func tapOnView() {
        
        self.backButton.isHidden = self.switchTemp
        self.switchTemp = !self.switchTemp
        
    }
}
extension ReviewSinglePhotoVC: ReviewSinglePhotoProtocol {
   
    func setupView() {
        bigView.addSubview(backButton)
        [bigImageView, bigView].forEach{view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            
            bigImageView.topAnchor.constraint(equalTo: view.topAnchor),
            bigImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bigImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bigImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            bigView.topAnchor.constraint(equalTo: view.topAnchor),
            bigView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bigView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bigView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.bottomAnchor.constraint(equalTo: bigView.bottomAnchor, constant: -78),
            backButton.leadingAnchor.constraint(equalTo: bigView.leadingAnchor, constant: 24),
            backButton.trailingAnchor.constraint(equalTo: bigView.trailingAnchor, constant: -24),
            backButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    func setupImage(_ withPath: String) {
        if let image = UIImage(contentsOfFile: withPath) {
            self.bigImageView.image = image
        }
    }
}
