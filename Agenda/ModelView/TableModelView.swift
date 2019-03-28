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
    var emails : [Email] = []
    
    
    
    func cadastraPessoa(_ nome: String, _ imagem: UIImage) -> Pessoa{
        let pessoaCadastro = Pessoa(context: contexto)
        pessoas = getPessoas()
        var imagemUrl : URL
        let qtdPessoas = pessoas.count
        let subNome = nome.split(separator: " ")
        let nomeArquivo : String = String(subNome.last!) + String(subNome.first!) + String(qtdPessoas)
        if let data = imagem.pngData() {
            imagemUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(nomeArquivo).png")
            try? data.write(to: imagemUrl)
            pessoaCadastro.imagemUrl = imagemUrl
            pessoaCadastro.imagemContato = nomeArquivo
        }
        pessoaCadastro.nome = nome
        do{
            try contexto.save()
            
        }catch{
            print("Erro no cadastro de pessoa: \(error)")
        }
        return pessoaCadastro
    }
    
    func getPessoas() -> [Pessoa]{
        let requisicao : NSFetchRequest<Pessoa> = Pessoa.fetchRequest()
        do{
            try pessoas =  contexto.fetch(requisicao)
        }catch{
            print("Erro na leitura de contato: \(error)")
        }
        return pessoas
    }
    
    func deletaPessoa(_ pessoa : Pessoa){
        let pessoaDeletada = pessoa as NSManagedObject
        contexto.delete(pessoaDeletada)
        do{
            try contexto.save()
        }catch{
            print("Erro para deletar contato \(error)")
        }
    }
    
    func updatePessoa(_ pessoaAntiga : Pessoa, _ pessoaNova : Pessoa , _ novaImagem: UIImage){
        var imagemUrl : URL
        let qtdPessoas = pessoas.count
        let subNome = pessoaNova.nome!.split(separator: " ")
        let nomeArquivo : String = String(subNome.last!) + String(subNome.first!) + String(qtdPessoas)
        if let data = novaImagem.pngData() {
            imagemUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(nomeArquivo).png")
            try? data.write(to: imagemUrl)
        }
        
        let requisicao : NSFetchRequest<Pessoa> = Pessoa.fetchRequest()
        print(pessoaAntiga.imagemContato)
        requisicao.predicate = NSPredicate(format: "imagemContato = %@", pessoaAntiga.imagemContato!)
        do{
            try pessoas = contexto.fetch(requisicao)
        }catch{
            print("Erro na atualizacao de contato: \(error)")
        }
        if pessoas.count > 0{
            pessoas[0].setValue(pessoaNova.nome, forKey: "nome")
            pessoas[0].setValue(nomeArquivo, forKey: "imagemContato")
        }
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
            print("Erro no cadastro de telefone: \(error)")
        }
    }
    
    func getFones() -> [Fone]{
        let requisicao : NSFetchRequest<Fone> = Fone.fetchRequest()
        do{
            try fones =  contexto.fetch(requisicao)
        }catch{
            print("Erro na leitura de telefone: \(error)")
        }
        return fones
    }
    
    func getFone(_ pessoa : Pessoa) -> [Fone]{
        let requisicao : NSFetchRequest<Fone> = Fone.fetchRequest()
        requisicao.predicate = NSPredicate(format: "pessoa == %@", pessoa)
        do{
            try fones = contexto.fetch(requisicao)
        }catch{
            print("Erro na leitura de telefone: \(error)")
        }
        
        return fones
    }
    
    func deletaFone(_ telefones : [Fone] ){
        let telefonesDeletados = telefones as [NSManagedObject]
        for telefone in telefonesDeletados{
            contexto.delete(telefone)
        }
        do{
            try contexto.save()
        }catch{
            print("Erro para deletar telefone \(error)")
        }
    }
    
    
    func updateFone(_ pessoa : Pessoa, _ novoTelefone : Fone){
        let requisicao : NSFetchRequest<Fone> = Fone.fetchRequest()
        requisicao.predicate = NSPredicate(format: "pessoa == %@", pessoa)
        do{
            try fones = contexto.fetch(requisicao)
        }catch{
            print("Erro na leitura de telefone: \(error)")
        }
        if fones.count != 0{
            fones[0].setValue(novoTelefone.telefone, forKey: "telefone")
            fones[0].setValue(novoTelefone.ddd, forKey: "ddd")
            fones[0].setValue(novoTelefone.ddi, forKey: "ddi")
            do{
                try contexto.save()
            }catch{
                print("Erro na atualizacao do telefone \(error)")
            }
        }
    }
    

    
    func cadastraEmail(_ email : String,_ pessoa : Pessoa){
        let emailCadastro = Email(context: contexto)
        emailCadastro.email = email
        emailCadastro.pessoa = pessoa
        do{
            try contexto.save()
        }catch{
            print("Erro no cadastro de email: \(error)")
        }
    }
    
    func getEmail(_ pessoa : Pessoa) -> [Email]{
        let requisicao : NSFetchRequest<Email> = Email.fetchRequest()
        requisicao.predicate = NSPredicate(format: "pessoa == %@", pessoa)
        do{
            try emails = contexto.fetch(requisicao)
        }catch{
            print("Erro na leitura de email: \(error)")
        }
        return emails
    }
    
    func deletaEmail(_ emails : [Email]){
        let emailsDeletados = emails as [NSManagedObject]
        for email in emailsDeletados{
            contexto.delete(email)
        }
        do{
            try contexto.save()
        }catch{
            print("Erro ao deletar email \(error)")
        }
    }
    
    func updateEmail(_ pessoa: Pessoa, _ novoEmail: String){
        let requisicao : NSFetchRequest<Email> = Email.fetchRequest()
        requisicao.predicate = NSPredicate(format: "pessoa = %@", pessoa)
        do{
            try emails = contexto.fetch(requisicao)
        }catch{
            print("Erro na atualizacao do email: \(error)")
        }
        if emails.count != 0{
            emails[0].setValue(novoEmail, forKey: "email")
        }
    }
    
    func getImagem(_ url  : String) -> UIImage?{
        var documentsUrl: URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
        let fileURL = documentsUrl.appendingPathComponent(url + ".png")
        do{
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
            
        }catch{
            print("Erro: \(error)")
        }
        return nil
    }
    

    

    
    init(){
        
    }
}
