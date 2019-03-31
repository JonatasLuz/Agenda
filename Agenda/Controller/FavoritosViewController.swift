//
//  FavoritosViewController.swift
//  Agenda
//
//  Created by ALUNO on 27/03/19.
//  Copyright © 2019 ALUNO. All rights reserved.
//

import UIKit


class FavoritosViewController: UICollectionViewController {
    private let reuseIdentifier = "ContatoCell"
    @IBOutlet weak var voltarMenu: UIBarButtonItem!
    var pessoas : [Pessoa]!
    var agenda: TableModelView!
    
    override func viewDidLoad() {
        agenda = TableModelView()
        pessoas = agenda.getFavoritos()
        
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         //self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if pessoas.isEmpty{
            let alert = UIAlertController(title: "Agenda", message: """
            Você não possui nenhum favorito cadastrado.
            """, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pessoas.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let linha = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ContatoViewCell
        cell.contatoImagemView.image = agenda.getImagem(pessoas[linha].imagemContato!)
        cell.nomeLabel.text = pessoas[linha].nome
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        var headerView : UICollectionReusableView = UICollectionReusableView()
        if kind == UICollectionView.elementKindSectionHeader{
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
        }
        return headerView
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let visualizaContato = storyBoard.instantiateViewController(withIdentifier: "visualizaContato") as! VisualizaContatoViewController
        visualizaContato.celula = indexPath.row
        visualizaContato.favoritoFlag = true
        
        self.present(visualizaContato, animated: true, completion: nil)
    }

    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    @IBAction func voltarAction(_ sender: UIBarButtonItem) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let TableViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! TableViewController
        self.present(TableViewController, animated: true, completion: nil)
    }
    
}
