//
//  DataManager.swift
//  Emerald
//
//  Created by Kody Deda on 3/4/21.
//

import Foundation
import ComposableArchitecture

public enum DataManagerError: Error {
    case encodeState
    case decodeState
    case exportConfig
    case none
}

public struct DataManager<State> where State: Codable {

    func encodeState<State>(_ state: State, stateURL: URL) -> Result<Bool, DataManagerError> where State : Encodable {
        do {
            try JSONEncoder()
                .encode(state)
                .write(to: stateURL)
            return .success(true)
        } catch {
            return .failure(.encodeState)
        }
    }
    func decodeState<State>(_ state: State, stateURL: URL) -> Result<State, DataManagerError> where State : Decodable {
        do {
            let decoded = try JSONDecoder()
                .decode(type(of: state), from: Data(contentsOf: stateURL))
            return .success(decoded)
        }
        catch {
            return .failure(.decodeState)
        }
    }
    func exportConfig(_ data: String, configURL: URL) -> Result<Bool, DataManagerError> {
        do {
            let data: String = data
            try data.write(to: configURL, atomically: true, encoding: .utf8)
            
            return .success(true)
        }
        catch {
            return .failure(.exportConfig)
        }
    }
}

extension DataManager: Equatable {}
