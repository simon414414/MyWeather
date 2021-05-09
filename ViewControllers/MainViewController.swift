//
//  MainViewController.swift
//  Weather
//
//  Created by Simon on 5/5/2021.
//

import UIKit
import CoreLocation


class MainViewController: UIViewController {

    @IBOutlet weak var searchTypeSwitch: UISegmentedControl!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    var currentType:SearchType?
    let locationManager = CLLocationManager()
    var isProcessingGPSRequest = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initSearch()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getWeather(notification:)), name: Notification.Name("GetCurrentWeather"), object: nil)

        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "History", style: .plain, target: self, action: #selector(showHistory))
        
        locationManager.delegate = self
        
        //Add gesture to dismiss keyborad
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)

        //Search by last record when app launch
        initSearch()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initSearch()  {
        let records = SearchRecordManager.sharedInstance.getRecords()
        if records.count > 0, let record =  records.first{
            WeatherUtil.sharedInstance.getCurrentWeather(criteria: record) { result in
                self.displayResponse(record: record, jsonResponse: result as! [String : Any])
            }
        }
    }
    
    func startSearch(input:String!) {
        
        let criteria = SearchRecord(type: searchTypeSwitch.selectedSegmentIndex == 0 ? .city : .zipCode)
        criteria.input = input
        WeatherUtil.sharedInstance.getCurrentWeather(criteria: criteria) { result in
            
            SearchRecordManager.sharedInstance.addRecord(record: criteria)
            self.displayResponse(record: criteria, jsonResponse: result as! [String : Any])
        }
    }
    
    func displayResponse(record:SearchRecord, jsonResponse:[String:Any]) {
        var resultString = "Search by \(record.type!)"
        if record.type != .GPS {
            resultString += " : \(record.input ?? "")"
        }
        resultString += "\n\n"
        
        if let main = jsonResponse["main"] as? [String:Any]{
            if let temp = main["temp"] {
                resultString += "Temperature: \(temp)°C \n"
            }
            
            if let max_temp = main["temp_max"] {
                resultString += "Max. Temperature: \(max_temp)°C \n"
            }
            
            if let min_temp = main["temp_min"] {
                resultString += "Min. Temperature: \(min_temp)°C \n"
            }
            
            if let humidity = main["humidity"] {
                resultString += "Humidity: \(humidity)% \n"
            }
            
        }
        
        resultTextView.text = resultString
    }
    
    func getWeatherByLocation(_ location:CLLocation)  {
        let criteria = SearchRecord(type: .GPS)
        criteria.longitude = "\(location.coordinate.longitude)"
        criteria.latitude = "\(location.coordinate.latitude)"
        WeatherUtil.sharedInstance.getCurrentWeather(criteria: criteria) { result in
            
            SearchRecordManager.sharedInstance.addRecord(record: criteria)
            self.displayResponse(record: criteria, jsonResponse: result as! [String : Any])
            self.isProcessingGPSRequest = false
        }
    }
    
    @IBAction func startSearch(sender:UIButton){
        self.view.endEditing(true)
        if let text = inputTextField.text {
            startSearch(input: text)
        }
    }
    
    @objc func showHistory() {
        let vc = SearchRecordTableViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func checkLocationPermission(){
        //Check on current authorization status
        if  locationManager.authorizationStatus == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        } else {
            let status = locationManager.authorizationStatus

            switch status {
            case .authorizedAlways,.authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            case .denied:
                let alert = UIAlertController(title: "Turn on location service to allow \"My Weather\" to determine you location", message: "", preferredStyle:.alert)
                
                
               
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { action in
                    if let url = NSURL(string:UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    
                }))
                self.present(alert, animated: false, completion: nil)
            default:
                break
            }
        }
        
        
    }
    
    @objc func getWeather(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let criteria = userInfo["criteria"]! as! SearchRecord
        WeatherUtil.sharedInstance.getCurrentWeather(criteria: criteria) { result in
            
            SearchRecordManager.sharedInstance.addRecord(record: criteria)
            self.displayResponse(record: criteria, jsonResponse: result as! [String : Any])
        }
    }
    
    @IBAction func didClickSearchByLocation(sender:Any){
        checkLocationPermission()
    }
    
}

extension MainViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if let text = textField.text , text.count > 0 {
            startSearch(input: text)
        }
        self.view.endEditing(true)
        return true
    }
}

extension MainViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Get location once
        manager.stopUpdatingLocation()
        
        if !isProcessingGPSRequest {
            isProcessingGPSRequest = true
            if let location = locations.first {
                getWeatherByLocation(location)
            }else {
                isProcessingGPSRequest = false
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationPermission()
    }
}
