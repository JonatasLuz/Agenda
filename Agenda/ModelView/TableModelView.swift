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
    
    
    
    func cadastraPessoa(_ nome: String, _ imagem: UIImage, _ favorito : Bool) -> Pessoa{
        let pessoaCadastro = Pessoa(context: contexto)
        
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
        pessoaCadastro.favorito = favorito
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
        
        if(pessoas.isEmpty == false){
            pessoas = pessoas.sorted(by: {
                $0.nome!.lowercased() <   $1.nome!.lowercased()
            })
        }
        return pessoas
    }
    
    func getFavoritos() -> [Pessoa]{
        let requisicao : NSFetchRequest<Pessoa> = Pessoa.fetchRequest()
        requisicao.predicate = NSPredicate(format: "favorito == true")
        do{
            try pessoas =  contexto.fetch(requisicao)
        }catch{
            print("Erro na leitura de contato: \(error)")
        }
        pessoas = pessoas.sorted(by: {$0.nome!.lowercased() <   $1.nome!.lowercased()})
        return pessoas
    }
    
    func deletaPessoa(_ pessoa : Pessoa){
        var file = FileManager.default
        let pessoaDeletada = pessoa as NSManagedObject
        var documentsUrl: URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
        let fileURL = documentsUrl.appendingPathComponent(pessoa.imagemContato! + ".png")
        do{
            try file.removeItem(at: fileURL)
        }catch{
            print("Erro: \(error)")
        }
        contexto.delete(pessoaDeletada)
        do{
            try contexto.save()
        }catch{
            print("Erro para deletar contato \(error)")
        }
    }
    
    func updatePessoa(_ pessoaAntiga : Pessoa, _ pessoaNova : Pessoa, _ novaImagem : UIImage){
        var imagemUrl : URL
        var file = FileManager.default
        let qtdPessoas = pessoas.count
        let subNome = pessoaNova.nome!.split(separator: " ")
        let nomeArquivo : String = String(subNome.last!) + String(subNome.first!) + String(qtdPessoas)
        if let data = novaImagem.pngData() {
            imagemUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(nomeArquivo).png")
            try? data.write(to: imagemUrl)
        }
        var documentsUrl: URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
        let fileURL = documentsUrl.appendingPathComponent(pessoaAntiga.imagemContato! + ".png")
        do{
            try file.removeItem(at: fileURL)
        }catch{
            print("Erro: \(error)")
        }
        
        let requisicao : NSFetchRequest<Pessoa> = Pessoa.fetchRequest()
        requisicao.predicate = NSPredicate(format: "imagemContato = %@", pessoaAntiga.imagemContato!)
        do{
            try pessoas = contexto.fetch(requisicao)
        }catch{
            print("Erro na atualizacao de contato: \(error)")
        }
        if pessoas.count > 0{
            pessoas[0].setValue(pessoaNova.nome, forKey: "nome")
            pessoas.first?.setValue(nomeArquivo, forKey: "imagemContato")
            pessoas.first?.setValue(pessoaNova.favorito, forKey: "favorito")
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
    func cadastraEndereco(_ pais : String, _ estado : String, _ cidade : String, _ rua : String, _ numero : Int, _ complemento  : String , _ pessoa: Pessoa){
        let enderecoCadastro = Endereco(context: contexto)
        enderecoCadastro.pais = pais
        enderecoCadastro.estado = estado
        enderecoCadastro.cidade = cidade
        enderecoCadastro.rua = rua
        enderecoCadastro.numero = Int64(numero)
        enderecoCadastro.complemento = complemento
        enderecoCadastro.pessoa = pessoa
        print(contexto)
        do{
            try contexto.save()
        }catch{
            print("Erro no cadastro de endereço: \(error)")
        }
    }
    
    func getEndereco(_ pessoa : Pessoa) -> Endereco{
        let requisicao : NSFetchRequest<Endereco> = Endereco.fetchRequest()
        var endereco : [Endereco] = []
        requisicao.predicate = NSPredicate(format: "pessoa = %@", pessoa)
        do{
            try endereco = contexto.fetch(requisicao)
        }catch{
            print("Erro na leitura de endereço")
        }
        return endereco.first!
    }
    
    func updateEndereco(_ pessoa: Pessoa, _ novoEndereco: Endereco){
        let requisicao : NSFetchRequest<Endereco> = Endereco.fetchRequest()
        requisicao.predicate = NSPredicate(format: "pessoa = %@", pessoa)
        var endereco : [Endereco]!
        do{
            try endereco = contexto.fetch(requisicao)
        }catch{
            print("Erro na atualizacao do email: \(error)")
        }
        if endereco.count != 0{
            endereco.first?.setValue(novoEndereco.pais, forKey: "pais")
            endereco.first?.setValue(novoEndereco.estado, forKey: "estado")
            endereco.first?.setValue(novoEndereco.cidade, forKey: "cidade")
            endereco.first?.setValue(novoEndereco.rua, forKey: "rua")
            endereco.first?.setValue(novoEndereco.numero, forKey: "numero")
            endereco.first?.setValue(novoEndereco.complemento, forKey: "complemento")
        }
    }
    
    func deletaEndereco(_ endereco : Endereco ){
        let enderecoDeletado = endereco as NSManagedObject
            contexto.delete(enderecoDeletado)
        do{
            try contexto.save()
        }catch{
            print("Erro para deletar endereço \(error)")
        }
    }
    

    
    init(){
        
    }
}
