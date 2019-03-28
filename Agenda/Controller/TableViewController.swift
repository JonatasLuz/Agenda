//
//  TableViewController.swift
//  Agenda
//
//  Created by ALUNO on 15/03/19.
//  Copyright © 2019 ALUNO. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    @IBOutlet weak var favoritosButton: UIBarButtonItem!
    var agenda : TableModelView!
    var pessoas : [Pessoa]!
    var telefones: [Fone]!
    var emails: [Email]!
    
    @IBOutlet weak var adicionaPessoaButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        agenda = TableModelView()
        pessoas = agenda.getPessoas()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if pessoas.isEmpty{
            let alert = UIAlertController(title: "Agenda", message: """
            Você não possui nenhum contato.
            """, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pessoas.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if let labelNome = cell.viewWithTag(1000) as? UILabel{
            labelNome.text = pessoas?[indexPath.row].nome
        }
        // Configure the cell...
        return cell
    }

    @IBAction func adicionaPessoaAction(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let AdicionarPessoaViewController = storyBoard.instantiateViewController(withIdentifier: "IncluirPessoa") as! AdicionarPessoaViewController
        self.present(AdicionarPessoaViewController, animated: true, completion: nil)
    }
    
   
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "segueFavorito"{
            let proxima = segue.destination as! VisualizaContatoViewController
            proxima.celula = tableView.indexPathForSelectedRow?.row
        }
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            telefones = agenda.getFone(pessoas[indexPath.row])
            agenda.deletaFone(telefones)
            emails = agenda.getEmail(pessoas[indexPath.row])
            agenda.deletaEmail(emails)
            agenda.deletaPessoa(pessoas[indexPath.row])
            pessoas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    @IBAction func favoritosAction(_ sender: UIButton) {
        performSegue(withIdentifier: "segueFavorito", sender:self)
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
