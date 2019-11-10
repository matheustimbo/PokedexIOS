//
//  Pokemon.swift
//  Pokedex
//
//  Created by Matheus Timbo Pereira on 06/10/19.
//  Copyright © 2019 Matheus Timbo Pereira. All rights reserved.
//

import UIKit

class Pokemon: NSObject {

    var nome:String
    var fotoUrl:String
    var tipos: Array<String>
    var movimentos: Array<String>
    var foto: UIImage
    var purePokemonName:String
    
    init(nome:String, fotoUrl:String, tipos:Array<String>, movimentos:Array<String>, purePokemonName:String) {
        self.nome = nome
        self.fotoUrl = fotoUrl
        self.foto = UIImage()
        self.tipos = tipos
        self.movimentos = movimentos
        self.purePokemonName = purePokemonName
    }
}
