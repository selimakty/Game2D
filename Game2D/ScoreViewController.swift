//
//  ScoreViewController.swift
//  Game2D
//
//  Created by Selim on 7.01.2023.
//

import UIKit

class ScoreViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDef = UserDefaults.standard

        let score = userDef.integer(forKey: "score")
        let highScore = userDef.integer(forKey: "highScore")
        
        scoreLabel.text = String(score)
        
        if score >= highScore {
            userDef.set(score, forKey: "highScore")
            
            highScoreLabel.text = String(score)
        }else{
            highScoreLabel.text = String(highScore)
        }
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func tryAgain(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
