//
//  ViewController.swift
//  HackProductARH
//
//  Created by Togba Liberty on 7/27/17.
//  Copyright © 2017 ToTelLity. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit
import Alamofire
import CoreLocation


class ViewController: UIViewController, ARSKViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var sceneView: ARSKView!
    
    var locationManager:CLLocationManager?
    
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
        
        //Location initialization
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        locationManager?.requestAlwaysAuthorization()
        
        // Get the listings
        fetchListings()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations[0]
        print(self.currentLocation.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSKViewDelegate
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        let parentNode = SKSpriteNode(color: .orange, size: CGSize(width: 50, height: 25))
        parentNode.zPosition = 10
        
        let labelNode = SKLabelNode(text: "Price: $200,000\nBeds: 3 * Baths: 2\nAddress: 1492 Round Hill Dr\nCity: Virginia Beach State: VA")
        labelNode.fontColor = .blue
        labelNode.fontSize = 4
        labelNode.numberOfLines = 4
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        labelNode.zPosition = 15
        
        parentNode.addChild(labelNode)
        return parentNode;
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func fetchListings() {
        Alamofire.request("https://heliosapi.homes.com/v1/listings/search?api_key=1-hdca-jOloeQJt4gNYZQiXEpuzse&pagesize=25&page=1&fl=address,baths,beds,city,lat,lng,price&lat.min=36.79563630056295&lat.max=36.89800536203471&lng.min=-76.32505706771416&lng.max=-76.24505706802798").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
}
