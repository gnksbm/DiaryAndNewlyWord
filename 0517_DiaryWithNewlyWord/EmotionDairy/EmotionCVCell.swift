//
//  EmotionCVCell.swift
//  0517_DiaryWithNewlyWord
//
//  Created by gnksbm on 5/17/24.
//

import UIKit

final class EmotionCVCell: UICollectionViewCell {
    private let emotionButton = EmotionButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        emotionButton.prepareForReuse()
    }
    
    func updateUI(model: EmotionModel) {
        emotionButton.updateUI(model: model)
    }
    
    func addTarget(
        target: Any?,
        action: Selector,
        indexPath: IndexPath
    ) {
        emotionButton.addTarget(
            target,
            action: action,
            for: .touchUpInside
        )
        emotionButton.tag = indexPath.row
    }
    
    private func configureUI() {
        emotionButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emotionButton)
        
        NSLayoutConstraint.activate([
            emotionButton.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 5
            ),
            emotionButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 5
            ),
            emotionButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -5
            ),
            emotionButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -5
            ),
        ])
    }
}
