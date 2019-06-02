//
//  FeaturedDescriptionViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 30/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

class FavoritesDescriptionViewController: UIViewController {

    @IBOutlet weak var featuredButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func featuredButtonAction(_ sender: UIBarButtonItem) {
    }
    
}


// MARK: - Navigation
extension FavoritesDescriptionViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
