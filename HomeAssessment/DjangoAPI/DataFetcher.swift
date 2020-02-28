//
//  DataFetcher.swift
//  tet
//
//  Created by Mengoreo on 2020/2/20.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import Foundation
import CoreData

class DataFetcher: NSObject {
    
    static func fetchTask(_ pathType: DjangoAPI.PathType, with token: String, completionHandler: @escaping (Data, URLResponse, Error?) -> Void) {
        let url = URL(string: DjangoAPI.pathFor(pathType))!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 20
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                print("** no response")
                return
            }
            guard let data = data else {
                print("** no data")
                return
            }
            completionHandler(data, response, error)
        }
        
        task.resume()
    }
    
    static func fetchTask(_ pathType: DjangoAPI.PathType, with token: String, completionHandler: @escaping (Data, URLResponse, Error?, NSManagedObject) -> Void, for parent: NSManagedObject) {
        let url = URL(string: DjangoAPI.pathFor(pathType))!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 20
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                print("** no response")
                return
            }
            guard let data = data else {
                print("** no data")
                return
            }
            completionHandler(data, response, error, parent)
        }
        
        task.resume()
    }
    
//    private func handle(_ pathType: DjangoAPI.PathType, data: Data?, response: URLResponse?, error: Error?, for parent: NSManagedObject) {
//
//
//        let decoder = JSONDecoder()
//        switch pathType {
//        case .standard:
//            guard let standardsJSON = try? decoder.decode(StandardsJSON.self, from: data)
////                ,let user = parent as? UserSession
//                else {
//                fatalError("can't create standards")
//            }
//            for standardJ in standardsJSON {
//                DispatchQueue.main.async {
//
//                    Standard.create(for: .currentUser, name: standardJ.name, uuidString: standardJ.id)
//                }
//                
//            }
//            print("** standards")
//            break
//        case .question( _):
//            guard let questionsJSON = try? decoder.decode(QuestionsJSON.self, from: data),
//                let standard = parent as? Standard else {
//                    fatalError("can't create questions")
//            }
//
//            for questionJ in questionsJSON {
//                Question.create(for: standard, index: questionJ.index, name: questionJ.title, measurable: questionJ.isMeasurable, uuidString: questionJ.id)
//            }
//            break
//        case .option(_, _):
//            guard let optionsJSON = try? decoder.decode(OptionsJSON.self, from: data),
//                let question = parent as? Question else {
//                    fatalError("can't create options")
//            }
//
//            for optionJ in optionsJSON {
//                Option.create(for: question, index: optionJ.index, optionDescription: optionJ.text, from_val: optionJ.fromVal, to_val: optionJ.toVal, vote: optionJ.vote, suggestion: optionJ.suggestion, uuidString: optionJ.id)
//            }
//            break
//        }
//    }
}

protocol JSONObject {
    var index: Int {get}
    var id: String {get}
    var parent: String {get}
}
// MARK: - Standard
struct StandardJSON: JSONObject, Codable {
    let index: Int
    let id, name, timeCreated, timeUpdated: String
    let parent: String

    enum CodingKeys: String, CodingKey {
        case index, id, name
        case timeCreated = "time_created"
        case timeUpdated = "time_updated"
        case parent
    }
}

typealias StandardsJSON = [StandardJSON]

// MARK: - Question
struct QuestionJSON: JSONObject, Codable {
    let index: Int
    let id, title: String
    let isMeasurable: Bool
    let timeCreated, timeUpdated, parent: String

    enum CodingKeys: String, CodingKey {
        case index, id, title
        case isMeasurable = "is_measurable"
        case timeCreated = "time_created"
        case timeUpdated = "time_updated"
        case parent
    }
}

typealias QuestionsJSON = [QuestionJSON]

// MARK: - Option
struct OptionJSON: JSONObject, Codable {
    let index: Int
    let id, text: String
    let fromVal, toVal, vote: Double
    let suggestion, timeCreated, timeUpdated, parent: String

    enum CodingKeys: String, CodingKey {
        case index, id, text
        case fromVal = "from_val"
        case toVal = "to_val"
        case vote, suggestion
        case timeCreated = "time_created"
        case timeUpdated = "time_updated"
        case parent
    }
}

typealias OptionsJSON = [OptionJSON]


struct DjangoAPI {
    enum PathType {
        case standard
        case question(standard: Int)
        case option(standard: Int, question: Int)
    }
    
    static func pathFor(_ pathType: PathType) -> String {
        switch pathType {
        case .standard:
            return "http://localhost:8000/api/standards/"
        case .question(let standard):
            return pathFor(.standard) + "\(standard)/" + "questions/"
        case .option(let standard, let question):
            return pathFor(.question(standard: standard)) + "\(question)/" + "options/"
        }
    }
    static let tokenPath = "http://localhost:8000/api/token_auth/"
}

