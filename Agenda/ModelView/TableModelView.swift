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
    
    
    
    
    func cadastraPessoa(_ nome: String) -> Pessoa{
        let pessoaCadastro = Pessoa(context: contexto)
        pessoaCadastro.nome = nome
        do{
            try contexto.save()
            
        }catch{
            print("Erro no Cadastro de Pessoa: \(error)")
        }
        return pessoaCadastro
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
    
    
    func cadastraFone(_ ddi: Int,_ ddd: Int, _ telefone: String, _ pessoa : Pessoa){
        let foneCadastro = Fone(context: contexto)
        foneCadastro.ddd = Int64(ddd)
        foneCadastro.telefone = telefone
        foneCadastro.ddi = Int64(ddi)
        foneCadastro.pessoa = pessoa
        do{
            try contexto.save()
            
        }catch{
            print("Erro no Cadastro de Telefone: \(error)")
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
    
    func cadastraEmail(_ email : String,_ pessoa : Pessoa){
        let emailCadastro = Email(context: contexto)
        emailCadastro.email = email
        emailCadastro.pessoa = pessoa
        do{
            try contexto.save()
        }catch{
            print("Erro no Cadastro de Email: \(error)")
        }
    }
    
    init(){
        
    }
}
