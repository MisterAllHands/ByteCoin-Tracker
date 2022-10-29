//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
protocol CoinManagerDelegate {
    func didUpdatePrice(price: Double)
    func didFailWithError(_ error: Error)
}
struct CoinManager {
    // this var allows to set any controller as a delegate
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "3A5774F8-0C2F-41F2-B1B7-37546DEEE84F"
    
    //Currecy array will be displayed on the picker as picker choices.
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
//MARK: - getCoinPrice
    //Function gets the currency and makes request to coinapi website to get the last bitcoin price.
    func getCoinPrice (for currency: String) {
        if let url = URL(string: "\(baseURL)\(currency)?apikey=\(apiKey)"){
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url){ data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error!)
                    return
                }
    
            //Safe unwarapping data and asigning it into a new constant
                if let safeData = data {
            // Safe unwrapping safe data from ParsedJSON and asigning it to a new constant weather.
                    if let bitcoinPrice = self.parseJSON(safeData){
                        delegate?.didUpdatePrice(price: bitcoinPrice)
                    }
                    
                    //In here we set the external parametr as omiting so we cab simply just type safeData as datatype without mentioning paratemtr for the datatype
                }
            }
            //Make the API call
            task.resume()
        }
    }
    
//MARK: - parseJSOn
    
    //Parsing data with the function
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        //Use do in case if there is any error to catch.
        do {
            //Using try because the JSON can throw an error and to be able to catch and handle it we use try
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            return lastPrice
        //If there is an error, it catches and tells the delegate to return nill
        }catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
