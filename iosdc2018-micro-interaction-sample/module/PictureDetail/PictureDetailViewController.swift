//
//  PictureDetailViewController.swift
//  iosdc2018-micro-interaction-sample
//
//  Created by kiwi on 2018/08/26.
//  Copyright © 2018年 kiwi26. All rights reserved.
//

import UIKit

class PictureDetailViewController: UIViewController {

    @IBOutlet var titleView: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    var pictureItem: PictureListItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        if let pictureItem = pictureItem {
            navigationItem.title = pictureItem.title
            imageView.image = UIImage(named: pictureItem.imageName)
        }
        
        // モーダル表示したときの戻るボタン
        if navigationController == nil {
            let button = UIButton(type: .system)
            button.setTitle("×", for: .normal)
            button.backgroundColor = UIColor.white
            button.setTitleColor(UIColor.darkGray, for: .normal)
            button.clipsToBounds = true
            button.layer.cornerRadius = 22
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
            view.addSubview(button)
            view.addConstraints([
                button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                button.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
                button.widthAnchor.constraint(equalToConstant: 44),
                button.heightAnchor.constraint(equalToConstant: 44)
                ])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        if let pictureItem = pictureItem {
            titleView.text = pictureItem.title
            descriptionLabel.text = pictureItem.description
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
