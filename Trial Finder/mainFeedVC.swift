//
//  mainFeedVC.swift
//  Trial Finder
//
//  Created by Iran Mateu on 10/10/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import CoreLocation
import Localize_Swift

class mainFeedVC: UIViewController {
    
    // MARK: Properties
    
    let userDefaults = UserDefaults.standard
    
    var locationManager: CLLocationManager!
    var isLocationEnabled: Bool = false

    var trials = [Trial]()
    var filteredTrials: [Trial] = []
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    // Right bar button items
    var filterBarButtonItem: UIBarButtonItem!
    var zipCodeBarButtonItem: UIBarButtonItem!
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    // MARK: Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var zipcodeButton: UIButton!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    // MARK: Actions
    // MARK: Actions
    
    @IBAction func showMenu(_ sender: AnyObject) {
//        self.revealViewController().revealToggle(sender)
    }
    
    @IBAction func filter(_ sender: AnyObject) {
        if trials.count > 0 {
            performSegue(withIdentifier: "ShowFilter", sender: nil)
        }
    }
    
    @IBAction func changeZipcode(_ sender: AnyObject) {
        askZipcode()
    }
    
    // MARK: Lif Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
  //    self.setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        // Location bar item
        /*
        self.filterBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "ic_sort_white_48pt"), style: .plain, target: self, action: #selector(filter))
        self.zipCodeBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "ic_my_location_white_48pt"), style: .plain, target: self, action: #selector(askZipcode))
        self.zipCodeBarButtonItem.imageInsets = UIEdgeInsets.init(top: 4, left: 4, bottom: 4, right: 4)
        
        self.title = "Main Feed"
 
        
        // Set right bar button items
        self.navigationItem.rightBarButtonItems = [self.filterBarButtonItem, self.zipCodeBarButtonItem]
        */
        
        /** show activity indicator **/
        self.showActivityIndicator(isShow: true, activityIndicatorView: self.activityIndicator)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // user location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // SWRevealViewController
//       view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
//       view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//       self.revealViewController().frontViewShadowColor = UIColor.clear
        
