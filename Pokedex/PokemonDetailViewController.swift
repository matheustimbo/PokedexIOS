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
    
    @IBOutlet weak var labelPeso: UILabel!
    
    @IBOutlet weak var labelAltura: UILabel!
    
    @IBOutlet weak var labelExperience: UILabel!
    
    @IBOutlet weak var labelOrdem: UILabel!
    
    @IBOutlet weak var labelID: UILabel!
    
    
    
    
    
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
                
                for abilityItem in abilities {
                    let ability = abilityItem["move"] as! [String:String]
                    print("\(ability["name"]!)")
                }
                
                //-----------------------------------------------------------
               
                
                self.types.reloadData()
                self.pokemonName.text = pokemonNameValue
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
