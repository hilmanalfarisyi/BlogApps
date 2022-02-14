//
//  UIView.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 13/02/22.
//

import Foundation
import UIKit

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}



extension String {
    
    /**
    Turns current `String` into `Date` instance with passed date format. Will return `nil` if String is empty, or return new `Date` instance if not empty.
    */
    public func toDate(format: String? = "yyyy-MM-dd'T'HH:mm:ss'Z'", timeZone: TimeZone? = nil) -> Date? {
    
        guard !self.isEmpty else {
            return nil
        }
        
        // TODO: Add support for localization here, bottom is used for fixing toDate in iOS 11.0.3
        
        let locale = Locale(identifier: "en_US")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        if let timeZone = timeZone {
            dateFormatter.timeZone = timeZone
        } else {
            dateFormatter.timeZone = NSTimeZone.system
        }

        dateFormatter.locale = locale
        dateFormatter.formatterBehavior = DateFormatter.defaultFormatterBehavior
        
        return dateFormatter.date(from: self)
    }
    
}
