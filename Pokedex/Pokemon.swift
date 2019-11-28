//
//  Pokemon.swift
//  Pokedex
//
//  Created by Matheus Timbo Pereira on 06/10/19.
//  Copyright © 2019 Matheus Timbo Pereira. All rights reserved.
//

import UIKit

class Pokemon: NSObject, NSCoding {

    var nome:String
    var fotoUrl:String
    var tipoPrincipal: String
    var foto: UIImage
    var purePokemonName:String
    var favorito:Bool
    
    init(nome:String, fotoUrl:String, tipoPrincipal:String, purePokemonName:String) {
        self.nome = nome
        self.fotoUrl = fotoUrl
        self.foto = UIImage()
        self.tipoPrincipal = tipoPrincipal
        self.purePokemonName = purePokemonName
        self.favorito = false
    }
    
    
    required init(coder decoder: NSCoder) {
        self.nome = decoder.decodeObject(forKey: "nome") as! String
        self.fotoUrl = decoder.decodeObject(forKey: "fotoUrl") as! String
        self.foto = decoder.decodeObject(forKey: "foto") as! UIImage
        self.tipoPrincipal = decoder.decodeObject(forKey: "tipoPrincipal") as! String
        self.purePokemonName = decoder.decodeObject(forKey: "purePokemonName") as! String
        self.favorito = decoder.decodeBool(forKey: "favorito")
    }
    
    func encode(with coder: NSCoder){
        coder.encode(self.nome, forKey: "nome")
        coder.encode(self.fotoUrl, forKey: "fotoUrl")
        coder.encode(self.foto, forKey: "foto")
        coder.encode(self.tipoPrincipal, forKey: "tipoPrincipal")
        coder.encode(self.purePokemonName, forKey: "purePokemonName")
        coder.encode(self.favorito, forKey: "favorito")
    }
}
