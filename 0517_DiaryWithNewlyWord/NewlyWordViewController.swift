//
//  NewlyWordViewController.swift
//  0517_DiaryWithNewlyWord
//
//  Created by gnksbm on 5/17/24.
//

import UIKit

final class NewlyWordViewController: UIViewController {
    let newlyWordDic = [
        "얼죽아": "얼어 죽어도 아이스커피",
        "스불재": "스스로 불러온 재앙",
        "슬세권": "슬리퍼처럼 편한 복장으로 나다닐 수 있는 범위",
        "복세편살": "복잡한 세상 편하게 살자",
        "낄낄빠빠": "낄 때 끼고 빠질 때 빠지자"
    ]

    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var resultLabel: UILabel!
    
    lazy var suggestionStackView = {
        let wordButtons = newlyWordDic.keys.map { word in
            makeWordButton(word: word)
        }
        let stackView = UIStackView(arrangedSubviews: wordButtons)
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureHideKeyboardOnTap()
    }
    
    private func configureUI() {
        inputTextField.layer.borderWidth = 2
        
        suggestionStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(suggestionStackView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            suggestionStackView.topAnchor.constraint(
                equalTo: inputTextField.bottomAnchor,
                constant: 20
            ),
            suggestionStackView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: 20
            ),
            suggestionStackView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -20
            ),
        ])
    }
    
    private func configureHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(
            self,
            action: #selector(hideKeyboard)
        )
    }
    
    private func updateResultLabel(text: String?) {
        let resultText = newlyWordDic[text ?? ""] ?? "검색결과가 없습니다"
        resultLabel.text = resultText
    }
    
    private func makeWordButton(word: String) -> UIButton {
        let button = UIButton()
        button.setTitle(
            word,
            for: .normal
        )
        button.setTitleColor(
            .black,
            for: .normal
        )
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.addTarget(
            self,
            action: #selector(wordButtonTapped),
            for: .touchUpInside
        )
        return button
    }
    
    @IBAction func textFieldEnterPressed(_ sender: Any) {
        updateResultLabel(text: inputTextField.text)
    }
    
    @objc private func hideKeyboard(_ sender: Any) {
        inputTextField.endEditing(true)
    }
    
    @objc private func wordButtonTapped(_ sender: UIButton) {
        let selectedText = sender.titleLabel?.text
        inputTextField.text = selectedText
    }
}
