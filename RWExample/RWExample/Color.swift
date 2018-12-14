//
//  Color.swift
//  RWExample
//
//  Created by user on 12/14/18.
//  Copyright © 2018 Roundware. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class var lightGrassGreen: UIColor {
        return UIColor(red: 171.0 / 255.0, green: 236.0 / 255.0, blue: 104.0 / 255.0, alpha: 1.0)
    }
    
    class var skyBlue: UIColor {
        return UIColor(red: 84.0 / 255.0, green: 199.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0)
    }
    
    class var seafoamBlue: UIColor {
        return UIColor(red: 93.0 / 255.0, green: 220.0 / 255.0, blue: 191.0 / 255.0, alpha: 1.0)
    }
    
    class var liliac: UIColor {
        return UIColor(red: 201.0 / 255.0, green: 138.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    class var sunflowerYellow: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 205.0 / 255.0, blue: 0.0, alpha: 1.0)
    }
    
    class var carnation: UIColor {
        return UIColor(red: 253.0 / 255.0, green: 100.0 / 255.0, blue: 147.0 / 255.0, alpha: 1.0)
    }
    
    class var peach: UIColor {
        return UIColor(red: 253.0 / 255.0, green: 169.0 / 255.0, blue: 123.0 / 255.0, alpha: 1.0)
    }
    
    class var slate: UIColor {
        return UIColor(red: 80.0 / 255.0, green: 107.0 / 255.0, blue: 120.0 / 255.0, alpha: 1.0)
    }
    
    class var darkLimeGreen: UIColor {
        return UIColor(red: 111.0 / 255.0, green: 221.0 / 255.0, blue: 0.0, alpha: 1.0)
    }
    
    class var blueSlate: UIColor {
        return UIColor(red: 22.0 / 255.0, green: 155.0 / 255.0, blue: 229.0 / 255.0, alpha: 1.0)
    }
    
    class var whiteSlate: UIColor {
        return UIColor(red: 235.0 / 255.0, green: 236.0 / 255.0, blue: 241.0 / 255.0, alpha: 1.0)
    }
    
    class var extraSlate: UIColor {
        return UIColor(red: 10.0 / 255.0, green: 93.0 / 255.0, blue: 172.0 / 255.0, alpha: 1.0)
    }
    
    class var greenSlate: UIColor {
        return UIColor(red: 32.0 / 255.0, green: 177.0 / 255.0, blue: 174 / 255.0, alpha: 1.0)
    }
    
    class var greenBackgroundSlate: UIColor {
        return UIColor(red: 32.0 / 255.0, green: 132.0 / 255.0, blue: 174 / 255.0, alpha: 1.0)
    }
    
    class var lightGrayCustom: UIColor {
        return UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    }
    
    class func color(for index: Int) -> UIColor {
        switch index % 6 {
        case 0: return .lightGrassGreen
        case 1: return .seafoamBlue
        case 2: return .liliac
        case 3: return .sunflowerYellow
        case 4: return .peach
        default: return .carnation
        }
    }
}


extension UIView {
    func installShadow() {
        self.layer.cornerRadius = 2
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.45
        self.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        self.layer.shadowRadius = 1.0
    }
}

