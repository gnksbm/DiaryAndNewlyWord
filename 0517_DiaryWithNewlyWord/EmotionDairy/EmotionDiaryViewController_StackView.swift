//
//  EmotionDiaryViewController.swift
//  0517_DiaryWithNewlyWord
//
//  Created by gnksbm on 5/17/24.
//

import UIKit

final class EmotionDiaryViewControllerV1: UIViewController {
    private var models = EmotionModel.sampleDatas
    
    private var rowCount: Int {
        let dividedCount = models.count / 3
        return models.count % 3 == 0 ? 
        dividedCount : dividedCount + 1
    }
    
    private lazy var vStackView = {
        let hStackViews = makeHorizontalStacks()
        let vStackView = UIStackView(arrangedSubviews: hStackViews)
        vStackView.axis = .vertical
        vStackView.spacing = 10
        vStackView.distribution = .fillEqually
        return vStackView
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
    }
    
    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 0.8953794837, green: 0.8656569123, blue: 0.8229625225, alpha: 1)
        
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vStackView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        let heightRatio = CGFloat(rowCount)
        
        NSLayoutConstraint.activate([
            vStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            vStackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            vStackView.widthAnchor.constraint(
                equalTo: safeArea.widthAnchor,
                multiplier: 0.8
            ),
            vStackView.heightAnchor.constraint(
                equalTo: vStackView.widthAnchor,
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
    
    private func makeEmotionButtons() -> [EmotionButton] {
        models.indices.map { index in
            let emotion = models[index]
            let emotionButton = EmotionButton()
            emotionButton.updateUI(model: emotion)
            emotionButton.tag = index
            emotionButton.addTarget(
                self,
                action: #selector(emotionButtonTapped),
                for: .touchUpInside
            )
            return emotionButton
        }
    }
    
    private func makeHorizontalStacks() -> [UIStackView] {
        let emotionButtons = makeEmotionButtons()
        return (0...rowCount - 1).map { num in
            let minIndex = num * 3
            let maxIndex = min(minIndex + 2, models.count - 1)
            let buttonsInHStack = Array(emotionButtons[minIndex...maxIndex])
            let hStackView = UIStackView(arrangedSubviews: buttonsInHStack)
            hStackView.axis = .horizontal
            hStackView.spacing = 10
            hStackView.distribution = .fillEqually
            return hStackView
        }
    }
    
    @objc private func emotionButtonTapped(_ sender: UIButton) {
        let oldEmotion = models.remove(at: sender.tag)
        let newEmotion = toggleSwitchView.isOn ?
        oldEmotion.randomCount() : oldEmotion.increaseCount()
        models.insert(newEmotion, at: sender.tag)
        (sender as? EmotionButton)?.updateUI(model: newEmotion)
    }
}
