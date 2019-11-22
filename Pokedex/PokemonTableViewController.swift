//
//  PokemonTableViewController.swift
//  Pokedex
//
//  Created by Matheus Timbo Pereira on 06/10/19.
//  Copyright © 2019 Matheus Timbo Pereira. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PokemonTableViewController: UITableViewController, UISearchResultsUpdating {
    
    
    
    var pokemonList = Array<Pokemon>()
    var pokemonDataArray = Array<String>()
    var pokemonIndex = 1
    var loadingData = false
    var nextUrl = ""
    var resultSearchController = UISearchController()
    var filteredPokemonList = Array<Pokemon>()
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    func updateSearchResults(for searchController: UISearchController) {
        
    self.filteredPokemonList.removeAll(keepingCapacity: false)

        var filteredPokemonListAux = Array<Pokemon>()
        
        for pokemon in self.pokemonList{
            if(pokemon.nome.contains(searchController.searchBar.text!.lowercased())){
                filteredPokemonListAux.append(pokemon)
            }
        }
        
            
        
        self.filteredPokemonList = filteredPokemonListAux

        self.tableView.reloadData()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingIndicator.startAnimating()
        parseJSON(url:"https://pokeapi.co/api/v2/pokemon/");
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()

            tableView.tableHeaderView = controller.searchBar

            return controller
        })()

        // Reload the table
        tableView.reloadData()
    }
    
    func parseJSON (url:String) {
        self.loadingData = true
        let url = URL(string: url)
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in

            guard error == nil else {
                print("returning error")
                return
            }

            guard let content = data else {
                print("not returning data")
                return
            }


            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                return
            }

            let pokemons = json["results"] as? [[String: AnyObject]]
            if(json["next"] != nil){
                self.nextUrl = json["next"] as! String
            }
            for pokemon in pokemons!{
                var indexString:String;
                if(self.pokemonIndex<10){
                    indexString = "#00" + String(self.pokemonIndex) + " -"
                }else
                    if(self.pokemonIndex<100){
                        indexString = "#0" + String(self.pokemonIndex) + " -"
                    }else{
                        indexString = "#" + String(self.pokemonIndex) + " -"
                }
                let purePokemonName = pokemon["name"] as! String
                let composedPokemonName = indexString + " " + purePokemonName
                let pokemonAux = Pokemon(nome: composedPokemonName, fotoUrl: pokemon["url"] as! String, tipos: [""], movimentos: [""], purePokemonName: purePokemonName)
                
                self.pokemonList.append(pokemonAux)
                self.pokemonIndex+=1
            }
            

            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.setPokemonsImages();
                self.setPokemonTypes();
                self.loadingData = false
            }
            
            /*if let nextUrl = json["next"] as? String {
                 // There is a nextUrl
                self.parseJSON(url: nextUrl)
            }
            else if let nextUrl = json["next"] as? NSNull {
                 // There is nextUrl but Null
                
            }
            else {
                // No nextUrl
            }
            //self.parseJSON(url: json["next"] as! String)*/

        }

        task.resume()

    }
    
    func setPokemonTypes(){
        print("chegou aqui")
        for pokemon in self.pokemonList{
            var urlPokemon = pokemon.fotoUrl
            let url = URL(string: urlPokemon)
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in

                guard error == nil else {
                    print("returning error")
                    return
                }

                guard let content = data else {
                    print("not returning data")
                    return
                }


                guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String:    Any] else {
                    print("Not containing JSON")
                    return
                }

                DispatchQueue.main.async {
                    print("json")
                    print(json["types"])
                    if let types = json["types"] as? [String: String?] {
                        print("tipos ee")
                        print(types)
                       
                    }
                }
            }
            task.resume()
        }
    }
    
    func setPokemonsImages(){
        for pokemon in self.pokemonList{
            var urlPokemon = pokemon.fotoUrl
            let url = URL(string: urlPokemon)
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in

                guard error == nil else {
                    print("returning error")
                    return
                }

                guard let content = data else {
                    print("not returning data")
                    return
                }


                guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String:    Any] else {
                    print("Not containing JSON")
                    return
                }

                DispatchQueue.main.async {
                    
                    if let sprites = json["sprites"] as? [String: String?] {
                        Alamofire.request(sprites["front_default"]!!).responseImage { response in
                            if let image = response.result.value {
                                print("image downloaded: \(image)")
                                //self.pokeimage.image = image
                                pokemon.foto = image
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
            task.resume()
        }
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            print(" you reached end of the table")
            if(self.loadingData == false && self.nextUrl != ""){
                parseJSON(url: self.nextUrl)
            }
        }
    }

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return self.filteredPokemonList.count
        } else {
            return self.pokemonList.count
        }
        
    }

    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "minha_celula", for: indexPath)
        if(resultSearchController.isActive){
            let pokemon = self.filteredPokemonList[indexPath.row]
            cell.textLabel?.text = pokemon.nome
            //cell.imageView!.image = UIImage(named: "Pikachu")
            cell.imageView!.image = pokemon.foto
            cell.contentView.backgroundColor = UIColor.red
            return cell
        } else{
            let pokemon = self.pokemonList[indexPath.row]
            cell.textLabel?.text = pokemon.nome
            //cell.imageView!.image = UIImage(named: "Pikachu")
            cell.imageView!.image = pokemon.foto
            cell.contentView.backgroundColor = UIColor.red
            cell.contentView.backgroundColor = UIColor.init(red: (3/255.0), green: (207/255.0), blue: (252/255.0), alpha: 1)
           
            
            return cell
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PokemonDetail") {
            
            let dvc = segue.destination as! PokemonDetailViewController
            let cellIndex = self.tableView.indexPathForSelectedRow
            let pokemonName:String
            
            if  (resultSearchController.isActive) {
                pokemonName = filteredPokemonList[cellIndex!.row].purePokemonName
            } else {
                pokemonName = pokemonList[cellIndex!.row].purePokemonName
            }
            
            dvc.url = "https://pokeapi.co/api/v2/pokemon/" + pokemonName
        }
    }

    override func didReceiveMemoryWarning() {
        print("a")
    }
}
