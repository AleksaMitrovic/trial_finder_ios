//
//  SelectionViewController.swift
//  Trial Finder
//
//  Created by Huynh Danh on 10/26/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit
import Localize_Swift

typealias TFItem = (title: String, isSelected: Bool)
typealias TFGroup = (title: String, items: [TFItem])

struct TFUserDefaultsKeys {
    static let Sort = "sort"
    static let Distance = "distance"
    static let SiteName = "site_name"
    static let StudyType = "study_type"
}

struct TFConstants {
    static let Distances: [Double] = [0.0, 8046.72, 16093.4, 32186.9, 48280.3, 80467.2] // 0, 5, 10, 20, 30 miles
}

class PickerViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    
    var trials: [Trial] = []
    
    var items: [TFGroup] = [
        (title: "Sort by".localized(), items: [
            (title: "Closest site".localized(), isSelected: false),
            (title: "Newest trial posted".localized(), isSelected: false),
            (title: "Oldest trial posted".localized(), isSelected: false),
            ]),
        (title: "Distance".localized(), items: []),
        (title: "Name of site".localized(), items: []),
        (title: "Type of study".localized(),  items: []),
        ]

    
    var sliderValue: Float?
    var siteName: String?
    var studyType: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func apply(_ sender: AnyObject) {
        
        // save sort
        saveValue(getSelectedItemIndex(items[0]), forKey: TFUserDefaultsKeys.Sort)
        saveValue(siteName, forKey: TFUserDefaultsKeys.SiteName)
        saveValue(studyType, forKey: TFUserDefaultsKeys.StudyType)
        
        // Distance
        userDefaults.set(sliderValue, forKey: TFUserDefaultsKeys.Distance)
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        items[0].items = selectedItem(items[0], at: userDefaults.value(forKey: TFUserDefaultsKeys.Sort) as? Int)
        siteName = userDefaults.value(forKey: TFUserDefaultsKeys.SiteName) as? String
        studyType = userDefaults.value(forKey: TFUserDefaultsKeys.StudyType) as? String
        sliderValue = userDefaults.value(forKey: TFUserDefaultsKeys.Distance) as? Float
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        setText()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        
        reloadData(slideValue: sliderValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
         let backBt = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(backClick))
                backBt.tintColor = UIColor.black
                self.navigationItem.leftBarButtonItem = backBt
        super.viewWillAppear(animated)
    }
    
    func setText() {
        self.title = "Sort & Filter".localized()
    }
    
    func backClick() {
        self.navigationController?.popViewController(animated: true)
    }

    
    func selectedItem(_ group: TFGroup, at index: Int?) -> [TFItem] {
        var items = group.items
        let index = min(max(index ?? 0, 0), items.count - 1)
        for i in 0..<items.count {
            items[i].isSelected = false
        }
        items[index].isSelected = true
        return items
    }
    
    func getSelectedItemIndex(_ group: TFGroup) -> Int? {
        let items = group.items
        for i in 0..<items.count {
            if items[i].isSelected {
               return i
            }
        }
        return nil
    }
    
    func saveValue(_ value: Any?, forKey key: String) {
        if let value = value {
            userDefaults.set(value, forKey: key)
        } else {
            userDefaults.removeObject(forKey: key)
        }
    }
    
    func reloadData(slideValue: Float?) {
        var distance: Double?
        if let sliderValue = sliderValue {
            let index = Int(sliderValue)
            distance = index < TFConstants.Distances.count ? TFConstants.Distances[index] : nil
        }
        
        // Site of Name
        var siteNames = getSiteNames(distance: distance)
        siteNames.insert("All", at: 0)
        items[2].items = getItemsFrom(strings: siteNames)
        
        let siteNameIndex = siteName != nil ? siteNames.index(of: siteName!) : nil
        items[2].items = selectedItem(items[2], at: siteNameIndex)
        
        // Type of Study
        var studyTypes = getStudyTypes(distance: distance)
        studyTypes.insert("All", at: 0)
        items[3].items = getItemsFrom(strings: studyTypes)
        
        let studyTypeIndex = studyType != nil ? studyTypes.index(of: studyType!) : nil
        items[3].items = selectedItem(items[3], at: studyTypeIndex)
        
        tableView.reloadData()
    }
    
    func getItemsFrom(strings: [String]) -> [TFItem] {
        var items: [TFItem] = []
        for string in strings {
            let item = (title: string, isSelected: false)
            items.append(item)
        }
        return items
    }
    
    func getSiteNames(distance: Double? = nil) -> [String] {
        let strings = trials.map { (trial) -> String in
            guard let distance = distance else {
                return trial.site.name
            }
            
            print("site distance \(trial.site.name) : \(trial.site.distance)")
            if trial.site.distance <= distance {
                return trial.site.name
            }
            
            return ""
        }
        return Array(Set(strings.filter({ !$0.isEmpty })))
    }
    
    func getStudyTypes(distance: Double? = nil) -> [String] {
        let strings = trials.map { (trial) -> String in
            guard let distance = distance else {
                return trial.trialKey
            }
            
            if trial.site.distance <= distance {
                return trial.trialKey
            }
            
            return ""
        }
        return Array(Set(strings.filter({ !$0.isEmpty })))
    }
}

extension PickerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return items[section].items.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! SelectionTableViewCell
        cell.titleLabel.text = items[section].title.uppercased()
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell") as! SelectionTableViewCell
        
        if indexPath.section == 1 { // Distance
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceCell") as! DistanceTableViewCell
            cell.delegate = self
            cell.distanceSlider.value = sliderValue ?? cell.distanceSlider.maximumValue
            return cell
        }
        
        let item = items[indexPath.section].items[indexPath.row]
        cell.titleLabel.text = item.title
        cell.checkImageview.isHidden = !item.isSelected
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 { // Distance
            return 80.0
        }
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            return
        }
        let group = items[indexPath.section]
        
        items[indexPath.section].items = selectedItem(group, at: indexPath.row)
        
        // cache data
        let selectedTitle = group.items[indexPath.row].title
        if indexPath.section == 2 {
            siteName = (indexPath.row != 0) ? selectedTitle : nil
        } else if indexPath.section == 3 {
            studyType = (indexPath.row != 0) ? selectedTitle : nil
        }
        
        tableView.reloadData()
    }
}

extension PickerViewController: DistanceTableViewCellDelegate {
    
    func didSliderChangeValue(value: Float) {
        sliderValue = value
        reloadData(slideValue: sliderValue)
    }
}
