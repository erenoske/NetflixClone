//
//  PopUpViewController.swift
//  Netflix Clone
//
//  Created by eren on 4.04.2024.
//

import UIKit

class PopupViewController: UIViewController {
    
    let popupText: String
    
    init(popupText: String) {
        self.popupText = popupText
        super.init(nibName: nil, bundle: nil)
    }
    
    private let popupView: UIView = {
       
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let label: UILabel = {
       
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = popupText
        
        popupView.addSubview(label)
        view.addSubview(popupView)
        
        applyConstraints()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    private func applyConstraints() {
        
        let popupViewConstraints = [
            popupView.widthAnchor.constraint(equalToConstant: 300),
            popupView.heightAnchor.constraint(equalToConstant: 200),
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        let labelConstraints = [
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 260)
        ]
        
        NSLayoutConstraint.activate(popupViewConstraints)
        NSLayoutConstraint.activate(labelConstraints)
    }
}
