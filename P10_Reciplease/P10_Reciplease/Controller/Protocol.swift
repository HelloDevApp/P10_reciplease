//
//  FavoritesProtocol.swift
//  P10_Reciplease
//
//  Created by macbook pro on 02/06/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

protocol Favorites {
    
    func changeTintColor(barButtonItem: UIBarButtonItem, color: UIColor)
}

extension Favorites {
    
    func changeTintColor(barButtonItem: UIBarButtonItem, color: UIColor) {
        if barButtonItem.tintColor == UIColor.white {
            barButtonItem.tintColor = color
        } else {
            barButtonItem.tintColor = UIColor.white
        }
    }
}
