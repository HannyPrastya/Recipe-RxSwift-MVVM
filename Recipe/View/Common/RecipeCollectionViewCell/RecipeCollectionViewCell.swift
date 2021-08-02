//
//  RecipeCollectionViewCell.swift
//  Recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/07/31.
//

import UIKit
import RxSwift
import Nuke

class RecipeCollectionViewCell: UICollectionViewCell {
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
        label.font = .systemFont(ofSize: 14, weight: .bold)
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
        thumbnailImageView.anchor(
            top: contentView.topAnchor,
            left: contentView.leftAnchor,
            right: contentView.rightAnchor
        )
        thumbnailImageView.setRatio(height: 1, width: 1)
        
        contentView.addSubview(favoriteButton)
        favoriteButton.anchor(
            top: contentView.topAnchor,
            right: contentView.rightAnchor,
            paddingTop: 12,
            paddingRight: 12,
            width: 35,
            height: 35
        )
        
        contentView.addSubview(titleLabel)
        titleLabel.anchor(
            top: thumbnailImageView.bottomAnchor,
            left: contentView.leftAnchor,
            bottom: contentView.bottomAnchor,
            right: contentView.rightAnchor,
            paddingTop: 8,
            paddingLeft: 4,
            paddingRight: 4
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setData(_ recipe: Recipe){
        if let thumbnail = URL(string: recipe.thumbnail) {
            Nuke.loadImage(with: ImageRequest(url: thumbnail), into: thumbnailImageView)
            titleLabel.text = recipe.title
            titleLabel.addLineSpacing(spacingValue: 2)
            isFavorited = recipe.isFavorited
        }
    }
}
