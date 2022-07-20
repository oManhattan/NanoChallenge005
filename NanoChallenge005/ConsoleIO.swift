//
//  ConsoleIO.swift
//  NanoChallenge005
//
//  Created by Matheus Cavalcanti de Arruda on 31/05/22.
//

import Foundation

enum WriteType {
    case normal
    case error
}

protocol ConsoleRead {
    func read() -> String
    func readInt() -> Int
    func readFloat() -> Float
}

protocol ConsoleWrite {
    func write(_ text: String, as type: WriteType)
}

class ConsoleIO: ConsoleRead {
    
    func read() -> String {
        guard let input = readLine() else {
            return ""
        }
        return input
    }
    
    func readInt() -> Int {
        guard let num = Int(read()) else {
            return -1
        }
        return num
    }
    
    func readFloat() -> Float {
        guard let num = Float(read().replacingOccurrences(of: ",", with: ".")) else {
            return -1
        }
        return num
    }
}

extension ConsoleIO: ConsoleWrite {
    
    func write(_ text: String, as type: WriteType = .normal) {
        switch type {
        case .normal:
            print(text, terminator: "")
        case .error:
            print("Erro: \(text)", terminator: "")
        }
    }
}
