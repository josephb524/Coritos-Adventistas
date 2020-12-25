//
//  FavoritosViewController.swift
//  Coritos Adventistas
//
//  Created by Jose Pimentel on 5/26/20.
//  Copyright © 2020 Jose Pimentel. All rights reserved.
//

import UIKit

class FavoritosViewController: UIViewController {
    
    @IBOutlet weak var favoritosSearch: UISearchBar!
    @IBOutlet weak var favoritosTableView: UITableView!
    @IBOutlet weak var favoritosTextView: UITableView!
    
    let coritos = CoritosBrain()
    var index: Int = 0

    var indexRows: [Int] = []
    var favoritosLength: [Int] = []
    var isNotSearching = true
    
    let defaults = UserDefaults.standard
    
    var search = SearchBrain()
    var coritosView = [Coritos]()
    var favoritosArray = [Coritos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coritosFavoritos()
        
        favoritosTableView.delegate = self
        favoritosTableView.dataSource = self
        favoritosSearch.delegate = self
        
        self.addDoneButtonOnKeyboard()
    }
    
    //to reload the view everytime you add or remove form favoritos
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoritosArray.removeAll()
        coritosFavoritos()
        self.favoritosTableView.reloadData()
    }
    
    func coritosFavoritos() {
        
        favoritosLength = defaults.array(forKey: "Favoritos") as? [Int] ?? [Int]()
        
        if favoritosLength.count != 0{
            
            var i = 0
            
            while i < favoritosLength.count {
                
                favoritosArray.append(Coritos(title: coritos.coritos[favoritosLength[i]].title, coritos: coritos.coritos[favoritosLength[i]].coritos, coritoUrl: coritos.coritos[favoritosLength[i]].coritoUrl))
                
                i += 1
            }
        }
    }
}

extension FavoritosViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if(isNotSearching) {
            
            count = favoritosArray.count
        }
            
        else {
            
            count = (coritosView.count)
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        
        if(isNotSearching) {
            
            cell.textLabel?.text = favoritosArray[indexPath.row].title
            cell.detailTextLabel?.text = favoritosArray[indexPath.row].coritos
        }
        
        else {
            
            cell.textLabel?.text = coritosView[indexPath.row].title
            cell.detailTextLabel?.text = coritosView[indexPath.row].coritos
        }
        
        return cell
    }
}

extension FavoritosViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(isNotSearching) {
            
            index = indexPath.row
        }
        else {
            
            index = indexRows[indexPath.row]
        }
        
        self.performSegue(withIdentifier: "CoritosFavoritos", sender: self)
        self.dismiss(animated: true, completion: nil)
        //self.performSegue(withIdentifier: "Coritos", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CoritosFavoritos" {
            
            let destinationVC = segue.destination as! CoritosViewController
            
            destinationVC.getCoritoIndex(index: index, favoritos: favoritosArray, checkWhichController: true)
        }
    }
}

extension FavoritosViewController: UISearchBarDelegate {
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
      
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        favoritosSearch.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {

        favoritosSearch.endEditing(true)
        favoritosSearch.showsCancelButton = false
    }
    
    func searchBarIf() {
        
        if(favoritosSearch.text!.isEmpty) {
            favoritosSearch.showsCancelButton = false
            isNotSearching = true
            favoritosSearch.endEditing(true)
            self.favoritosTableView.reloadData()
        }
            
        else {
            favoritosSearch.showsCancelButton = true
            var search = SearchBrain()
            search.searchFavorito(searchType: favoritosSearch.text!, coritoFavoritos: favoritosArray)
            
            indexRows = search.getIndexFavoritos()
            
            isNotSearching = false
            coritosView = search.getCoritosFavoritos()
            self.favoritosTableView.reloadData()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBarIf()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBarIf()
        searchBar.showsCancelButton = false
        
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        isNotSearching = true
        searchBar.text = ""
        self.favoritosTableView.reloadData()
        
    }
}
