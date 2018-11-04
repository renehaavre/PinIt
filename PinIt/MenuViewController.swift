//
//  MenuViewController.swift
//  PinIt
//
//  Created by Rene Haavre on 26/10/2018.
//  Copyright © 2018 Rene Haavre. All rights reserved.
//

import UIKit
import MapKit

class MenuViewController: UIViewController {
    
    @IBOutlet var menuMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menuMapView.mapType = .satellite
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? GameViewController
        vc?.gameType = ((sender as? UIButton)?.titleLabel?.text)!
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
