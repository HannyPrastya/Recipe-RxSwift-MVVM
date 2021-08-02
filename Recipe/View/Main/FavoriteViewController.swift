//
//  FavoriteViewController.swift
//  Recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/07/31.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteViewController: UIViewController {
    private let dataSource = DataSource()
    
    var disposeBag: DisposeBag = DisposeBag()
    var recipeViewModel: RecipeViewModel = RecipeViewModel()
    
    private lazy var favoriteCollectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 12
        let numOfColumns: CGFloat = 2
        let itemSize: CGFloat = ((UIScreen.main.bounds.width - 24 - (spacing * (numOfColumns - 1))) / numOfColumns)
        
        layout.itemSize = CGSize(width: itemSize, height: (itemSize * (4 / 3)))
        
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
    }()
   
    private lazy var favoriteCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: favoriteCollectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        
        collectionView.register(RecipeFavoriteCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: RecipeFavoriteCollectionViewCell.self))
        return collectionView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    
    private var _collection =
        BehaviorRelay<HomeCollection>(value: HomeCollection(recipes: []))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUILayout()
        setupFavoriteListCollectionView()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        recipeViewModel.refresh()
    }
    
    private func setupUILayout(){
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        view.addSubview(favoriteCollectionView)
        favoriteCollectionView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    private func setupObservers(){
        Observable
            .combineLatest(
                self.recipeViewModel.recipes,
                self.recipeViewModel.favoritedRecipes
            )
            .subscribe(onNext: { [weak self] recipes, favoriteRecipes in
                guard let self = self else { return }
                let favoriteRecipes: [Recipe] = recipes.map({ recipe in
                    guard let index = favoriteRecipes.firstIndex(where: { $0 == recipe.id }) else { return recipe }
                    
                    var recipe = recipe
                    recipe.isFavorited = true
                    recipe.sortIndex = index
                    
                    return recipe
                })
                .filter{ $0.isFavorited }
                .sorted(by: { $0.sortIndex > $1.sortIndex })
                
                self._collection.accept(HomeCollection(recipes: favoriteRecipes))
                
                self.titleLabel.text = "Total favorited recipes: \(favoriteRecipes.count)"
            })
            .disposed(by: disposeBag)
    }
    
    private func setupFavoriteListCollectionView(){
        self.favoriteCollectionView.rx
            .setDelegate(self.dataSource)
            .disposed(by: self.disposeBag)
        
        self._collection.asObservable()
            .bind(to: self.favoriteCollectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    
        self.dataSource.event
            .bind(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .tapRecipe(let recipe):
                    let recipeDetailViewController = RecipeDetailViewController(recipe: recipe)
                    
                    self.recipeViewModel.selectRecipe(recipe)
                    
                    self.navigationController?.pushViewController(recipeDetailViewController, animated: true)
                    break
                case .tapFavoriteButton(let recipe):
                    self.recipeViewModel.toggleFavoriteRecipe(recipe)
                    break
                }
            })
            .disposed(by: self.disposeBag)
    }

}

// MARK: - FAVORITE COLLECTION VIEW

extension FavoriteViewController {
    struct HomeCollection {
        var recipes: [Recipe]
    }

    enum Section {
        case recipeList(_ recipes: [Recipe])
    }

    class DataSource: NSObject, RxCollectionViewDataSourceType, UICollectionViewDelegate, UICollectionViewDataSource, SectionedViewDataSourceType {
        
        private var _event = PublishRelay<Action>()
        var event: Observable<Action> { return self._event.asObservable() }

        typealias Element = HomeCollection
        private var sections: [Section] = []
        private var collection: Element?

        private let disposeBag = DisposeBag()

        enum Action {
            case tapRecipe(Recipe)
            case tapFavoriteButton(Recipe)
        }

        func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) {
            if case .next(let element) = observedEvent {
                self.collection = element
                self.sections = []
                
                if let c = self.collection {
                    if !c.recipes.isEmpty {
                        self.sections.append(.recipeList(c.recipes))
                    }
                }
                collectionView.reloadData()
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if self.sections.isEmpty { return 0 }
            switch self.sections[section] {
            case .recipeList(let recipes):
                return recipes.count
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            switch self.sections[indexPath.section] {
            case .recipeList(let recipes):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RecipeFavoriteCollectionViewCell.self), for: indexPath) as? RecipeFavoriteCollectionViewCell else {
                    return RecipeFavoriteCollectionViewCell()
                }
                
                cell.setData(recipes[indexPath.row])
                return cell
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            switch self.sections[indexPath.section] {
            case .recipeList(let recipes):
                self._event.accept(.tapRecipe(recipes[indexPath.row]))
                break
            }
        }
        
        func model(at indexPath: IndexPath) throws -> Any {
            switch self.sections[indexPath.section] {
            case .recipeList(let recipes):
                return recipes[indexPath.row]
            }
        }
    }
}
