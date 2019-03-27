//
//  AdicionarPessoaViewController.swift
//  Agenda
//
//  Created by ALUNO on 20/03/19.
//  Copyright © 2019 ALUNO. All rights reserved.
//

import UIKit

class AdicionarPessoaViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    

    @IBOutlet weak var adicionaImagemButton: UIButton!
    @IBOutlet weak var voltarButton: UIBarButtonItem!
    @IBOutlet weak var cadastrarButton: UIBarButtonItem!
    
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var ddiTextField: UITextField!
    @IBOutlet weak var dddTextField: UITextField!
    @IBOutlet weak var telefoneTextField: UITextField!

    
    
    var imagePicker = UIImagePickerController()
    var agenda: TableModelView = TableModelView()
    var pessoa : Pessoa!
    var pessoas : [Pessoa]!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        
       // let imagemNome = String(pessoas.count)
        
        let imagem = adicionaImagemButton.image(for: [])
 
        pessoa = agenda.cadastraPessoa(nomeTextField.text!, imagem!)
        agenda.cadastraEmail(emailTextField.text!, pessoa)
        agenda.cadastraFone(Int(ddiTextField.text!)!, Int(dddTextField.text!)!, telefoneTextField.text!, pessoa)
        let alerta = UIAlertController(title: "Agenda", message: "Contato cadastrado com sucesso", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {
            _ in self.retornaMenu()
        }))
        self.present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func nomeAction(_ sender: UITextField) {
        if verificaTextField(sender.text!) == true{
            sender.text = ""
            sender.textColor = UIColor.black
        }
        
    }
    
    @IBAction func emailAction(_ sender: UITextField) {
        if verificaTextField(sender.text!) == true{
            sender.text = ""
            sender.textColor = UIColor.black
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
    
    
    func verificaTextField(_ conteudoTexField : String)-> Bool{
        
        let conteudosPadrao = ["DDD", "DDI","Telefone","Nome","Email"]
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
