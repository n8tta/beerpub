//
//  ViewController.swift
//  HW_32_Pub_Realm
//
//  Created by Natallia Valadzko on 10.04.21.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var budRemaindersLabel: UILabel!
    @IBOutlet weak var coronaRemaindersLabel: UILabel!
    @IBOutlet weak var becksRemaindersLabel: UILabel!
    
    @IBOutlet weak var budOrderLabel: UILabel!
    @IBOutlet weak var coronaOrderLabel: UILabel!
    @IBOutlet weak var becksOrderLabel: UILabel!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var budMinusBtn: UIButton!
    @IBOutlet weak var budPlusBtn: UIButton!
    @IBOutlet weak var coronaMinusBtn: UIButton!
    @IBOutlet weak var coronaPlusBtn: UIButton!
    @IBOutlet weak var becksMinusBtn: UIButton!
    @IBOutlet weak var becksPlusBtn: UIButton!
    @IBOutlet weak var sellBtn: UIButton!
    @IBOutlet weak var endButton: UIButton!
    
    //MARK: - Variables
    var realm: Realm?
    
    //MARK: - Constants
    let pub = Pub()
    let budBeer = Beer()
    let coronaBeer = Beer()
    let becksBeer = Beer()
    
    //MARK: - Life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
            print(fileURL)
        }
        
        var configuration = Realm.Configuration()
        configuration.deleteRealmIfMigrationNeeded = true
        
        do {
            realm = try Realm(configuration: configuration)
        } catch let error as NSError {
            print("Error is \(error)")
        }
        
        disactivateButtons()
    }
    
    //MARK: - Flow functions
    func disactivateButtons() {
        budMinusBtn.isEnabled = false
        budPlusBtn.isEnabled = false
        coronaMinusBtn.isEnabled = false
        coronaPlusBtn.isEnabled = false
        becksMinusBtn.isEnabled = false
        becksPlusBtn.isEnabled = false
        sellBtn.isEnabled = false
        endButton.isEnabled = false
    }
    
    func activateButtons() {
        budMinusBtn.isEnabled = true
        budPlusBtn.isEnabled = true
        coronaMinusBtn.isEnabled = true
        coronaPlusBtn.isEnabled = true
        becksMinusBtn.isEnabled = true
        becksPlusBtn.isEnabled = true
        sellBtn.isEnabled = true
        endButton.isEnabled = true
    }
    
    func loadBase() {
        let rBeers = realm?.objects(Beer.self)
        print("\(String(describing: rBeers))")
        
        let rPub = realm?.objects(Pub.self)
        print("\(String(describing: rPub))")
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        activateButtons()
        loadBase()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM, hh:mm"
        formatter.timeZone = .current
        let dateString = formatter.string(from: date)
        
        pub.date = dateString
        
        budBeer.date = dateString
        budBeer.brand = "Bud"
        budBeer.price = 5.0
        budBeer.available = 100
        budBeer.currentStock = 100
        budBeer.morningStock = 100

        coronaBeer.date = dateString
        coronaBeer.brand = "Corona"
        coronaBeer.price = 7.0
        coronaBeer.available = 100
        coronaBeer.currentStock = 100
        coronaBeer.morningStock = 100

        becksBeer.date = dateString
        becksBeer.brand = "Becks"
        becksBeer.price = 9.0
        becksBeer.available = 100
        becksBeer.currentStock = 100
        becksBeer.morningStock = 100

        let beersArray = [budBeer, coronaBeer, becksBeer]
        
        pub.beers.append(objectsIn: beersArray)
        
        do {
            try realm?.write({
                realm?.add(pub)
            })
        } catch let error {
            print(error)
        }
        
        budRemaindersLabel?.text = "Bud Remainder = \(budBeer.available)L"
        coronaRemaindersLabel?.text = "Corona Remainder = \(coronaBeer.available)L"
        becksRemaindersLabel?.text = "Becks Remainder = \(becksBeer.available)L"
    }
    
    @IBAction func minusBudOrder(_ sender: UIButton) {
        do {
            try realm?.write({
                let bud = minusOrder(beer: budBeer, stock: budBeer.currentStock)
                budBeer.available = bud
                if (budBeer.currentStock - bud) > 0 {
                    budOrderLabel.text = "\(budBeer.currentStock - bud)"
                } else {
                    budOrderLabel.text = "0"
                }
                budRemaindersLabel.text = "Bud Remainders = \(budBeer.available)L"
            })
        } catch let error {
            print(error)
        }
    }
     
    @IBAction func plusBudOrder(_ sender: UIButton) {
        do {
            try realm?.write({
                let bud = plusOrder(beer: budBeer)
                budBeer.available = bud
                budOrderLabel?.text = "\(budBeer.currentStock - bud)"
                budRemaindersLabel?.text = "Bud Remainders = \(budBeer.available)L"
            })
        } catch let error {
            print(error)
        }
    }
    
    @IBAction func minusCoronaOrder(_ sender: UIButton) {
        do {
            try realm?.write({
                let corona = minusOrder(beer: coronaBeer, stock: coronaBeer.currentStock)
                coronaBeer.available = corona
                if (coronaBeer.currentStock - corona) > 0 {
                    coronaOrderLabel.text = "\(coronaBeer.currentStock - corona)"
                } else {
                    coronaOrderLabel.text = "0"
                }
                coronaRemaindersLabel.text = "Corona Remainders = \(coronaBeer.available)L"
            })
        } catch let error {
            print(error)
        }
    }
    
    @IBAction func plusCoronaOrder(_ sender: UIButton) {
        do {
            try realm?.write({
                let corona = plusOrder(beer: coronaBeer)
                coronaBeer.available = corona
                coronaOrderLabel?.text = "\(coronaBeer.currentStock - corona)"
                coronaRemaindersLabel?.text = "Corona Remainders = \(coronaBeer.available)L"
            })
        } catch let error {
            print(error)
        }
    }
    
    @IBAction func minusBecksOrder(_ sender: UIButton) {
        do {
            try realm?.write({
                let becks = minusOrder(beer: becksBeer, stock: becksBeer.currentStock)
                becksBeer.available = becks
                if (becksBeer.morningStock - becks) > 0 {
                    becksOrderLabel.text = "\(becksBeer.currentStock - becks)"
                } else {
                    becksOrderLabel.text = "0"
                }
                becksRemaindersLabel.text = "Becks Remainders = \(becksBeer.available)L"
            })
        } catch let error {
            print(error)
        }
    }

    @IBAction func plusBecksOrder(_ sender: UIButton) {
        do {
            try realm?.write({
                let becks = plusOrder(beer: becksBeer)
                becksBeer.available = becks
                becksOrderLabel?.text = "\(becksBeer.currentStock - becks)"
                becksRemaindersLabel?.text = "Becks Remainders = \(becksBeer.available)L"
            })
        } catch let error {
            print(error)
        }
    }
    
    @IBAction func sellButtonPressed(_ sender: UIButton) {
        do {
            try realm?.write({
                budBeer.currentStock = budBeer.available
                coronaBeer.currentStock = coronaBeer.available
                becksBeer.currentStock = becksBeer.available
                
                budBeer.proceeds = Double(budBeer.morningStock - budBeer.currentStock) * budBeer.price
                coronaBeer.proceeds = Double(coronaBeer.morningStock - coronaBeer.currentStock) * coronaBeer.price
                becksBeer.proceeds = Double(becksBeer.morningStock - becksBeer.currentStock) * becksBeer.price

                budOrderLabel?.text = "0"
                coronaOrderLabel?.text = "0"
                becksOrderLabel?.text = "0"
            })
        } catch let error {
            print(error)
        }
    }
    
    @IBAction func endButtonPressed(_ sender: UIButton) {
        do {
            try realm?.write({
                pub.fullProceeds = budBeer.proceeds + coronaBeer.proceeds + becksBeer.proceeds
        
                resultLabel.text = "Daily sales proceeds = \(pub.fullProceeds)$"
            })
        } catch let error {
            print(error)
        }
    }
    
    func minusOrder(beer: Beer, stock: Int) -> Int {
        if beer.available == stock {
            return 100
        } else {
            beer.available += 1
            let beerAvailable = beer.available
            return beerAvailable
        }
    }
    
    func plusOrder(beer: Beer) -> Int {
        if beer.available <= 0 {
            return 0
        } else {
            beer.available -= 1
            let beerAvailable = beer.available
            return beerAvailable
        }
    }
}

