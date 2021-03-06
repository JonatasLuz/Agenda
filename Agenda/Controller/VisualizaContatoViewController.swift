//
//  VisualizaContatoViewController.swift
//  Agenda
//
//  Created by ALUNO on 20/03/19.
//  Copyright © 2019 ALUNO. All rights reserved.
//

import UIKit

class VisualizaContatoViewController: UIViewController {
    @IBOutlet weak var paisLabel: UILabel!
    @IBOutlet weak var cidadeLabel: UILabel!
    @IBOutlet weak var estadoLabel: UILabel!
    @IBOutlet weak var ruaLabel: UILabel!
    @IBOutlet weak var complementoLabel: UILabel!
    @IBOutlet weak var numeroLabel: UILabel!
    
    @IBOutlet weak var viewImagemContato: UIView!
    @IBOutlet weak var imagemView: UIImageView!
    @IBOutlet weak var editarButon: UIBarButtonItem!
    @IBOutlet weak var imagemContato: UIImageView!
    @IBOutlet weak var ddiLabel: UILabel!
    @IBOutlet weak var dddLabel: UILabel!
    @IBOutlet weak var telefoneLabel: UILabel!
    @IBOutlet weak var nomeContatoLabel: UINavigationItem!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var voltarButton: UIBarButtonItem!
    var celula : Int!
    var pessoas : [Pessoa]!
    var telefones : [Fone]!
    var emails : [Email]!
    var endereco : Endereco!
    var agenda : TableModelView!
    var favoritoFlag : Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        agenda = TableModelView()
        if favoritoFlag == true{
            pessoas = agenda.getFavoritos()
        }else{
            pessoas = agenda.getPessoas()
        }
        telefones = agenda.getFone(pessoas[celula])
        emails = agenda.getEmail(pessoas[celula])
        endereco = agenda.getEndereco(pessoas[celula])
            
        nomeContatoLabel.title = pessoas[celula].nome
        telefoneLabel.text = telefones[0].telefone
        ddiLabel.text = String(telefones[0].ddi)
        dddLabel.text = String(telefones[0].ddd)
        emailLabel.text = emails[0].email
        let imagemURL = pessoas[celula].imagemContato
        imagemContato.image = agenda.getImagem(imagemURL!)
        paisLabel.text = endereco.pais
        estadoLabel.text = endereco.estado
        cidadeLabel.text = endereco.cidade
        ruaLabel.text = endereco.rua
        numeroLabel.text = String(endereco.numero)
        complementoLabel.text = endereco.complemento
        imagemView.widthAnchor.constraint(equalTo: imagemView.heightAnchor, multiplier: 1).isActive = true
        imagemView.centerYAnchor.constraint(equalTo: viewImagemContato.centerYAnchor).isActive = true
        imagemView.centerXAnchor.constraint(equalTo: viewImagemContato.centerXAnchor).isActive = true
        
    }
    
    @IBAction func voltarAction(_ sender: UIBarButtonItem) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let TableViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! TableViewController
        self.present(TableViewController, animated: true, completion: nil)
    }
    
    func load(_ url  : String) -> UIImage?{
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
    
    @IBAction func editarAction(_ sender: UIBarButtonItem) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let adicionaPessoa = storyBoard.instantiateViewController(withIdentifier: "IncluirPessoa") as! AdicionarPessoaViewController
        adicionaPessoa.pessoa = pessoas[celula]
        adicionaPessoa.editor = true
        self.present(adicionaPessoa, animated: true, completion: nil)
    }
    
    
    /*// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

