//
//  Pessoa.swift
//  Agenda
//
//  Created by ALUNO on 15/03/19.
//  Copyright © 2019 ALUNO. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class TableModelView{
    
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var pessoas : [Pessoa] = []
    var fones : [Fone] = []
    
    
    
    
    func cadastraPessoa(_ nome: String, _ email: String){
        let pessoaCadastro = Pessoa(context: contexto)
        pessoaCadastro.nome = nome
        pessoaCadastro.email = email
        do{
            try contexto.save()
            print("Salvo")
            
        }catch{
            print("Erro no Cadastro: \(error)")
        }
    }
    
    func getPessoas() -> [Pessoa]{
        let requisicao : NSFetchRequest<Pessoa> = Pessoa.fetchRequest()
        do{
            try pessoas =  contexto.fetch(requisicao)
        }catch{
            print("Erro na leitura: \(error)")
        }
        return pessoas
    }
    
    func cadastraFone(_ ddd: Int, _ telefone: String, _ pessoa : Pessoa){
        let foneCadastro = Fone(context: contexto)
        foneCadastro.ddd = Int64(ddd)
        foneCadastro.telefone = telefone
        foneCadastro.relationship = pessoa
        do{
            try contexto.save()
            print("Salvo")
            
        }catch{
            print("Erro no Cadastro: \(error)")
        }
    }
    
    func getFones() -> [Fone]{
        let requisicao : NSFetchRequest<Fone> = Fone.fetchRequest()
        do{
            try fones =  contexto.fetch(requisicao)
        }catch{
            print("Erro na leitura: \(error)")
        }
        return fones
    }
    
    init(){
        
    }
}
