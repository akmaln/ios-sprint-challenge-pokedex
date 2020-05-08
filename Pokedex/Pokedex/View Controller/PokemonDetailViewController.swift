//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Akmal Nurmatov on 5/8/20.
//  Copyright © 2020 Akmal Nurmatov. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var abilityLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    var pokemonController: PokemonController?
    var pokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        toggleSearchItems()
        updateViews()
    }
    
    func updateViews() {
        pokemonDetails()
        guard let pokemon = pokemon else { return }

        if let data = pokemon.image {
            let image = UIImage(data: data)
            imageView.image = image
        } else {
            pokemonController?.fetchImage(for: pokemon, completion: { result in
                if let image = try? result.get() {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                } else {
                    print(result)
                }
            })
        }

        nameLabel.text = pokemon.name
        idLabel.text = "ID: \(pokemon.id)"
        var types = pokemon.types.compactMap { $0.type.name }

        _ = types.compactMap {
            if let index = types.firstIndex(of: $0) {
                types[index] = $0 }
        }

        typeLabel.text = "Types: \(types.joined(separator: ", "))"


        var abilities = pokemon.abilities.compactMap { $0.ability.name }
        _ = abilities.compactMap {
            if let index = abilities.firstIndex(of: $0) {
                abilities[index] = $0 }
        }
        abilityLabel.text = "Abilities: \(abilities.joined(separator: ", "))"
    }

    // Searchbar Function
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text?.lowercased() else { return }
        pokemonController?.fetchPokemon(named: searchTerm, completion: { result in
            let pokemon = try? result.get()
            DispatchQueue.main.async {
                self.pokemon = pokemon
                self.updateViews()
            }
        })
    }

    private func toggleSearchItems() {
        if pokemon != nil {
            navigationItem.title = pokemon?.name ?? ""
            searchBar.isHidden = true
            saveButton.isHidden = true
        }
    }

    private func pokemonDetails() {
        if pokemon != nil {
            imageView.isHidden = false
            nameLabel.isHidden = false
            idLabel.isHidden = false
            typeLabel.isHidden = false
            abilityLabel.isHidden = false
        } else {
            imageView.isHidden = true
            nameLabel.isHidden = true
            idLabel.isHidden = true
            typeLabel.isHidden = true
            abilityLabel.isHidden = true
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let addedPokemon = pokemon else { return }
        pokemonController?.pokemons.append(addedPokemon)
        self.navigationController?.popToRootViewController(animated: true) 
    }
    
}
