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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func retornaMenu(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let TableViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! TableViewController
        self.present(TableViewController, animated: true, completion: nil)
    }
    
    func acessaGaleria()
    {
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.modalPresentationStyle = .popover
        self.present(imagePicker, animated: true, completion: nil)
    }
    
 
    
    @IBAction func adicionaImagemAction(_ sender: UIButton) {
        let alerta = UIAlertController()
        alerta.addAction(UIAlertAction(title: "O aplicativo irá acessar as suas fotos", style: .default, handler: {_ in self.acessaGaleria()}))
        self.present(alerta, animated: true)
    }
    @IBAction func voltarAction(_ sender: UIButton) {
        retornaMenu()
    }
    @IBAction func cadastrarAction(_ sender: UIButton) {
        pessoa = agenda.cadastraPessoa(nomeTextField.text!)
        agenda.cadastraEmail(emailTextField.text!, pessoa)
        agenda.cadastraFone(Int(ddiTextField.text!)!, Int(dddTextField.text!)!, telefoneTextField.text!, pessoa)
        let alerta = UIAlertController(title: "Agenda", message: "Contato cadastrado com sucesso", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {
            _ in self.retornaMenu()
        }))
        self.present(alerta, animated: true, completion: nil)
    }
}
