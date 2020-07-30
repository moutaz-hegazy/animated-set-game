//
//  newSetGameViewController.swift
//  set_view_new
//
//  Created by Moutaz_Hegazy on 5/1/20.
//  Copyright © 2020 Moutaz_Hegazy. All rights reserved.
//

import UIKit

class newSetGameViewController: UIViewController {
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let set = segue.destination as? setViewController{
//            set.game = set()
        }
    }
}
