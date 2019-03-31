//
//  AdicionarPessoaViewController.swift
//  Agenda
//
//  Created by ALUNO on 20/03/19.
//  Copyright © 2019 ALUNO. All rights reserved.
//

import UIKit

class AdicionarPessoaViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    
    @IBOutlet weak var pessoaStackView: UIStackView!
    @IBOutlet weak var cidadeStackView: UIStackView!
    @IBOutlet weak var ruaStackView: UIStackView!   
    
    @IBOutlet weak var favoritoSwitch: UISwitch!
    @IBOutlet weak var telefoneStackView: UIStackView!
    @IBOutlet weak var complementoLabel: UITextField!
    @IBOutlet weak var enderecoStackView: UIStackView!
    @IBOutlet weak var viewImagem: UIView!
    
    @IBOutlet weak var adicionaImagemButton: UIButton!
    @IBOutlet weak var voltarButton: UIBarButtonItem!
    @IBOutlet weak var cadastrarButton: UIBarButtonItem!
    
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var ddiTextField: UITextField!
    @IBOutlet weak var dddTextField: UITextField!
    @IBOutlet weak var telefoneTextField: UITextField!
    
    @IBOutlet weak var cidadeTextField: UITextField!
    @IBOutlet weak var estadoTextField: UITextField!
    @IBOutlet weak var paisTextField: UITextField!
    @IBOutlet weak var ruaTextField: UITextField!
    @IBOutlet weak var numeroTextField: UITextField!
    @IBOutlet weak var complementoTextField: UITextField!
    

    
    
    var imagePicker = UIImagePickerController()
    var agenda: TableModelView = TableModelView()
    var pessoa : Pessoa!
    var pessoas : [Pessoa]!
    var telefones : [Fone]!
    var emails : [Email]!
    var endereco : Endereco!
    var editor : Bool = false
    
    override func viewDidLoad() {
        if pessoa != nil{
            telefones = agenda.getFone(pessoa)
            emails = agenda.getEmail(pessoa)
            endereco = agenda.getEndereco(pessoa)
            nomeTextField.text = pessoa.nome
            favoritoSwitch.isOn = pessoa.favorito
            emailTextField.text = emails.first?.email
            ddiTextField.text = String(telefones.first!.ddi)
            dddTextField.text = String(telefones.first!.ddd)
            telefoneTextField.text = telefones.first!.telefone
            paisTextField.text = endereco.pais
            estadoTextField.text = endereco.estado
            cidadeTextField.text = endereco.cidade
            ruaTextField.text = endereco.rua
            numeroTextField.text = String(endereco.numero)
            complementoTextField.text = endereco.complemento
            adicionaImagemButton.setImage(agenda.getImagem(pessoa.imagemContato!), for: [])
        }
        var textFields : [(UITextField, String)] = []
        textFields.append((nomeTextField , "Nome"))
        textFields.append((emailTextField, "Email"))
        textFields.append((dddTextField, "DDD"))
        textFields.append((ddiTextField, "DDI"))
        textFields.append((cidadeTextField, "Cidade"))
        textFields.append((estadoTextField, "Estado"))
        textFields.append((paisTextField, "País"))
        textFields.append((ruaTextField, "Rua"))
        textFields.append((numeroTextField,"Número"))
        textFields.append((complementoLabel,"Complemento"))
        for textField in textFields{
            if textField.0.text == ""{
                textField.0.text = textField.1
            }
        }
        
        
        super.viewDidLoad()
        adicionaImagemButton.widthAnchor.constraint(equalTo: adicionaImagemButton.widthAnchor , multiplier: 1.0).isActive = true
    adicionaImagemButton.centerXAnchor.constraint(equalTo: viewImagem.centerXAnchor).isActive = true
    adicionaImagemButton.centerYAnchor.constraint(equalTo: viewImagem.centerYAnchor).isActive = true
        cidadeStackView.heightAnchor.constraint(equalTo: enderecoStackView.heightAnchor, multiplier: 0.23).isActive = true
        telefoneStackView.heightAnchor.constraint(equalTo: pessoaStackView.heightAnchor, multiplier: 0.23).isActive = true
        nomeTextField.heightAnchor.constraint(equalTo: pessoaStackView.heightAnchor, multiplier: 0.23).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: pessoaStackView.heightAnchor, multiplier: 0.23).isActive = true
        if editor == true{
            navigationBarTitle.title = "Editor de Contato"
        }
        
        
        
    }
    
    func retornaMenu(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let TableViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! TableViewController
        self.present(TableViewController, animated: true, completion: nil)
    }
    
    
    func acessaGaleria()
    {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.modalPresentationStyle = .popover
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagemSelectionada : UIImage!
        if let imagemEditada = info[.editedImage] as? UIImage{
            imagemSelectionada = imagemEditada
            adicionaImagemButton.setImage(imagemSelectionada, for: [])
            picker.dismiss(animated: true, completion: nil)
        }
    }

    
    @IBAction func adicionaImagemAction(_ sender: UIButton) {
        let alerta = UIAlertController(title: "Agenda", message: "O aplicativo irá acessar as suas fotos", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.acessaGaleria()}))
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { _ in }))
        self.present(alerta, animated: true)
    }
    @IBAction func voltarAction(_ sender: UIButton) {
        retornaMenu()
    }
    
    @IBAction func cadastrarAction(_ sender: UIButton) {
        let dddNumber = Int(dddTextField.text ?? "ddd")
        let ddiNumber = Int(ddiTextField.text ?? "ddi")
        let telefone = Int(telefoneTextField.text ?? "telefone")
        let numeroEndereco = Int(numeroTextField.text ?? "numero")
        if dddNumber != nil && ddiNumber != nil && telefone != nil && numeroEndereco != nil{
            if editor == true{
                let pessoaAntiga = pessoa
                telefones[0].ddi = Int64(ddiTextField.text!)!
                telefones[0].ddd = Int64(dddTextField.text!)!
                telefones[0].telefone = telefoneTextField.text
                emails[0].email = emailTextField.text
                endereco.pais = paisTextField.text
                endereco.estado = estadoTextField.text
                endereco.cidade = cidadeTextField.text
                endereco.rua = ruaTextField.text
                endereco.numero = Int64(numeroTextField.text!)!
                endereco.complemento = complementoTextField.text
                agenda.updateFone(pessoa, telefones[0])
                pessoa.nome = nomeTextField.text
                pessoa.favorito = favoritoSwitch.isOn
                agenda.updateEmail(pessoa, emailTextField.text!)
                agenda.updateEndereco(pessoa, endereco)
                agenda.updatePessoa(pessoaAntiga!, pessoa, (adicionaImagemButton.imageView?.image)!)
                agenda.cadastraEndereco(paisTextField.text!, estadoTextField.text!, cidadeTextField.text!, ruaTextField.text!, Int(numeroTextField.text!)!, complementoTextField.text!, pessoa)
                
            }else{
                let imagem = adicionaImagemButton.image(for: [])
                pessoa = agenda.cadastraPessoa(nomeTextField.text!, imagem!, favoritoSwitch.isOn)
                agenda.cadastraEmail(emailTextField.text!, pessoa)
                agenda.cadastraFone(Int(ddiTextField.text!)!, Int(dddTextField.text!)!, telefoneTextField.text!, pessoa)
                agenda.cadastraEndereco(paisTextField.text!, estadoTextField.text!, cidadeTextField.text!, ruaTextField.text!, Int(numeroTextField.text!)!, complementoTextField.text!, pessoa)
            }
            let alerta = UIAlertController(title: "Agenda", message: "Contato cadastrado com sucesso", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {
                _ in self.retornaMenu()
            }))
            self.present(alerta, animated: true, completion: nil)
        }else{
            let alerta = UIAlertController(title: "Agenda", message: "Valores Incorretos", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {
                _ in
            }))
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    @IBAction func nomeAction(_ sender: UITextField) {
        sender.textColor = UIColor.black
        if verificaTextField(sender.text!) == true{
            sender.text = ""
        }
        
    }
    
    @IBAction func emailAction(_ sender: UITextField) {
        sender.textColor = UIColor.black
        if verificaTextField(sender.text!) == true{
            sender.text = ""
        }
    }
    
    @IBAction func ddiAction(_ sender: UITextField) {
        if verificaTextField(sender.text!) == true{
            sender.text = ""
            sender.textColor = UIColor.black
        }
    }
    
    @IBAction func dddAction(_ sender: UITextField) {
        if verificaTextField(sender.text!) == true{
            sender.text = ""
            sender.textColor = UIColor.black
        }
    }
    
    @IBAction func telefoneAction(_ sender: UITextField) {
        if verificaTextField(sender.text!) == true{
            sender.text = ""
            sender.textColor = UIColor.black
        }
    }
    
    @IBAction func cidadeAction(_ sender: UITextField) {
        if verificaTextField(sender.text!) == true{
            sender.text = ""
            sender.textColor = UIColor.black
        }
    }
    @IBAction func estadoAction(_ sender: UITextField) {
        if verificaTextField(sender.text!) == true{
            sender.text = ""
            sender.textColor = UIColor.black
        }
    }
    @IBAction func paisAction(_ sender: UITextField) {
        if verificaTextField(sender.text!) == true{
            sender.text = ""
            sender.textColor = UIColor.black
        }
    }
    @IBAction func numeroAction(_ sender: UITextField) {
        if verificaTextField(sender.text!) == true{
            sender.text = ""
            sender.textColor = UIColor.black
        }
    }
    
  
    @IBAction func ruaAction(_ sender: UITextField) {
        if verificaTextField(sender.text!) == true{
            sender.text = ""
            sender.textColor = UIColor.black
        }
        
    }
    
    
    
    @IBAction func ComplementoAction(_ sender: UITextField) {
        if verificaTextField(sender.text!) == true{
            sender.text = ""
            sender.textColor = UIColor.black
        }
        
    }
    
    func verificaTextField(_ conteudoTexField : String)-> Bool{
        
        let conteudosPadrao = ["DDD", "DDI","Telefone","Nome","Email","Rua","Número", "Complemento", "Estado","Cidade","País"]
        var verificaConteudo : Bool = false
        for conteudo in conteudosPadrao{
            if conteudoTexField == conteudo{
                verificaConteudo = true
                break
            }
        }
        return verificaConteudo
    }
}
