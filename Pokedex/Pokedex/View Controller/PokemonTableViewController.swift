//
//  PokemonTableViewController.swift
//  Pokedex
//
//  Created by Akmal Nurmatov on 5/8/20.
//  Copyright © 2020 Akmal Nurmatov. All rights reserved.
//

import UIKit

class PokemonTableViewController: UITableViewController {

    let pokemonController = PokemonController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pokemonController.pokemons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        
        cell.textLabel?.text = pokemonController.pokemons[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pokemonController.delete(pokemonController.pokemons[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddPokemonDetail" {
            if let addVC = segue.destination as? PokemonDetailViewController {
                addVC.pokemonController = pokemonController
            }
        } else if segue.identifier == "ShowPokemonDetail" {
            if let detailVC = segue.destination as? PokemonDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                detailVC.pokemonController = pokemonController
                detailVC.pokemon = pokemonController.pokemons[indexPath.row]
            }
        }
    }
}
