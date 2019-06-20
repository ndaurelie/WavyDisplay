//
//  OnePhotoViewController.swift
//  WavyDisplay
//
//  Created by Aurélie Nouaille-Degorce on 20/06/2019.
//  Copyright © 2019 Nouaille-Degorce. All rights reserved.
//

import UIKit
import Kingfisher

class OnePhotoViewController: UIViewController {
    
    var thisPhoto: Photo?
    
    // MARK: - Outlets
    
    @IBOutlet weak var chosenPhotoImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if thisPhoto != nil {
            
            let chosenPhotoUrl = URL(string: thisPhoto!.url)
            chosenPhotoImageView.kf.indicatorType = .activity
            chosenPhotoImageView.kf.setImage(with: chosenPhotoUrl)
        }
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
