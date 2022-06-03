import Foundation

class Column {
    
    var header: String
    var size: Int = 5
    
    init(header name: String) {
        self.header = name
        size = (name.count > size) ? name.count : size
    }
}

class Table {
    
    var columns: [Column] = [.init(header: "ALUNO"), .init(header: "MÉDIA FINAL")]
    var students: [Aluno] = []
    let console: ConsoleIO = .init()
    
    func addColumn(name header: String) {
        columns.append(.init(header: header))
        
        for student in students {
            student.nota[header] = -1
        }
    }
    
    private func selectColumn() -> String {
        
        if columns.count <= 2 {
            console.write("Não existe uma avaliação para adicionar nota.\n", as: .error)
            return ""
        }
        
        var opcaoMateria: [Int:String] = [:]
        
        console.write("[1] - Cancelar\n")
        for i in 2..<columns.count {
            opcaoMateria[i] = columns[i].header
            console.write("[\(i)] - \(columns[i].header)\n")
        }
        
        var validacao = false
        
        while !validacao {
            console.write("\nEscolha uma coluna: ")
            let escolha = console.readInt()
            switch escolha {
            case 1:
                validacao = true
            case _ where opcaoMateria.keys.contains(escolha):
                return opcaoMateria[escolha] ?? ""
            default:
                console.write("Valor inválido\n", as: .error)
            }
        }
        
        return ""
    }
    
    func addNote() {
        
        if students.count < 1 {
            console.write("Não existe aluno para adicionar nota.\n", as: .error)
            return
        }
        
        let selectedColumn = selectColumn()
        if selectedColumn.isEmpty { return }
        
        var opcaoAluno: [Int:Aluno] = [:]
        
        console.write("\n[1] - Cancelar")
        for n in 0..<students.count {
            opcaoAluno[n + 2] = students[n]
            console.write("\n[\(n + 2)] - \(students[n].nome)")
        }
        
        var validacao = false
        
        while !validacao {
            console.write("\n\nEscolha um aluno: ")
            let opcao = console.readInt()
            switch opcao {
            case 1:
                validacao = true
            case _ where opcaoAluno.keys.contains(opcao):
                console.write("\nNota pra o aluno: ")
                let nota = console.readFloat()
                validacao = nota >= 0 && nota <= 10
                if validacao { opcaoAluno[opcao]?.nota[selectedColumn] = nota }
            default:
                console.write("Valor inválido.", as: .error)
            }
        }
    }
    
    func addStudent(name: String, withNota: Bool = false) {
        let newStudent: Aluno = .init(nome: name)
        
        for i in 2..<columns.count {
            if withNota {
                
                var validacao = false
                var nota: Float = -1
                while !validacao {
                    console.write("\nNota para \(columns[i].header): ")
                    nota = console.readFloat()
                    validacao = nota >= 0 && nota <= 10
                    if !validacao { console.write("Valor precisa ser entre 0 e 10.\n", as: .error)}
                }
                newStudent.nota[columns[i].header] = nota
            } else {
                newStudent.nota[columns[i].header] = -1
            }
        }
        columns[0].size = (name.count > columns[0].size) ? name.count : columns[0].size
        
        students.append(newStudent)
    }
    
    func getAverageForColumn() -> String {
        
        var selectedColumn: String = ""
        var soma: Float = 0
        var notasValidas: Float = 0
        var opcaoMateria: [Int:String] = [:]
        console.write("Escolha uma coluna:\n\n")
        console.write("[1] - Cancelar\n")
        console.write("[2] - MÉDIA FINAL\n")
        for i in 2..<columns.count {
            opcaoMateria[i + 1] = columns[i].header
            console.write("[\(i + 1)] - \(columns[i].header)\n")
        }
        
        var validacao = false
        
        while !validacao {
            console.write("\nEscolha uma coluna: ")
            let escolha = console.readInt()
            switch escolha {
            case 1:
                validacao = true
            case 2:
                for student in students {
                    soma += student.mediaFinal()
                    notasValidas += 1
                }
                return "\nMédia coluna MÉDIA FINAL: \(String(format: "%.2f", soma / notasValidas))\n"
            case _ where opcaoMateria.keys.contains(escolha):
                selectedColumn = opcaoMateria[escolha] ?? ""
                for student in students {
                    let aux = student.nota[selectedColumn] ?? -1
                    if (aux >= 0) {
                        soma += aux
                        notasValidas += 1
                    }
                }
                let resultado = soma / notasValidas
                
                if resultado.isNaN {
                    return "\nA coluna \(selectedColumn) não possui notas válidas para uma média.\n"
                }
                
                return "\nMédia coluna \(selectedColumn): \(String(format: "%.2f\n", soma / notasValidas))"
            default:
                console.write("Valor inválido\n", as: .error)
            }
        }
        
        return ""
    }
}

extension Table {
    
    func getTable() -> String {
        return "\n\(getHeader())\n\(getStudents())\n"
    }
    
    private func getStudents() -> String {
        let line: String = "|\n\(getLine())\n"
        var rows: String = ""
        
        for i in students {
            
            if i.nome.count == columns[0].size {
                rows += "| \(i.nome) "
            } else {
                rows += "| \(i.nome) \(String(repeating: " ", count: columns[0].size - i.nome.count))"
            }
            
            let media = i.mediaFinal()
            var mediaStr: String = ""
            
            if media.isNaN || media == -1 { mediaStr = "----"}
            else { mediaStr = String(format: "%.2f", media)}
            
            rows += "| \(mediaStr) \(String(repeating: " ", count: columns[1].size - mediaStr.count))"
            
            for materia in 2..<columns.count {
                let nota: Float = i.nota["\(columns[materia].header)"] ?? -1
                let notaStr = (nota == -1) ? "----" : String(format: "%.2f", nota)
                
                if notaStr.count == columns[materia].size {
                    rows += "| \(notaStr) "
                } else {
                    rows += "| \(notaStr) \(String(repeating: " ", count: columns[materia].size - notaStr.count))"
                }
            }
            
            rows += line
        }
        
        return rows
    }
    
    private func getHeader() -> String {
        var header: String = ""
        header = "\(getLine())\n"
        for i in columns {
            if i.header.count == i.size {
                header += "| \(i.header) "
            } else {
                header += "| \(i.header)\(String(repeating: " ", count: i.size - i.header.count)) "
            }
        }
        header += "|\n\(getLine())"
        return header
    }
    
    private func getLine() -> String {
        var linha: String = ""
        for i in columns {
            linha += "+-\(String(repeating: "-", count: i.size + 1))"
        }
        return linha + "+"
    }
}
