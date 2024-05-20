//
//  ViewController_CollectionView.swift
//  0517_DiaryWithNewlyWord
//
//  Created by gnksbm on 5/17/24.
//

import UIKit
/*
 snapshot의 animatingDifferences가 켜져있으면 연속 탭 반응이 느림
 뷰가 변경되는동안 입력되는 탭은 무시되는 듯
 StackView와 CollectionView가 화면에 보이는 만큼만 아이템을 가질 때 
 성능 차이는 어떻게 될까
 */
final class EmotionDiaryViewControllerV2: UIViewController {
    private var models: [EmotionModel] = EmotionModel.sampleDatas {
        willSet {
            updateSnapshot(models: newValue)
        }
    }
    
    private var rowCount: Int {
        let dividedCount = models.count / 3
        return models.count % 3 == 0 ? 
        dividedCount : dividedCount + 1
    }
    
    private var dataSource: DataSource!
    
    private lazy var collectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeCollectionViewLayout()
        )
        return collectionView
    }()
    
    private let toggleSwitchView = {
        let switchView = UISwitch()
        switchView.onTintColor = .black
        return switchView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
        setDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSnapshot(models: models)
    }
    
    private func configureUI() {
        collectionView.backgroundColor = #colorLiteral(red: 0.8953794837, green: 0.8656569123, blue: 0.8229625225, alpha: 1)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        let heightRatio = CGFloat(rowCount)
        
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),
            collectionView.centerYAnchor.constraint(
                equalTo: safeArea.centerYAnchor
            ),
            collectionView.widthAnchor.constraint(
                equalTo: safeArea.widthAnchor,
                multiplier: 0.8
            ),
            collectionView.heightAnchor.constraint(
                equalTo: collectionView.widthAnchor,
                multiplier: heightRatio / 3
            ),
        ])
    }
    
    private func configureNavigation() {
        let descriptionButton = UIBarButtonItem(
            title: "랜덤",
            style: .plain,
            target: nil,
            action: nil
        )
        descriptionButton.tintColor = .black
        descriptionButton.isEnabled = false
        navigationItem.rightBarButtonItems = [
            .init(customView: toggleSwitchView),
            descriptionButton
        ]
    }
    
    @objc private func emotionButtonTapped(_ sender: UIButton) {
        let oldEmotion = models.remove(at: sender.tag)
        let newEmotion = toggleSwitchView.isOn ?
        oldEmotion.randomCount() : oldEmotion.increaseCount()
        models.insert(newEmotion, at: sender.tag)
        (sender as? EmotionButton)?.updateUI(model: newEmotion)
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, EmotionModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, EmotionModel>
}
// MARK: CollectionView
extension EmotionDiaryViewControllerV2 {
    private func updateSnapshot(models: [EmotionModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(models)
        dataSource.apply(snapshot)
    }
    
    private func makeCollectionViewLayout(
    ) -> UICollectionViewCompositionalLayout {
        let hGroupHeightRatio = 1 / CGFloat(self.rowCount)
        return .init { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1/3),
                    heightDimension: .fractionalHeight(1)
                )
            )
            let hGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(hGroupHeightRatio)
                ),
                subitems: [item]
            )
            let vGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                ),
                subitems: [hGroup]
            )
            return NSCollectionLayoutSection(group: vGroup)
        }
    }
    
    private func setDataSource() {
        let cellRegistration = makeCellRegistration()
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
    }
    
    private func makeCellRegistration(
    ) -> UICollectionView.CellRegistration<EmotionCVCell, EmotionModel> {
        .init { cell, indexPath, itemIdentifier in
            cell.updateUI(model: itemIdentifier)
            cell.addTarget(
                target: self,
                action: #selector(self.emotionButtonTapped),
                indexPath: indexPath
            )
        }
    }
    
}
