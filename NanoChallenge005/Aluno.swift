//
//  Tabela.swift
//  NanoChallenge005
//
//  Created by Matheus Cavalcanti de Arruda on 01/06/22.
//

import Foundation

protocol DadosAluno {
    var nome: String { get }
    var nota: [String:Float] { get set }
    
    func mediaFinal() -> Float
    func adicionarAvaliacao(nome: String)
    func adicionarNota(avaliacao: String, nota: Float)
}

class Aluno: DadosAluno {
    let nome: String
    var nota: [String:Float] = [:]
    
    func adicionarAvaliacao(nome: String) {
        self.nota[nome] = 0
    }
    
    func adicionarNota(avaliacao nome: String, nota: Float) {
        self.nota[nome] = nota
    }
    
    func mediaFinal() -> Float {
        let arrNota: [Float] = Array(self.nota.values)
        var soma: Float = 0
        
        for i in arrNota {
            if i >= 0 {
                soma += i
            }
        }
        
        return soma / Float(self.nota.count)
    }
    
    init(nome: String) {
        self.nome = nome
    }
}
