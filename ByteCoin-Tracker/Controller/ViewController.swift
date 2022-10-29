//
//  ViewController.swift
//  ByteCoin-Tracker
//
//  Created by TTGMOTSF on 29/10/2022.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    var price = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
}
//MARK: - UIPickerViewDataSourse, UIPickerViewDelegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    //Sets bumber of picker components in the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
    }

    //Number of rows meaning items in the picker are as much as in the string array in CoinManager
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            coinManager.currencyArray.count
    }
        
    //This method expects a String as an output. The String is the title for a given row.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            coinManager.currencyArray[row]
    }
    //Asigns values to IBOutlests once user selected a row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            
        let selectedCurrency = coinManager.currencyArray[row]
        currencyLabel.text = selectedCurrency
        //Price will get printed based on user's picked currency
        coinManager.getCoinPrice(for: selectedCurrency)
        bitcoinLabel.text = price
    }
}
//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
   // The Func Converts the data into string helping us to asign it as a bitcon text in the bitcoinLabel.text that expects String
    func didUpdatePrice(price: Double) {
        self.price = String(format: "%.2f", price)
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}
   

