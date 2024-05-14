//
//  Decimal+Extensions.swift
//  SDK Sample
//
//  Created by Michael Schmidt on 5/13/24.
//

import Foundation

extension Decimal {
    static let moneyFormatter: NumberFormatter =  {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.positiveFormat = "$#,##0.00"
        formatter.negativeFormat = "-$#,##0.00"
        return formatter
    }()
    
    var money: String {
        Decimal.moneyFormatter.string(
            from: NSDecimalNumber(decimal: self)
        )!
    }

}
