//
//  Menu.swift
//  NanoChallenge005
//
//  Created by Matheus Cavalcanti de Arruda on 03/06/22.
//

import Foundation

class Menu {
    
    let console: ConsoleIO = .init()
    let table: Table = .init()
    
    func mainMenu() {
        
        console.write("TABELA DE NOTAS")
        console.write(table.getTable())
        
        var validacao = false
        
        while !validacao {
            console.write("[1] - Menu Aluno\n[2] - Menu Coluna\n[3] - Sair\n\n")
            console.write("Escolha: ")
            let escolha = console.readInt()
            console.write("\n")
            switch escolha {
            case 1:
                addStudentMenu()
            case 2:
                addColumnMenu()
            case 3:
                validacao = true
                console.write("Programa encerrado.\n")
            default:
                console.write("Opção inválida.\n", as: .error)
            }
        }
    }
    
    func addStudentMenu() {
        
        var validacao = false
        
        while !validacao {
            console.write("[1] - Voltar\n[2] - Adicionar aluno\n[3] - Adicionar aluno com nota\n[4] - Adicionar nota para aluno\n\n")
            
            console.write("Escolha: ")
            let escolha = console.readInt()
            console.write("\n")
            switch escolha {
            case 1:
                validacao = true
            case 2:
                console.write("Nome aluno: ")
                let nome = console.read()
                table.addStudent(name: nome)
                console.write(table.getTable())
            case 3:
                console.write("Nome aluno: ")
                let nome = console.read()
                table.addStudent(name: nome, withNota: true)
                console.write(table.getTable())
            case 4:
                table.addNote()
                console.write(table.getTable())
            default:
                console.write("Valor inválido.\n", as: .error)
            }
        }
    }
    
    func addColumnMenu() {
        
        var validacao = false 
        
        while !validacao {
            console.write("[1] - Voltar\n[2] - Adicionar coluna\n[3] - Media da coluna\n\n")
            
            console.write("Escolha: ")
            let escolha = console.readInt()
            console.write("\n")
            switch escolha {
            case 1:
                validacao = true
            case 2:
                console.write("Nome coluna: ")
                let nome = console.read()
                table.addColumn(name: nome)
                console.write(table.getTable())
            case 3:
                if !table.students.isEmpty {
                    console.write(table.getAverageForColumn())
                    console.write(table.getTable())
                } else {
                    console.write("Tabela não possui alunos para média\n\n", as: .error)
                }
            default:
                console.write("Opção inválida", as: .error)
            }
        }
    }
}
