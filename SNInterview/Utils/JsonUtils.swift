//
//  JsonUtils.swift
//  SNInterview
//
//  Created by Mingjun on 1/21/20.
//  Copyright © 2020 ServiceNow. All rights reserved.
//

import Foundation

class JsonUtils {
    
    static let shared = JsonUtils()
    
    private init() {}
    
    /// read json file and convert to [T]
    /// - Parameter fileName: file name
    func loadJson<T: Decodable>(fileName: String) throws -> [T] {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            throw JsonUtilsError.fileNotExists
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path),
                                options: .mappedIfSafe)
            do {
                let data = try JSONDecoder().decode([T].self, from: data)
                return data
            }catch {
                throw JsonUtilsError.decodeFail
            }
        } catch {
            throw JsonUtilsError.dataCorrupt
        }
    }
    
    /// save data to file
    /// - Parameters:
    ///   - fileName: file name
    ///   - data: data want to save
    func saveJson<T: Encodable>(fileName: String, data: [T]) throws {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else{
            throw JsonUtilsError.fileNotExists
        }
        let url = URL.init(fileURLWithPath: path, isDirectory: false)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(data)

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                do {
                    try jsonString.write(to: url, atomically: true, encoding: .utf8)
                } catch  {
                    print(error.localizedDescription)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}


/// error type for jsonutils
enum JsonUtilsError: Error {
    case fileNotExists
    case dataCorrupt
    case decodeFail
}

extension JsonUtilsError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .fileNotExists:
            return NSLocalizedString("Can not find file with that name", comment: "Internal Error")
        case .dataCorrupt:
            return NSLocalizedString("Json data is not vaild", comment: "data Error")
        case .decodeFail:
            return NSLocalizedString("Decode dat failed", comment: "Code Error")
        }
    }
}
