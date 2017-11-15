//
//  Coffee.swift
//  VendingMachine
//
//  Created by yangpc on 2017. 11. 13..
//  Copyright © 2017년 JK. All rights reserved.
//

import Foundation

class Coffee: Drink {
    var isHot: Bool
    var amountOfCaffeine: Int
    var nameOfCoffeeBeans: String
    
    init?(productTpye: String,
          calorie: String,
          brand: String,
          weight: String,
          price: String,
          name: String,
          dateOfManufacture: String,
          isHot: Bool,
          amountOfCaffeine: String,
          nameOfCoffeeBeans: String) {
        self.isHot = isHot
        guard let amountOfCaffeine = amountOfCaffeine.convert(to: "mg") else { return nil }
        self.amountOfCaffeine = amountOfCaffeine
        self.nameOfCoffeeBeans = nameOfCoffeeBeans
        super.init(productTpye: productTpye,
                   calorie: calorie,
                   brand: brand,
                   weight: weight,
                   price: price,
                   name: name,
                   dateOfManufacture: dateOfManufacture)
    }
    
    func isSuitableAmountOfCaffeine(to age: Int) -> Bool {
        if age > 19 && self.amountOfCaffeine == 400 { return true }
        if age <= 19 && self.amountOfCaffeine == 125 { return true }
        return false
    }
    
    func isLowCalorie() -> Bool {
        return self.calorie <= 30 ? true : false
    }

}

class Top: Coffee {
    override var className: String {
        get {
            return "TOP"
        }
    }

}

class Cantata: Coffee {
    override var className: String {
        get {
            return "Cantata"
        }
    }
}

class Georgia: Coffee {
    override var className: String {
        get {
            return "Georgia"
        }
    }
}