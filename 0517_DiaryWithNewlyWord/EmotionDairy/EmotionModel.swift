//
//  EmotionModel.swift
//  0517_DiaryWithNewlyWord
//
//  Created by gnksbm on 5/17/24.
//

import Foundation

struct EmotionModel: Hashable, Codable {
    let message: String
    let imgName: String
    let count: Int
    
    func increaseCount() -> Self {
        .init(
            message: message,
            imgName: imgName,
            count: count + 1
        )
    }
    
    func randomCount() -> Self {
        .init(
            message: message,
            imgName: imgName,
            count: (0...100).randomElement() ?? 0
        )
    }
}

extension EmotionModel {
    static let sampleDatas: [Self] = [
        .init(message: "행복해", imgName: "slime1", count: 0),
        .init(message: "사랑해", imgName: "slime2", count: 0),
        .init(message: "좋아해", imgName: "slime3", count: 0),
        .init(message: "당황해", imgName: "slime4", count: 0),
        .init(message: "속상해", imgName: "slime5", count: 0),
        .init(message: "우울해", imgName: "slime6", count: 0),
        .init(message: "심심해", imgName: "slime7", count: 0),
        .init(message: "행복해", imgName: "slime8", count: 0),
        .init(message: "행복해", imgName: "slime9", count: 0),
    ]
}

extension Array where Element == EmotionModel {
    private var userDefaultsKey: String {
        "models"
    }
    
    mutating func fetchModels() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey)
        else {
            print("저장된 데이터 없음")
            return
        }
        do {
            self = try JSONDecoder().decode(
                Self.self,
                from: data
            )
        } catch {
            print(
                String(describing: self),
                "디코딩 에러: \(error.localizedDescription)"
            )
        }
    }
    
    func saveModels() {
        do {
            let data = try JSONEncoder().encode(self)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print(
                String(describing: self),
                "인코딩 에러: \(error.localizedDescription)"
            )
        }
    }
    
    func removeSavedModels() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}
