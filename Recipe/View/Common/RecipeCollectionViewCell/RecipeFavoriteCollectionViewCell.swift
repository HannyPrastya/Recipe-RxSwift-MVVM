//
//  RecipeFavoriteCollectionViewCell.swift
//  Recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/08/02.
//

import UIKit
import RxSwift
import RxCocoa
import Nuke

class RecipeFavoriteCollectionViewCell: UICollectionViewCell {
    public var disposeBag = DisposeBag()
    
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
        }
    }

}
