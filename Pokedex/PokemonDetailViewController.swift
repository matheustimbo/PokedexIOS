 //
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Matheus Timbo Pereira on 07/10/19.
//  Copyright © 2019 Matheus Timbo Pereira. All rights reserved.
//

import UIKit

 class PokemonDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    

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


            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                return
            }


            let pokemonName = json["name"] as! String
            
            
            
            let types = json["types"] as? [[String: AnyObject]]
            for type in types!{
                self.pokeTypes.append(type["type"]?["name"] as! String)
            }
            

            DispatchQueue.main.async {
                //self.tableView.reloadData()
                self.types.reloadData()
                self.pokemonName.text = pokemonName
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
            }*/

        }

        task.resume()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
