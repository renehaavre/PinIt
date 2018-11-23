//
//  HighScoreViewController.swift
//  PinIt
//
//  Created by Rene Haavre on 06/11/2018.
//  Copyright © 2018 Rene Haavre. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var highScoresArray = [String]()
    
    @IBOutlet var highScoreTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parseHighScores()
    }
    
    func getHighScores() -> String {
        
        var highscores = ""
        
        do {
            let highscoreDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let filePath = highscoreDir!.appendingPathComponent("highscores")
            highscores = try String(contentsOf: filePath, encoding: .utf8)
        }
        catch {
            print("Error reading highscores directory.")
        }
        
        return highscores
    }
    
    func parseHighScores() {
        let scoreString = getHighScores()
        
        scoreString.enumerateLines { (line, _) in
            self.highScoresArray.append(line)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScoresArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = highScoresArray[indexPath.row]
        
        return cell!
    }

}
