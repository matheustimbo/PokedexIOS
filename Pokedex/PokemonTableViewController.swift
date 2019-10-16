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

class PokemonTableViewController: UITableViewController {
    
    var pokemonList = Array<Pokemon>()
    var pokemonDataArray = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let tipos = ["eletrico"]
        let movimentos = ["mega punch", "choque do trovao"]
        let Pokemontest = Pokemon(nome: "Pikachu", fotoUrl: "teste", tipos: tipos, movimentos: movimentos)
        pokemonList.append(Pokemontest)
        pokemonList.append(Pokemontest)*/
        parseJSON(url:"https://pokeapi.co/api/v2/pokemon/");
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func parseJSON (url:String) {
            
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


            print(json["results"])
            
            let pokemons = json["results"] as? [[String: AnyObject]]
            for pokemon in pokemons!{
                
                let pokemonAux = Pokemon(nome: pokemon["name"] as! String, fotoUrl: pokemon["url"] as! String, tipos: [""], movimentos: [""])
                
                self.pokemonList.append(pokemonAux)
            }
            

            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.setPokemonsImages();
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
    
    func setPokemonsImages(){
        for pokemon in self.pokemonList{
            print("teste")
            print(pokemon.fotoUrl)
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
                        print(sprites["front_default"]!!)
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

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pokemonList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "minha_celula", for: indexPath)
        let pokemon = self.pokemonList[indexPath.row]
        cell.textLabel?.text = pokemon.nome
        //cell.imageView!.image = UIImage(named: "Pikachu")
        cell.imageView!.image = pokemon.foto
        return cell
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
            /*let dvc = segue.destination as! ContatoViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            if let indexPath = indexPath {
                dvc.contato = self.contatos[indexPath.row]
            }*/
            let dvc = segue.destination as! PokemonDetailViewController
            let cellIndex = self.tableView.indexPathForSelectedRow
            let pokemonName:String = pokemonList[cellIndex!.row].nome
            dvc.url = "https://pokeapi.co/api/v2/pokemon/" + pokemonName
        }
    }

    override func didReceiveMemoryWarning() {
        print("a")
    }
}
