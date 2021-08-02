//
//  RecipeCollectionViewCell.swift
//  Recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/07/31.
//

import UIKit
import RxSwift
import Nuke

class RecipeCollectionViewCell: UICollectionViewCell, UICollectionViewCellAutoHeight {
    public var disposeBag = DisposeBag()
    public var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private var isFavorited: Bool = false {
        didSet {
            let icon: UIImage? = isFavorited ? UIImage(named: "heart-active") :  UIImage(named: "heart-default")
            icon?.withRenderingMode(.alwaysTemplate)
            favoriteButton.tintColor = isFavorited ? .systemPink : .white
            favoriteButton.setImage(icon, for: .normal)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        thumbnailImageView.setRatio(height: 1, width: 1)
        
        contentView.addSubview(favoriteButton)
        favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        favoriteButton.setHeight(35)
        favoriteButton.setWidth(35)
        
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setData(_ recipe: Recipe){
        if let thumbnail = URL(string: recipe.thumbnail) {
            Nuke.loadImage(with: ImageRequest(url: thumbnail), into: thumbnailImageView)
            titleLabel.text = recipe.title
            isFavorited = recipe.isFavorited
        }
    }
}
