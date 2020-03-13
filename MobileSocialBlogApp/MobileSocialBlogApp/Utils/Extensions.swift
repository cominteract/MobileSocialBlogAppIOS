//
//  Extensions.swift
//  RedditClientApp
//
//  Created by Andre Insigne on 13/10/2019.
//  Copyright © 2019 andreinsigne. All rights reserved.
//

import UIKit

class LocalisableLabel: UILabel {
    
    @IBInspectable var localisedKey: String? {
        didSet {
            guard let key = localisedKey else { return }
            text = NSLocalizedString(key, comment: "")
        }
    }
}

class LocalisableTabBarItem: UITabBarItem {
    
    @IBInspectable var localisedKey: String? {
        didSet {
            guard let key = localisedKey else { return }
            title = NSLocalizedString(key, comment: "")
            
        }
    }
}

class LocalisableTextField: UITextField {
    
    @IBInspectable var localisedKey: String? {
        didSet {
            guard let key = localisedKey else { return }
            placeholder = NSLocalizedString(key, comment: "")
            
        }
    }
}

class LocalisableButton: UIButton {
    
    @IBInspectable var localisedKey: String? {
        didSet {
            guard let key = localisedKey else { return }
            //title = NSLocalizedString(key, comment: "")
            setTitle(NSLocalizedString(key, comment: ""), for: UIControl.State.normal)
        }
    }
}


class Extensions: NSObject {

}

extension UIView
{
    
    /// animateLtoR quite a hack which is used in simulating a tab push
    ///
    /// - Parameter parentView: as UIView which holds the current view to animate
    func animateLtoR(parentView : UIView)
    {
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.layer.add(transition, forKey: nil)
        
    }
    
    
    /// addTapGesture adds a tap gesture from a selector
    ///
    /// - Parameters:
    ///   - selector: as Selector to be used in identifying the objc function to call
    ///   - target: as Any
    func addTapGesture(selector : Selector, target : Any)
    {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.addTarget(target, action: selector)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapRecognizer)
    }
}

extension UIImageView
{
    
}

extension UILabel
{
    
}


let dateFormatter = DateFormatter()
let calendar = Calendar(identifier: .gregorian)
extension Date
{
    
    
    /// fromNow this calculates which is closest from now from day month or year
    ///
    /// - Returns: as String to be displayed
    func fromNow() -> String
    {
        let now = Date()
        let components = calendar.dateComponents([.hour,.day,.year, .month, .minute], from: self, to: now)
        if let h = components.hour, let d = components.day, let y = components.year, let mo = components.month, let min = components.minute
        {
            if y > 0
            {
                return "\(y) y"
            }
            else if mo > 1 && mo < 12
            {
                return "\(mo) mos"
            }
            else if mo == 1 && d >= 30
            {
                return "\(mo) mo"
            }
            else if d > 0
            {
                return "\(d) d"
            }
            else if h > 0
            {
                return "\(h) h"
            }
            else
            {
                return "\(min) m"
            }
        }
        return ""
        
    }
    
    /// secondsFromNow this calculates which is closest from now from seconds
    ///
    /// - Returns: as String to be displayed
    func secondsFromNow() -> Int?
    {
        let now = Date()
        let components = calendar.dateComponents([.second], from: self, to: now)
        return components.second
    }
    
    /// daysFromNow this calculates which is closest from now from day
    ///
    /// - Returns: as String to be displayed
    func daysFromNow() -> Int?
    {
        let now = Date()
        let components = calendar.dateComponents([.day], from: self, to: now)
        return components.day
    }
    
    /// monthsFromNow this calculates which is closest from now from month
    ///
    /// - Returns: as String to be displayed
    func monthsFromNow() -> Int?
    {
        let now = Date()
        let components = calendar.dateComponents([.month], from: self, to: now)
        return components.month
    }
    
    /// yearsFromNow this calculates which is closest from now from year
    ///
    /// - Returns: as String to be displayed
    func yearsFromNow() -> Int?
    {
        let now = Date()
        let components = calendar.dateComponents([.year], from: self, to: now)
        return components.year
    }
    
