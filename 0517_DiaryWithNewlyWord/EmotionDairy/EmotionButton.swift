//
//  EmotionButton.swift
//  0517_DiaryWithNewlyWord
//
//  Created by gnksbm on 5/17/24.
//

import UIKit

final class EmotionButton: UIButton {
    private let emotionImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let messageLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.setContentHuggingPriority(
            .defaultHigh,
            for: .vertical
        )
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(model: EmotionModel) {
        emotionImageView.image = .init(named: model.imgName)
        messageLabel.text = "\(model.message) \(model.count)"
    }
    
    func prepareForReuse() {
        emotionImageView.image = nil
        messageLabel.text = nil
    }
    
    private func configureUI() {
        [emotionImageView, messageLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            messageLabel.heightAnchor.constraint(equalToConstant: 20),
            
            emotionImageView.topAnchor.constraint(equalTo: topAnchor),
            emotionImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emotionImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emotionImageView.bottomAnchor.constraint(
                equalTo: messageLabel.topAnchor
            ),
        ])
    }
}
