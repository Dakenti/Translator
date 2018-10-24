//
//  LanguagesTableViewController.swift
//  YandexApiConnectionTrial
//
//  Created by Dake Aga on 10/10/18.
//  Copyright © 2018 Dake Aga. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol SelectedLanguageName{
    func selectedLanguage(abrivation: String, name: String)
}

class LanguagesTableViewController: UITableViewController, UISearchBarDelegate {
    
    let YandexURL = "https://translate.yandex.net/api/v1.5/tr.json/getLangs"
    let API_KEY = "trnsl.1.1.20180927T064550Z.8645ed7ba4eb1fe4.17e0b7cd83388796036fef6f2e8009f79f6fcd20"
        
    var spinner: UIActivityIndicatorView!

    @IBOutlet weak var SearchBar: UISearchBar!
    
    var languageDict = [String:String]()
    
    var filtredLanguageArray = [String]()
    
    var inSearchMode = false
    
    var delegate: SelectedLanguageName?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.SearchBar.delegate = self
        
        self.SearchBar.returnKeyType = UIReturnKeyType.done
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        spinner.color = UIColor.blue
        
        tableView.backgroundView = spinner
        
        tableView.register(LanguageTableViewCell.self, forCellReuseIdentifier: "Cell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (languageDict.isEmpty){
            tableView.separatorStyle = .none
            spinner.startAnimating()
            Alamofire.request(YandexURL, method: .post, parameters: ["key" : self.API_KEY,"ui":"en"]).responseJSON{
                response in
                if response.result.isSuccess{
                    let text: JSON = JSON(response.result.value!)
                    for (key,value) in text["langs"]{
                        self.languageDict[key] = value.stringValue
                    }
//                    print(Array(self.languageDict.values))
                    self.spinner.stopAnimating()
                    self.tableView.separatorStyle = .singleLine
                    self.tableView.reloadData()
                }else{
                    print("Error \(String(describing: response.result.error))")
                }
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if inSearchMode{
            return filtredLanguageArray.count
        }
        return languageDict.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if inSearchMode{
            cell.textLabel?.text = filtredLanguageArray[indexPath.row]
        } else {
            cell.textLabel?.text = Array(languageDict.values)[indexPath.row]
        }
        
        return cell
    }
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            inSearchMode = true
            filtredLanguageArray = Array(languageDict.values).filter { $0 == searchBar.text }
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var value: String?
        var key: String?
        if inSearchMode{
            value = filtredLanguageArray[indexPath.row]
            key = languageDict.allKeys(forValue: value!)[0]
        } else {
            value = Array(languageDict.values)[indexPath.row]
            key = languageDict.allKeys(forValue: value!)[0]
        }
        delegate?.selectedLanguage(abrivation: key!, name: value!)
        navigationController?.popViewController(animated: true)
    }
}

extension Dictionary where Value: Equatable {
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}





