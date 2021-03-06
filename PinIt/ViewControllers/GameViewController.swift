//
//  ViewController.swift
//  PinIt
//
//  Created by Rene Haavre on 26/10/2018.
//  Copyright © 2018 Rene Haavre. All rights reserved.
//

import UIKit
import MapKit

class GameViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var progressView: UIView!
    @IBOutlet var doneButton: UIButton!
    
    @IBAction func longTapRecognizer(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            let locationOnMap = sender.location(in: mapView)
            let tappedCoordinate = mapView.convert(locationOnMap, toCoordinateFrom: mapView)
            removeAnnotations()
            addAnnotation(coords: tappedCoordinate)
        }

    }
    
    var locationsAndCoordinates = [String: String]()
    var correctLocation = CLLocation()
    let newPin = MKPointAnnotation()
    var guess: MKPointAnnotation = MKPointAnnotation()
    var gameType: String = "" {
        didSet {
            self.getLocations()
        }
    }
    var score: Int = 0
    var level: Int = 0
    let highscoreDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    @IBAction func guessSubmitted(_ sender: UIButton) {
        if (sender.titleLabel?.text == "Done") {
            if mapView.annotations.count == 0 { return }
            let location = CLLocation(latitude: guess.coordinate.latitude, longitude: guess.coordinate.longitude)
            let distance = correctLocation.distance(from: location).rounded() / 1000
            
            // Debug
            print("Guess lat: \(guess.coordinate.latitude) lon: \(guess.coordinate.longitude)")
            print("Actual lat: \(correctLocation.coordinate.latitude) lon: \(correctLocation.coordinate.longitude)")
            
            cityNameLabel.text = "You missed by \(distance) km."
            addAnnotation(coords: CLLocationCoordinate2D(latitude: correctLocation.coordinate.latitude, longitude: correctLocation.coordinate.longitude))
            doneButton.setTitle("Next", for: .normal)
            addAnnotation(coords: CLLocationCoordinate2D(latitude: correctLocation.coordinate.latitude, longitude: correctLocation.coordinate.longitude))
            
            // Update UI
            score += Int(distance)
            scoreLabel.text = String("Points: \(score)")
            updateProgressBar()
            
            // Zoom out so that guess and correct answer form a bounding box
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
        else {
            if level > 2 {
                addHighScore()
                
                let alert = UIAlertController(title: "Your score is \(score)!", message: "Lower is better.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Go again", style: .default, handler: { _ in
                    self.startNewGame()
                }))
                
                self.present(alert, animated: true)
            }
            else {
                getNewLocation()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentScores = getHighScores()
        print("Current highscores: ", currentScores)
        
        mapView.delegate = self
        mapView.mapType = .satellite
        
        getLocations()
        getNewLocation()
        progressView.frame.size = CGSize(width: 0, height: 0)
        
        print("Game type: \(gameType)")
    }

    func getLocations() {
        
        var fileName: String = String()
        
        if (gameType == "Cities") {
            fileName = "locations"
        }
        else {
            fileName = "landmarks"
        }
        
        let filePath = Bundle.main.path(forResource: fileName, ofType: "txt")
        let fileURL = URL(fileURLWithPath: filePath!)
        var locationsData = String()
        
        do {
            locationsData = try String(contentsOf: fileURL, encoding: .utf8)
        }
        catch {/* error handling here */}
        
        let locationsArray = locationsData.components(separatedBy: "\n")
        
        for line in locationsArray {
            // Fix to avoid crash for empty rows when parts[1] would crash
            if line.count < 2 {
                continue
            }
            let parts = line.components(separatedBy: "|")
            
            locationsAndCoordinates[parts[0]] = parts[1]
        }
        
    }
    
    @objc func getNewLocation() {
        
        // If there are no elements left in collection return early
        if locationsAndCoordinates.isEmpty { return }
        
        // Update UI state
        doneButton.setTitle("Done", for: .normal)
        removeAnnotations()
        level += 1
        
        resetZoom()
        
        // Pull a random place from locationsAndCoordinates dictionary and update correctLocation to new value
        let randomInt = Int.random(range: 0..<locationsAndCoordinates.count)
        
        let location = Array(locationsAndCoordinates)[randomInt].key
        let coords = Array(locationsAndCoordinates)[randomInt].value
        cityNameLabel.text = "\(level). Find \(location)"
        
        let coordsArray = coords.components(separatedBy: " ")
        print("Random location: \(location), lat: \(coordsArray[0]) lon: \(coordsArray[1])")
        
        correctLocation = CLLocation(latitude: (coordsArray[0] as NSString).doubleValue, longitude: (coordsArray[1] as NSString).doubleValue)
        
        
        // Remove used locations from array
        locationsAndCoordinates.removeValue(forKey: location)
        
    }
    
    func resetZoom() {
        let coords = CLLocationCoordinate2D(latitude: 36.7213, longitude: 4.4214)
        let region = MKCoordinateRegion(center: coords, latitudinalMeters: 10000000, longitudinalMeters: 10000000)
        
        mapView.setRegion(region, animated: true)
    }
    
    func removeAnnotations() {
        let allAnnotations = mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
    }
    
    func addAnnotation(coords: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coords
        
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pinAnnotationView.pinTintColor = .green
        mapView.addAnnotation(annotation)
        guess = annotation
    }
    
    func startNewGame() {
        // Reset the UI
        level = 0
        score = 0
        scoreLabel.text = String("Points: \(score)")
        getLocations()
        
        getNewLocation()
    }
    
    func updateProgressBar() {
        let newHeight = Int(view.frame.width) / 10 * level
        let newSize = CGSize(width: newHeight, height: 7)
        progressView.frame.size = newSize
    }
    
    func addHighScore() {
        let currentDate = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = formatter.string(from: currentDate)
        
        // Write score to Documents directory for persistant storage
        let highscore = String(String(score) + " " + formattedDate + "\n")
        let fileURL = highscoreDir!.appendingPathComponent("highscores")
        
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        
        if let pathComponent = url.appendingPathComponent("highscores") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
                // Append results
                do {
                    let fileHandle = try FileHandle(forWritingTo: fileURL)
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(highscore.data(using: .utf8)!)
                    fileHandle.closeFile()
                } catch {
                    print("Error writing to file \(error)")
                }
            } else {
                print("FILE NOT AVAILABLE")
                // Create file, append results
                fileManager.createFile(atPath: filePath, contents: highscore.data(using: .utf8), attributes: nil)
                
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
            // Error
        }
        

    }
    
    func getHighScores() -> String {
        
        var highscores = ""
        
        do {
            let filePath = highscoreDir!.appendingPathComponent("highscores")
            highscores = try String(contentsOf: filePath, encoding: .utf8)
        }
        catch {
            print("Error reading highscores directory.")
        }

        return highscores
    }

}

