//
//  RecipeDetailViewController.swift
//  Recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/08/02.
//

import UIKit
import RxSwift
import RxCocoa
import Nuke

class RecipeDetailViewController: UIViewController {
    public var favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 4
        
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
            favoriteImageView.tintColor = isFavorited ? .systemPink : .white
            favoriteImageView.image = icon
        }
    }
    
    var recipe: Recipe?
    
    init(recipe: Recipe) {
        super.init(nibName: nil, bundle: nil)
        self.recipe = recipe
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUILayout()
        setupUIData()
    }
    
    private func setupUILayout(){
        view.backgroundColor = .white

        view.addSubview(thumbnailImageView)
        thumbnailImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        thumbnailImageView.setRatio(height: 1, width: 1)
        
        view.addSubview(favoriteImageView)
        favoriteImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 12, paddingRight: 12, width: 35, height: 35)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: thumbnailImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12)
    }
    
    private func setupUIData(){
        if let thumbnail = URL(string: recipe?.thumbnail ?? "")  {
            Nuke.loadImage(with: ImageRequest(url: thumbnail), into: self.thumbnailImageView)
        }
        
        self.titleLabel.text = recipe?.title
        self.isFavorited = recipe?.isFavorited ?? false
    }
}
