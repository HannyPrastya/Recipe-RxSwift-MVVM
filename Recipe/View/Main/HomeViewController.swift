//
//  HomeViewController.swift
//  Recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/07/31.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    private let dataSource = DataSource()
    
    var disposeBag: DisposeBag = DisposeBag()
    var recipeViewModel: RecipeViewModel = RecipeViewModel()
    
    private lazy var HomeCollectionViewLayout: UICollectionViewFlowLayout = {
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
   
    private lazy var homeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: HomeCollectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        
        collectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: RecipeCollectionViewCell.self))
        return collectionView
    }()
    
    private var _collection =
        BehaviorRelay<HomeCollection>(value: HomeCollection(recipes: []))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUILayout()
        setupRecipeListCollectionView()
        
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        recipeViewModel.refresh()
    }
    
    private func setupUILayout() {
        view.addSubview(homeCollectionView)
    }
    
    private func setupObservers() {
        self.recipeViewModel
            .addFavoriteResult
            .drive(onNext: { [weak self] result in
                switch result {
                case .success(let recipe):
                    guard let self = self else { return }
                    self.presentAlert(title: "Alert", message: "I added \(recipe.title) to my favorites.")
                    break
                case .failure(_):
                    break
                }
            })
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                self.recipeViewModel.recipes,
                self.recipeViewModel.favoritedRecipes
            )
            .subscribe(onNext: { [weak self] recipes, favoriteRecipes in
                guard let self = self else { return }
                self._collection.accept(HomeCollection(recipes: recipes.map({ recipe in
                    var recipe = recipe
                    recipe.isFavorited = favoriteRecipes.contains(recipe.id)
                    return recipe
                })))
            })
            .disposed(by: disposeBag)
    }
    
    private func setupRecipeListCollectionView(){
        self.homeCollectionView.rx
            .setDelegate(self.dataSource)
            .disposed(by: self.disposeBag)
        
        self._collection.asObservable()
            .bind(to: self.homeCollectionView.rx.items(dataSource: self.dataSource))
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

// MARK: - HOME COLLECTION VIEW

extension HomeViewController {
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
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RecipeCollectionViewCell.self), for: indexPath) as? RecipeCollectionViewCell else {
                    return RecipeCollectionViewCell()
                }
                
                cell.setData(recipes[indexPath.row])
                cell.favoriteButton
                    .rx.tap
                    .bind(onNext: { [weak self] _ in
                        guard let self = self else { return }
                        self._event.accept(.tapFavoriteButton(recipes[indexPath.row]))
                    })
                    .disposed(by: cell.disposeBag)
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
