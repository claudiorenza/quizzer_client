//
//  MatchEndedViewController.swift
//  Party Quiz Game
//
//  Created by Ernesto De Crecchio on 27/02/18.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import UIKit

class MatchEndedViewController: UIViewController {

  @IBOutlet weak var pointsLabel: UILabel!
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var homeButton: UIButton!
  
  override func viewDidLoad() {
        super.viewDidLoad()
        pointsLabel.text = String(QuestionViewController.shared.points)
    view.backgroundColor = UIColor.colorLightBlue()
    homeButton.layer.cornerRadius = 25.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func homePressed(_ sender: Any) {
    QuestionViewController.shared.points = 0
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
