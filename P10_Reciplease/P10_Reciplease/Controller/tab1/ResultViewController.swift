//
//  ResultViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 23/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Navigation
extension ResultViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

// MARK: - TableView
// TO-DO: - Change number of row in section per number Of recipe receive by API

extension ResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.rowHeight = tableView.frame.height / 4
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultTableViewCell {
            
            cell.configure(image: #imageLiteral(resourceName: "defaultImage"), nameRecipe: "Salade Romaine", detailIngredients: "Comcombres, asperges, maïs, oignons, tomates.." , numberOflike: 680, time: 31)
            
            return cell
        }
        return UITableViewCell()
    }
    
}
