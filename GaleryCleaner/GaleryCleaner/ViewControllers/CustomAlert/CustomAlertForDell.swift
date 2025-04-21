//
//  CustomAlertForDell.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 14.04.2025.
//

import Foundation
import UIKit

final class CustomAlertForDell: UIViewController {
    
    var deleteAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    
    var alertPresenter: CustomAlertPresenter?
    
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .colorFromHex("#F2ECF2")
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title Label"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "meassage Label"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var processingImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .colorFromHex("#DAE5FE")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .colorFromHex("#F2ECF2")
        button.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .colorFromHex("#F2ECF2")
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorFromHex("#3C3C43", alpha: 0.36)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        alertPresenter?.attachView(false, view: self)
        alertPresenter?.getAlertView()
    }
    
    @objc private func handleDelete() {
        dismiss(animated: true) {
            self.deleteAction?()
        }
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true) {
            self.cancelAction?()
        }
    }
    
}

extension CustomAlertForDell: CustomAlertViewProtocol {
    func setTitleLabel(text: String) {
        self.titleLabel.text = text
    }
    
    func setMessageLabel(text: String) {
        self.messageLabel.text = text
    }
    
    func setImage(imagePath: String) {
        let image = UIImage(contentsOfFile: imagePath)
        self.processingImageView.image = image
    }
    
    func setupViews() {
        view.addSubview(alertView)
        [titleLabel, messageLabel, processingImageView].forEach {alertView.addSubview($0)}
        [deleteButton, cancelButton].forEach { bottomView.addSubview($0)}
        alertView.addSubview(bottomView)
        
        
        NSLayoutConstraint.activate([
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 270),
            alertView.heightAnchor.constraint(equalToConstant: 366),
            
            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16),
          
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16),
            
            processingImageView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            processingImageView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            processingImageView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),

            bottomView.topAnchor.constraint(equalTo: processingImageView.bottomAnchor, constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 0.5),
            cancelButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -135.25),
            cancelButton.heightAnchor.constraint(equalToConstant: 43),
            cancelButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: 0),
            
            deleteButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 0.5),
            deleteButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 135.25),
            deleteButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 43),
            deleteButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: 0)
            
        ])
    }
}

