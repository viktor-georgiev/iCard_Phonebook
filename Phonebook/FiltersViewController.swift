//
//  FiltersViewController.swift
//  Phonebook
//
//  Created by Viktor Georgiev on 5/14/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

import UIKit

class FiltersViewController: BasicViewController, CountryProtocol {
    
    //MARK: Variables
    
    var filterProtocol                     : FilterProtocol?
    
    var filter_ByMale                      : Bool?
    var filter_ByFemale                    : Bool?
    
    var filter_ByCountry                   : Int?
    
    private var chosenCountry              : Country!
    
    
    //MARK: Outlets
    @IBOutlet weak var switch_Male         : UISwitch!
    @IBOutlet weak var switch_Female       : UISwitch!
    
    @IBOutlet weak var button_ChooseCountry: UIButton!
    
    
    //MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chosenCountry = Country()
        
        setupNavigationBar()
        setupCurrentFilters()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: Navigation Functions
    
    func setupNavigationBar() {
        navigationItem.title = ViewControllerTitles.Filters.rawValue
        
        let leftButton = UIBarButtonItem(
            title: NavigationItemTitles.Cancel.rawValue,
            style: .plain,
            target: self,
            action: #selector(super.popController)
        )
        navigationItem.leftBarButtonItem = leftButton
    }
    
    
    //MARK: Custom Functions
    
    func animateSwitch(sender: UISwitch) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            sender.isOn = false
            self.view.layoutIfNeeded()
        })
    }
    
    func setupCurrentFilters() {
        switch_Male.isOn   = filter_ByMale!
        switch_Female.isOn = filter_ByFemale!
        
        if filter_ByCountry != -1 {
            didChooseCountry(country: Country.getCountryById(id: filter_ByCountry!))
        }
    }

    
    //MARK: Custom Protocol Functions
    
    func didChooseCountry(country: Country) {
        chosenCountry = country
        
        button_ChooseCountry.setTitle(
            country.name,
            for: .normal
        )
    }
    
    
    //MARK: Switch Actions
    
    @IBAction func onSwitchMaleValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            animateSwitch(sender: switch_Female)
        }
    }
    
    @IBAction func onSwitchFemaleValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            animateSwitch(sender: switch_Male)
        }
    }
    
    
    //MARK: Button Actions
    
    @IBAction func onClearPressed(_ sender: UIButton) {
        switch_Male.isOn   = false
        switch_Female.isOn = false
        
        button_ChooseCountry.setTitle(
            "Choose country",
            for: .normal
        )
        
        chosenCountry = Country()
        filterProtocol?.filter(male      : switch_Male.isOn,
                               female    : switch_Female.isOn,
                               countryId : (chosenCountry?.getId())!)
        
        popController()
    }
    
    @IBAction func onFilterPressed(_ sender: UIButton) {
        filterProtocol?.filter(male      : switch_Male.isOn,
                               female    : switch_Female.isOn,
                               countryId : (chosenCountry?.getId())!)
        
        popController()
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let countriesController = segue.destination as? CountriesViewController {
            countriesController.countryProtocol = self
        }
    }
    

}