    /// toStringDisplay displays a date string in current format
    ///
    /// - Returns: as String to be displayed
    func toStringDisplay() -> String?
    {
        
        dateFormatter.dateFormat = "yyy-MMM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    /// toString displays a date string in current format
    ///
    /// - Returns: as String to be displayed
    func toString() -> String?
    {
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    /// toStringMonth displays a date string in month format
    ///
    /// - Returns: as String to be displayed
    func toStringMonth() -> String?
    {
        
        dateFormatter.dateFormat = "yyyy-MM"
        return dateFormatter.string(from: self)
    }
    
    /// toStringDay displays a date string in day format
    ///
    /// - Returns: as String to be displayed
    func toStringDay() -> String?
    {
        
        dateFormatter.dateFormat = "yyyy-MMM-dd"
        return dateFormatter.string(from: self)
    }
    
    /// toStringYear displays a date string in year format
    ///
    /// - Returns: as String to be displayed
    func toStringYear() -> String?
    {
        
        dateFormatter.dateFormat = "yyy"
        return dateFormatter.string(from: self)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
}

extension Double
{
    
    /// toDate converts the utc to date
    ///
    /// - Returns: as Date format from utc
    func toDate() -> Date
    {
        return Date(timeIntervalSince1970: (self))
    }
    
    /// rounds to the decimal place provided
    ///
    /// - Parameter value: as Int
    /// - Returns: as Double rounded of
    func roundTo(value : Int) -> Double
    {
        if let newval = Double(String(format: "%.\(value)f", ceil(self * 100)/100))
        {
            return newval
        }
        return self
    }
}

extension String
{
    
    /// toDict converts json string to dictionary
    ///
    /// - Parameter text: as String to convert
    /// - Returns: as Dictionary of any
    func toDict(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func downloadImage(completion: @escaping (Data) -> ()) {
        print("Download Started")
        getData { (data, response, error) in
            guard let data = data, error == nil else { return }
            completion(data)
        }
    }
    
    func getData(completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        if let url = URL.init(string: self)
        {
            URLSession.shared.dataTask(with: url , completionHandler: completion).resume()
        }
    }
    
    /// toDate converts the String to Date
    ///
    /// - Returns: as Date format from String
    func toDate() -> Date?
    {
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self)
    }
    
}
private let allowedCharacterSet = CharacterSet(charactersIn: "!$&'()*+,-./0123456789:;=?@ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~")

/**
 Protocol to generate URL query string from Dictionary[String:String].
 */
public protocol QueryEscapableString {
    var addPercentEncoding: String { get }
}



extension String: QueryEscapableString {
    /**
     Returns string by adding percent encoding in UTF-8
     Protocol to generate URL query string from Dictionary[String:String].
     */
    public var addPercentEncoding: String {
        get {
            return (self as NSString).addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? self
        }
    }
}

/**
 Protocol to generate URL query string from Dictionary[String:String].
 */
extension Dictionary where Key: QueryEscapableString, Value: QueryEscapableString {
    /**
     Gets escped string.
     - returns: Returns string by adding percent encoding in UTF-8
     */
    var URLQuery: String {
        get {
            return self.map({"\($0.addPercentEncoding)=\($1.addPercentEncoding)"}).joined(separator: "&")
        }
    }
}

extension UIImageView {
    
    /// downlaodedFrom downloads the image from url if available
    ///
    /// - Parameters:
    ///   - link: as String the url t be downloaded
    ///   - mode: as ContentMode to identify what type of display will be used
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        contentMode = mode
        clipsToBounds = true
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    print("Unable to display \(link)")
                    return
            }
            DispatchQueue.main.sync() { () -> Void in
                
                self.image = nil
                self.backgroundColor = UIColor.lightGray
                self.contentMode = mode
                self.layer.masksToBounds = true
                self.image = image
              }
            }.resume()
    }
    
    
    
    
}


