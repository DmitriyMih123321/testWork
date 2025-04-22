//
//  CongratulationVC.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 14.04.2025.
//

import Foundation
import UIKit

final class CongratulationVC: UIViewController {
  
    var congratulationPresenter: CongratulationPresenter?
    var cancelAction: (() -> Void)?
    
    private lazy var bigView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var bigImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "happy")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Congratulations!"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var firstImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "stars")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var secondImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "sandTimer")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "You have deleted 10 Photos (15.1 MB)"
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var dopInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Saved 10 Minutes using Cleanup"
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var discriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Review all your videos. Sort the by size or date. See the ones that occupy the most space."
        label.textColor = UIColor.colorFromHex("#888995")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var greatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Great", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
//        button.roundCorners(.allCorners, radius: 24)
        button.layer.cornerRadius = 24
        button.backgroundColor = .colorFromHex("#0A84FF")
        button.addTarget(self, action: #selector(handleGreat), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        congratulationPresenter?.attachView(false, view: self)
        congratulationPresenter?.getCongratulationView()
    }
    
    @objc private func handleGreat() {
        dismiss(animated: true) {
            self.cancelAction?()
        }
    }
}
extension CongratulationVC: CongratulationProtocol {
     func setupViews() {
        view.addSubview(bigView)
        [bigImageView, titleLabel].forEach {bigView.addSubview($0)}
        [firstImageView,infoLabel, secondImageView, dopInfoLabel].forEach { infoView.addSubview($0)}
        bigView.addSubview(infoView)
        [discriptionLabel, greatButton].forEach {bigView.addSubview($0)}
        
        NSLayoutConstraint.activate([
            bigView.topAnchor.constraint(equalTo: view.topAnchor),
            bigView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bigView.widthAnchor.constraint(equalToConstant: view.frame.width),
//            bigView.heightAnchor.constraint(equalToConstant: view.frame.height),
            
            bigImageView.topAnchor.constraint(equalTo: bigView.topAnchor, constant: 74),
            bigImageView.leadingAnchor.constraint(equalTo: bigView.leadingAnchor, constant: 82),
            bigImageView.trailingAnchor.constraint(equalTo: bigView.trailingAnchor, constant: -81),
            bigImageView.heightAnchor.constraint(equalToConstant: 228),
            
            titleLabel.topAnchor.constraint(equalTo: bigImageView.bottomAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: bigView.leadingAnchor, constant: 17),
            titleLabel.trailingAnchor.constraint(equalTo: bigView.trailingAnchor, constant: -17),
            
            infoView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 47.14),
            infoView.leadingAnchor.constraint(equalTo: bigView.leadingAnchor, constant: 63),
            infoView.trailingAnchor.constraint(equalTo: bigView.trailingAnchor, constant: -63),

            firstImageView.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 8),
            firstImageView.widthAnchor.constraint(equalToConstant: 37.05),
            firstImageView.heightAnchor.constraint(equalToConstant: 40),
            firstImageView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 0),
            
            infoLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 0),
            infoLabel.leadingAnchor.constraint(equalTo: firstImageView.leadingAnchor, constant: 41),
            infoLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: 0),
            
            secondImageView.topAnchor.constraint(equalTo: firstImageView.bottomAnchor, constant: 65),
            secondImageView.widthAnchor.constraint(equalToConstant: 24),
            secondImageView.heightAnchor.constraint(equalToConstant: 40),
            secondImageView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 8),
            secondImageView.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -7),
            
            dopInfoLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 52),
            dopInfoLabel.leadingAnchor.constraint(equalTo: secondImageView.leadingAnchor, constant: 41),
            dopInfoLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: 0),
            dopInfoLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 0),
            
            discriptionLabel.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 36),
            discriptionLabel.leadingAnchor.constraint(equalTo: bigView.leadingAnchor, constant: 17),
            discriptionLabel.trailingAnchor.constraint(equalTo: bigView.trailingAnchor, constant: -17),
            
            greatButton.topAnchor.constraint(equalTo: discriptionLabel.bottomAnchor, constant: 51),
            greatButton.leadingAnchor.constraint(equalTo: bigView.leadingAnchor, constant: 24),
            greatButton.trailingAnchor.constraint(equalTo: bigView.trailingAnchor, constant: -24),
            greatButton.heightAnchor.constraint(equalToConstant: 60),
            greatButton.bottomAnchor.constraint(equalTo: bigView.bottomAnchor, constant: -78)
            
        ])
    }
    func setupInfoLabel(text: String) {
        self.infoLabel.text = text
    }
    
    func setupDopInfoLabel(text: String) {
        self.dopInfoLabel.text = text
    }
    
    
}
