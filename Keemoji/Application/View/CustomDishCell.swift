//
//  CustomDishCell.swift
//  Keemoji
//
//  Created by Alexander on 14.02.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import UIKit

class CustomDishCell: UITableViewCell {

    var dish: Dish? {
        didSet {
            dishImage.image = dish?.photo
            dishTitleLabel.text = dish?.title
            dishDescriptionLabel.text = dish?.description
        }
    }
    
    private let dishImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let dishTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let dishDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(dishImage)
        addSubview(dishTitleLabel)
        addSubview(dishDescriptionLabel)
        
        dishImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 0, width: 90, height: 0)
        dishTitleLabel.anchor(top: topAnchor, left: dishImage.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: -10, width: 0, height: 0)
        dishDescriptionLabel.anchor(top: dishTitleLabel.bottomAnchor, left: dishImage.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: -10, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