        noResultsLabel.isHidden = true
        obseverTrials {
            (trial) in
            self.trials.append(trial)
            self.reloadData()
        }
    }
    /*
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    */
    func setText() {
        titleLabel.text = "Main Feed".localized()
        searchBar.placeholder = "Search".localized()
        searchBar.setValue("Cancel".localized(), forKey:"_cancelButtonText")
        let distanceIndex = getFilterDistanceIndex()
        noResultsLabel.text = "No trials found within a \(distanceIndex) mile radius of your location".localized()
    }
    
    func getFilterDistanceIndex() -> Int {
        let sliderValue = userDefaults.double(forKey: TFUserDefaultsKeys.Distance)
        switch sliderValue {
        case 0:
            return 0
        case 1:
            return 5
        case 2:
            return 10
        case 3:
            return 20
        case 4:
            return 30
        default:
            return 50
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
        reloadData()
        setText()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "ShowTrialDetails" {
                if let trial = sender as? Trial {
                    let detailsVC = segue.destination as! detailsVC
                    detailsVC.trial = trial
                }
            } else if identifier == "ShowFilter" {
                let pickerVC = segue.destination as! PickerViewController
                pickerVC.trials = self.trials
            }
        }
    }

    // MARK: Functions
    
    func obseverTrials(completion: @escaping (_ trial: Trial) -> Void) {
        DataService.ds.REF_TRIALS.observe(.value, with: { (snapshot) in
            
            
            self.trials.removeAll()
            self.filteredTrials.removeAll()
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    
                    if let trialDict = snap.value as? Dictionary<String, AnyObject> {
                        if let sitesString = trialDict["sites"] as? String {
                            
                            // convert string of sites to array of string by comma seperator
                            for string in sitesString.components(separatedBy: ",") {
                                let key = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                                self.obseverSite(siteId: key, completion: { (site) in
                                    
                         
                                    let trial = Trial(trialKey: snap.key, postData: trialDict)
                                    trial.site = site
                                    
                                    // check has this trial or not
                                    if self.trials.filter({ $0.trialKey == snap.key }).first?.site.id == key {
                                        return
                                    }
                                    
                                    completion(trial)
                                })
                            }
                        }
                    }
                }
            }
        })
    }
    
    func obseverSite(siteId: String, completion: @escaping (_ site: Site) -> Void) {
        
        DataService.ds.REF_SITES.child(siteId).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.value as? [String: AnyObject] {
                
                /** stop activity indicator **/
                
                self.showActivityIndicator(isShow: false, activityIndicatorView: self.activityIndicator)
                
                let site = Site(dict: snapshot)
                site.id = siteId
                completion(site)
            }
        })
    }
    
    // MARK: Sort & Filter
    
    func reloadData() {
    
        filteredTrials = searchTrials(trials: trials, searchText: searchBar.text ?? "")
        filteredTrials = sortTrials(trials: filteredTrials)
        filteredTrials = filterTrials(trials: filteredTrials)
        
        tableView.reloadData()
        
        noResultsLabel.isHidden = filteredTrials.count != 0 || activityIndicator.isAnimating
        tableView.isScrollEnabled = filteredTrials.count != 0
    }
    
    func sortTrials(trials: [Trial]) -> [Trial] {
        let index = userDefaults.value(forKey: TFUserDefaultsKeys.Sort) as? Int ?? 0
        
        var trials = trials
        if index == 0 { // Closest site
            trials = trials.sorted(by: { $0.site.distance < $1.site.distance })
        } else if index == 1 { // Newest trial posted
            trials = trials.sorted(by: { $0.date > $1.date })
        } else if index == 2 { // Oldest trial posted
            trials = trials.sorted(by: { $0.date < $1.date })
        }
        return trials
    }
    
    func filterTrials(trials: [Trial]) -> [Trial] {
        var trials = trials
        
        trials = filterTrialsByDistance(trials: trials)
        trials = filterTrialsBySiteName(trials: trials)
        trials = filterTrialsByStudyType(trials: trials)
        
        return trials
    }
    
    func filterTrialsByDistance(trials: [Trial]) -> [Trial] {
        let sliderValue = userDefaults.value(forKey: TFUserDefaultsKeys.Distance) as? Float
        
        var distance: Double?
        if let sliderValue = sliderValue, isLocationEnabled {
            let index = Int(sliderValue)
            distance = index < TFConstants.Distances.count ? TFConstants.Distances[index] : nil
        }
        
        var trials = trials
        if let distance = distance {
            trials = trials.filter({ $0.site.distance <= distance })
        }
        
        return trials
    }
    
    func filterTrialsBySiteName(trials: [Trial]) -> [Trial] {
        var trials = trials
        if let siteName = userDefaults.value(forKey: TFUserDefaultsKeys.SiteName) as? String {
            trials = trials.filter({ $0.site.name == siteName })
        }
        return trials
    }
    
    func filterTrialsByStudyType(trials: [Trial]) -> [Trial] {
        var trials = trials
        if let studyType = userDefaults.value(forKey: TFUserDefaultsKeys.StudyType) as? String {
            trials = trials.filter({ $0.trialKey == studyType })
        }
        return trials
    }
    
    func askZipcode() {
        
        let currentZipcode = UserDefaults.standard.value(forKey: KEY_ZIPCODE) as? String
        
        let alert = UIAlertController(title: "Trials".localized(), message: "Enter a zip code".localized(), preferredStyle: .alert)
        alert.view.tintColor = UIColor(red: 255.0 / 255.0, green: 49.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
        alert.addTextField {
            $0.placeholder = "Zip code".localized()
            $0.keyboardType = .numberPad
            $0.text = currentZipcode
            $0.clearButtonMode = .whileEditing
        }
        
        if !isLocationEnabled {
            // Enable Location
            let enableLocationAction = UIAlertAction(title: "Enable Location".localized(), style: .default) { (action) in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            }
            alert.addAction(enableLocationAction)
            alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        }
        
        // OK
        let okAction = UIAlertAction(title: "OK".localized(), style: .default) { (action) in
            
            guard let zipcode = alert.textFields?[0].text else {
                return
            }
            
            self.updateMainFeed(zipcode: zipcode, countryCode: "US")
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func filter() {
        if trials.count > 0 {
            performSegue(withIdentifier: "ShowFilter", sender: nil)
        }
    }
    
    func updateMainFeed(zipcode: String, countryCode: String) {
        
        GMSClient.shared.getLocation(zipcode: zipcode, countryCode: countryCode) { (location, error) in
            
            if let error = error {
                print(error.localizedDescription)
                
                AppState.userLocation = nil
                
                DispatchQueue.main.async {
                    self.reloadData()
                    self.showAlert(message: "Please enter a valid zip code".localized())
                }
                return
            }
            
            UserDefaults.standard.set(zipcode, forKey: KEY_ZIPCODE)
            AppState.userLocation = location
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Trials".localized(), message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor(red: 255.0 / 255.0, green: 49.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension mainFeedVC: UITableViewDelegate, UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTrials.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trial = filteredTrials[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TrialCell") as? TrialCell {
            
            // RSI
            cell.configureCell(trial: trial)
            return cell
            
        } else {
            return TrialCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let trial = filteredTrials[indexPath.row]
        performSegue(withIdentifier: "ShowTrialDetails", sender: trial)
    }
}

extension mainFeedVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            AppState.userLocation = location
            self.trials = self.trials.map({ (trial) -> Trial in
                let newTrial = trial
                newTrial.site.updateLocation()
                return newTrial
            })
            self.reloadData()
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status != .notDetermined else { return }
        
        isLocationEnabled = false
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            isLocationEnabled = true
        }
        
        zipcodeButton.isHidden = isLocationEnabled
        
        if let zipcode = UserDefaults.standard.value(forKey: KEY_ZIPCODE) as? String, !zipcode.isEmpty {
            updateMainFeed(zipcode: zipcode, countryCode: "US")
        } else {
            if !isLocationEnabled { askZipcode() }
        }
    }
}

extension mainFeedVC: UISearchBarDelegate {
    
    func searchTrials(trials: [Trial], searchText: String) -> [Trial] {
        var trials = trials
        let searchText = searchText.lowercased()
        
        if !searchText.isEmpty {
            trials = trials.filter({ (trial) -> Bool in
                
                if trial.site.name.lowercased().contains(searchText) { // Site name
                    return true
                } else if trial.studyName.lowercased().contains(searchText) { // Study name
                    return true
                } else if  trial.trialKey.lowercased().contains(searchText) { // Study type
                    return true
                } else if trial.site.address.lowercased().contains(searchText) { // City
                    return true
                } else if trial.site.zipCode.lowercased().contains(searchText) { // Zip code
                    return true
                }
                
                return false
            })
        }
        return trials
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.text = ""
        reloadData()
    }
}
