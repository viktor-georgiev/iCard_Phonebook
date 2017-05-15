//
//  CountriesViewController.swift
//  Phonebook
//
//  Created by Viktor Georgiev on 5/10/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

import UIKit

class CountriesViewController: BasicViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //MARK: Variables
    
    var countryProtocol                : CountryProtocol?
    
    private var countriesArray         : [Country]!
    private var filteredCountriesArray : [Country]!
    
    
    //MARK: Outlets
    
    @IBOutlet weak var countriesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        countriesArray = Country.countriesList()
        filteredCountriesArray = countriesArray
        countriesTableView.reloadData()
        
        setupNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Navigation Functions
    
    func setupNavigationBar() {
        navigationItem.title = ViewControllerTitles.Countries.rawValue
        
        let leftButton = UIBarButtonItem(
            title: NavigationItemTitles.Cancel.rawValue,
            style: .plain,
            target: self,
            action: #selector(super.popController)
        )
        navigationItem.leftBarButtonItem = leftButton
    }
    
    
    //MARK: Search Bar Delegate Methods
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        if searchText.characters.count != 0 {
            var filteredArray = [Country]()
            let searchWords   = searchText.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
            for country in self.countriesArray {
                var containsAllWords = true
                
                for word in searchWords {
                    if !country.name.localizedCaseInsensitiveContains(word) {
                        containsAllWords = false
                        break
                    }
                }
                
                if containsAllWords {
                    filteredArray.append(country)
                }
            }
            
            filteredCountriesArray = filteredArray
        } else {
            filteredCountriesArray = countriesArray
        }
        
        countriesTableView.reloadData()
    }
    
    
    //MARK: Table View DataSource and Delegate methods
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return filteredCountriesArray.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.CountryCell.rawValue)! as! CountryTableViewCell
        
        cell.countryNameLabel?.text = filteredCountriesArray[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        countryProtocol?.didChooseCountry(country: filteredCountriesArray[indexPath.row])
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
