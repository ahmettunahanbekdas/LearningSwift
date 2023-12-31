//
//  Places.swift
//  Project 22- FoursquareClone
//
//  Created by Ahmet Tunahan Bekdaş on 14.12.2023.
//

import UIKit
import Parse

class Places: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    // MARK: - @IBOutlet and Variables
    
    @IBOutlet weak var tableView: UITableView!
    
    var placeNameArray = [String]()
    var placeIDArray = [String]()
    var selectedPlaceID: String?
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addPlaces))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: UIBarButtonItem.Style.done, target: self, action: #selector(logOut))
        
            getData()
    }
    
    // MARK: - getData

    func getData(){
        let query = PFQuery(className: "Place")
        
        query.findObjectsInBackground { objects, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            } else {
                if objects != nil {
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.placeIDArray.removeAll(keepingCapacity: false)
                    for object in objects! {
                        if let placeName = object.object(forKey: "name")as? String{
                            if let placeID = object.objectId{
                                self.placeNameArray.append(placeName)
                                self.placeIDArray.append(placeID)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - prepare

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsPlaces" {
            let destinationVC = segue.destination as! DetailsPlaces
            destinationVC.chosenPlaceID = selectedPlaceID
        }
    }
    // MARK: - didSelectRowAt

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceID = placeIDArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsPlaces", sender: nil)
    }
    
    // MARK: - addPlaces
    
    @objc func addPlaces(){
        performSegue(withIdentifier: "toAddView", sender: nil)
    }
    
    // MARK: - logOut
    
    @objc func logOut(){
        PFUser.logOutInBackground { error in
            if error != nil {
                self.makeAlert(title: "Error", message: error!.localizedDescription)
            }else{
                self.performSegue(withIdentifier: "toLoginPage", sender: nil)
            }
        }
    }
    
    
    // MARK: - numberOfRowsInSection

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    
    // MARK: - cellForRowAt

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    
    /*
     
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Tabloda silme işlemini gerçekleştir
                placeNameArray.remove(at: indexPath.row)
                placeIDArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)

                // Parse veritabanından ilgili veriyi sil
                if let placeIDToDelete = placeIDArray[safe: indexPath.row] {
                    deletePlaceFromParse(placeID: placeIDToDelete)
                }
            }
        }
    
    func deletePlaceFromParse(placeID: String) {
           let query = PFQuery(className: "Place")
           query.getObjectInBackground(withId: placeID) { object, error in
               if error != nil {
                   self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Hata")
               } else {
                   if let objectToDelete = object {
                       objectToDelete.deleteInBackground { success, error in
                           if success {
                               // Silme işlemi başarılı
                               print("Yer Parse üzerinden silindi.")
                           } else if let error = error {
                               // Silme işlemi başarısız
                               self.makeAlert(title: "Hata", message: error.localizedDescription)
                           }
                       }
                   }
               }
           }
       }
    
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
     */
    
}
