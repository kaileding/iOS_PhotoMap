//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cameraButton: UIButton!
    
    var chosenImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let side = self.cameraButton.frame.width
        cameraButton.layer.cornerRadius = side/2.0
        cameraButton.clipsToBounds = true
        cameraButton.backgroundColor = UIColor.white
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                              MKCoordinateSpanMake(0.1, 0.1))
        self.mapView.setRegion(sfRegion, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tagSegue" {
            let locationsVC = segue.destination
            (locationsVC as! LocationsViewController).delegate = self
        }
    }

    
    // delegate functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.chosenImage = originalImage
        // let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "tagSegue", sender: nil)
        })
    }
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
        annotation.title = "Picture!"
        self.mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        print("\n\n ---- called mapView(viewFor annotation) function once ------- \n\n")
        
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = UIImage(named: "camera")
        
        return annotationView
    }
    
    
    
    // helper functions
    @IBAction func onCameraButton(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            vc.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    
}
