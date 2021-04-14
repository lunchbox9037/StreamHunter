//
//  LocationSelectionViewController.swift
//  uStream
//
//  Created by stanley phillips on 4/12/21.
//

import UIKit

class LocationSelectionViewController: UIViewController {
    private var supportedCountries: [[String:String]] = [
        ["United States": "US"],
        ["Canada": "CA"],
        ["Mexico": "MX"],
        ["Peru": "PE"],
        ["Chile": "CL"],
        ["Argentina": "AR"],
        ["Brazil": "BR"],
        ["Colombia": "CO"],
        ["Japan": "JP"],
        ["Thailand": "TH"],
        ["South Korea": "KR"],
        ["India": "IN"],
        ["United Kingdom": "GB"],
        ["Spain": "ES"],
        ["France": "FR"],
        ["Belgium": "BE"],
        ["Germany": "DE"],
        ["South Africa": "ZA"],
        ["Australia": "AU"],
        ["New Zealand": "NZ"]
    ]
    
    private var selectedCountryCode = "US"
    
    // MARK: - Views
    lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Functions
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(picker)
        picker.dataSource = self
        picker.delegate = self
        
        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveLocation))
        navigationItem.setRightBarButton(save, animated: true)
        navigationItem.title = "Select a Supported Country"

        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            picker.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            picker.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
        ])
    }
    
    @objc private func saveLocation() {
        UserDefaults.standard.setValue(self.selectedCountryCode, forKey: "countryCode")
        self.presentLocationSelectedAlert(cc: self.selectedCountryCode)
    }
}//end class

extension LocationSelectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return supportedCountries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return supportedCountries[row].keys.first
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountryCode = supportedCountries[row].values.first ?? "US"
    }
}
