//
//  ViewController.swift
//  Near
//
//  Created by John Vu on 2017-02-27.
//  Copyright © 2017 John Vu. All rights reserved.
//

import Alamofire
import CoreLocation
import SwiftyJSON
import UIKit

// The Instagram Access Token
let accessToken = ""

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var NearCollectionView: UICollectionView!
    let locationManager = CLLocationManager()
    var results:[JSON]? = [] // Results can be nil or contain a value
    
    /// Use local images
    var images = ["1", "2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* Setup location manager */
        // Get user authorisation.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        /* Setup collection view */
        self.NearCollectionView.delegate = self
        self.NearCollectionView.dataSource = self
        
        /* Load Images */
        /// Enable if using Instagram API
//        self.loadImages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: collectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /// Use local images
        return images.count
        
        /// Enable if using Instagram API
//        return self.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! NearCollectionViewCell
        /// Use local images
        cell.nearImageView.image = UIImage(named: images[indexPath.row])
        
        /// Enable if using Instagram API
//        cell.image = self.results?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("SELECTED ROW IS: ", indexPath.row)
    }
    
// MARK: locationManager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Print out location in console
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
// MARK: functions
    
    func loadImages() {
        let location : CLLocationCoordinate2D = locationManager.location!.coordinate
        let urlString = "https://api.instagram.com/v1/media/search?lat=\(location.latitude)&lng=\(location.longitude)&access_token=\(accessToken)"
        Alamofire.request(urlString).responseJSON {response in
            if (response.result.value != nil) {
                var jsonObj = JSON(response.result.value!) // Convert JSON dictionary into object using SwiftyJSON
                if let data = jsonObj["data"].arrayValue as [JSON]? {
                    self.results = data
                    self.NearCollectionView.reloadData()
                }
            }
        }
    }
    
}

