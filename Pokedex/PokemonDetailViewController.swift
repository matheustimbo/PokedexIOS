 //
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Matheus Timbo Pereira on 07/10/19.
//  Copyright © 2019 Matheus Timbo Pereira. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

 
 class PokemonDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var typesTable: UITableView!
    
    @IBOutlet weak var evoluiPara: UILabel!
    @IBOutlet weak var labelPeso: UILabel!
    
    @IBOutlet weak var labelAltura: UILabel!
    
    @IBOutlet weak var labelExperience: UILabel!
    
    @IBOutlet weak var labelOrdem: UILabel!
    
    @IBOutlet weak var labelID: UILabel!
    
    @IBOutlet weak var labelHabilidades: UILabel!
    
    @IBOutlet weak var labelPassivas: UILabel!
    
    
    
    @IBAction func shareButton(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: ["Olha só este \(self.pokemonName.text!)"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokeTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "poketype_cell", for: indexPath)
        cell.textLabel?.text = pokeTypes[indexPath.row]
        cell.imageView!.image = Image(named: pokeTypes[indexPath.row]+".png")
        return cell
    }
    
    @IBOutlet weak var pokeimage: UIImageView!
    
    @IBOutlet weak var pokemonName: UILabel!
    
    var url: String?
    
    @IBOutlet weak var types: UITableView!
    
    var pokeTypes = Array<String>()
    
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


            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String:    Any] else {
                print("Not containing JSON")
                return
            }

            print("a")

            let pokemonNameValue = json["name"] as! String
            
//            let sprites = json["sprites"] as! [String: String]
            
            
            
            
            let types = json["types"] as? [[String: AnyObject]]
            for type in types!{ self.pokeTypes.append(type["type"]?["name"] as! String)
            }
            
            print("url da especie")
            let species = json["species"] as? [String: Any]
            print(species!["url"] as! String)
        
            self.parseSpecies(url: (species!["url"] as! String), pokemonName: pokemonNameValue)

            DispatchQueue.main.async {
                
                if let sprites = json["sprites"] as? [String: String?] {
                    print(sprites["front_default"]!!)
                    Alamofire.request(sprites["front_default"]!!).responseImage { response in
                        if let image = response.result.value {
                            print("image downloaded: \(image)")
                            self.pokeimage.image = image
                        }
                    }
                }
                
                
                print("name")
                print(pokemonNameValue)
                
                 self.labelPeso.text = "Peso:  " + String((json["weight"] as! NSNumber).int32Value) + " kgs"
                self.labelAltura.text = "Altura:  " + String((json["height"] as! NSNumber).int32Value) + " m"
                
                self.labelExperience.text = "Experiencia Base:  " + String((json["base_experience"] as! NSNumber).int32Value) + " xp"
                
                self.labelOrdem.text = "Ordem Do Pokemon :  " + String((json["order"] as! NSNumber).int32Value) +  "º"
                
                self.labelID.text = "ID:  " + String((json["id"] as! NSNumber).int32Value) + "#"
                
                //Metodo de adicionar os moves do MOVE
                
                let abilities = json["moves"] as! [[String: Any]]
                
                var abilitiesText = ""
                
                for abilityItem in abilities {
                    let ability = abilityItem["move"] as! [String:String]
                    print("\(ability["name"]!)")
                   abilitiesText.append(ability["name"]!+"| ") 
                }
                
                self.labelHabilidades.text = abilitiesText
                
                
                let passives = json["abilities"] as! [[String: Any]]
                
                var passivesText = ""
                
                for passiveItem in passives{
                    let passive = passiveItem["ability"] as! [String:String]
                    print("\(passive["name"]!)")
                    passivesText.append(passive["name"]!+"| ")
                }
                
                self.labelPassivas.text = passivesText
                //-----------------------------------------------------------
               
                
                self.types.reloadData()
                self.pokemonName.text = pokemonNameValue
            }
            

        }

        task.resume()

    }
    
    func parseSpecies(url: String, pokemonName: String){
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


            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String:    Any] else {
                print("Not containing JSON")
                return
            }

            print("evolution chain")
            print(json["evolution_chain"])
            let evolutionChain = json["evolution_chain"] as? [String: Any]
            print(evolutionChain!["url"])
            self.parseEvolutionChain(url: (evolutionChain!["url"] as! String), pokemonName: pokemonName)
            
            DispatchQueue.main.async {
            }
            

        }

        task.resume()
    }
    
    func parseEvolutionChain(url: String, pokemonName: String){
        print("kkapdofka")
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


            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String:    Any] else {
                print("Not containing JSON")
                return
            }
            
            var label = ""
            print("aaaaa")
            let chain = json["chain"] as? [String: Any]
            
            print(chain!["evolves_to"])
            print("bbbbb")
            let species = chain!["species"] as? [String: Any]
            print("sera")
            print(species!["name"]) //primeiro da linha evolutiva
            if(( species!["name"] as! String ) == pokemonName){
                //ele eh o primeiro
                let evolvesTo = chain!["evolves_to"] as! [[String:Any]]
                if(evolvesTo.isEmpty){
                    label = "Ultima Evolução  "
                } else {
                    let firstEvolve = evolvesTo[0]["species"] as! [String:Any]
                    label = "Proxima Evolução: " + String(firstEvolve["name"] as! String)
                }
            } else{
                let evolvesTo = chain!["evolves_to"] as! [[String:Any]]
                let firstEvolve = evolvesTo[0]["species"] as! [String:Any]
                let next = evolvesTo[0]["evolves_to"] as! [[String:Any]]
                if (!next.isEmpty){
                    let nextSpecies = next[0]["species"] as! [String:Any]
                    let nextSpeciesName = nextSpecies["name"] as! String
                    if(pokemonName == (firstEvolve["name"] as! String)){
                        label = "Proxima Evolução: " + String(nextSpecies["name"] as! String)
                    } else {
                        label = "Ultima Evolução "
                    }
                } else {
                    label = "Ultimo Evolução "
                }
                
                
            }
            /*let evolvesTo = chain!["evolves_to"] as! [[String:Any]]
            print("evolves to kk")
            print(evolvesTo)
            print("lalala")
            
            let firstEvolve = evolvesTo[0]["species"] as! [String:Any]
            print(firstEvolve["name"])
            var next = evolvesTo[0]["evolves_to"] as! [[String:Any]]
            
            print("next")
            print(next[0]["species"])
            if (next.isEmpty){
                print("next evol")
                print(next as! String)
            }*/
            /*while() do{
                
            }*/
            DispatchQueue.main.async {
                
                self.evoluiPara.text = label
            }
            

        }

        task.resume()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.typesTable.backgroundColor = UIColor.clear
        self.typesTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        if let url = self.url{
            
            parseJSON(url: url)
            
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
