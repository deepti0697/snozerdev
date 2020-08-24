//
//  Extensions.swift
//  Snozer
//
//  Created by Admin on 10/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//
//

import Foundation
import UIKit
import ImageIO
import SwiftMessages
//import FCAlertView

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}



extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
    
    func imageResize (sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}


extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!, NSAttributedString.Key.font: UIFont(name: font_reguler, size: 11)!])
        }
    }
}

extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(labelSize.width)
    }
}

extension String{
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = self.trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }

    //Validate Email
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    //validate PhoneNumber
    var isPhoneNumber: Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    var isPasswordValid: Bool{
        let passwordRegex = "^(?=.*[!@#$&*])(?=.*[0-9])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: self)
    }
    
    
    func isAlphanumeric() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil
    }
    
    func isAlphanumeric(ignoreDiacritics: Bool = false) -> Bool {
        if ignoreDiacritics {
            return self.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
        }
        else {
            return self.isAlphanumeric()
        }
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    
    func isWhitespace() -> Bool {
        return self.filter{$0 == " "}.count > 0
    }
    
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    
    func getAttributtedString(_ subString: String, attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string:self);
        let range = (self as NSString).range(of: subString)
        attributedString.addAttributes(attributes, range: range)
        return attributedString;
    }
    
    var className:String {
        return self.components(separatedBy: ".").last!
    }
    
    func toDate(format:String = "yyyy-MM-dd") -> Date {
        let df:DateFormatter = DateFormatter();
        df.dateFormat = format;
//        df.locale = Locale(identifier: "en_US_POSIX")
//        df.timeZone = TimeZone.autoupdatingCurrent
        //        df.amSymbol = "AM"
        //        df.pmSymbol = "PM"
        return df.date(from: self) ?? Date()
    }
    
    func toDateString(format: String = "yyyy-MM-dd",changedFormat: String = "dd MMM , yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = dateFormatter.date(from: self) else {
            return ""
        }
        
        dateFormatter.dateFormat = changedFormat
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
    func UTCToLocal(fromFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        
        return dateFormatter.string(from: dt ?? Date())
    }
    
    func austrailiaToLocal(fromFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        
        return dateFormatter.string(from: dt ?? Date())
    }
    
    
    func localToUTC(fromFormat: String, toFormat: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = fromFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = toFormat
        
        return dateFormatter.string(from: dt ?? Date())
    }
    
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines);
    }
    
    var attributedStringFromHtml: NSAttributedString? {
        do {
            return try NSAttributedString(data: self.data(using: String.Encoding.utf8)!,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
            
        } catch _ {
            print("Cannot create attributed String")
        }
        return nil
    }
    
    func emailValidation()-> Bool{
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])//substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])//substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        let range = startIndex..<endIndex
        return String(self[range])//substring(with: startIndex..<endIndex)
    }
    
    var isAlphabates: Bool {
        let val = !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
        return val
    }
    
    
    func isNumber() -> Bool {
        let numberCharacters = NSCharacterSet.decimalDigits.inverted
        return !self.isEmpty && self.rangeOfCharacter(from: numberCharacters) == nil
    }
    
    
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}


extension UIView{
    func roundCornersWith(_ corners: CACornerMask, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
    }

    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.clipsToBounds = true;
        self.layer.mask = mask
    }
    
    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.2, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
            self.isHidden = false
        }, completion: completion)  }
    
    func fadeOut(duration: TimeInterval = 0.2, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
            self.isHidden = true
        }, completion: completion)
    }
    
    func pulseAnimation() {
        let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        self.layer.add(pulseAnimation, forKey: "animateOpacity")
    }
    
    func removeEffect()  {
        self.layer.removeAllAnimations();
    }
    
    func shake(count : Float = 2,for duration : TimeInterval = 0.2,withTranslation translation : Float = 5) {
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.fromValue = -translation
        animation.toValue =  translation
        layer.add(animation, forKey: "shake")
    }
    
    func setshadow(cornerR : CGFloat = 0, shadowC: UIColor = .black, shadowO: Float = 0.5, shadowR: CGFloat = 4, shadowOffset: CGSize = CGSize(width: 0, height: 1.0)){
        //        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.shadowColor = shadowC.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowO
        self.layer.shadowRadius = shadowR
        
        // set the cornerRadius of the containerView's layer
        self.layer.cornerRadius = cornerR
        self.layer.masksToBounds = false;
    }
    
    func setButtonShadow(color: UIColor = APPCOLOR.redCustom) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4.0
    }
}


public extension UIView {
    
    
    func addshadow(top: Bool,
                   left: Bool,
                   bottom: Bool,
                   right: Bool,
                   shadowRadius: CGFloat = 2.0) {
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.black.cgColor
        
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height
        
        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
    
    
    func rotate360Degrees(duration: CFTimeInterval = 2) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func showToast(message: String, duration : Int = 3)
    {
        SwiftMessages.hideAll()
        let view: MessageView
        view = MessageView.viewFromNib(layout: .cardView)
        //view.layoutMarginAdditions = UIEdgeInsets(top: 18, left: 6, bottom: 18, right: 6)
        //        switch layout.selectedSegmentIndex {
        //        case 1:
        //            view = MessageView.viewFromNib(layout: .cardView)
        //        case 2:
        //            view = MessageView.viewFromNib(layout: .tabView)
        //        case 3:
        //            view = MessageView.viewFromNib(layout: .statusLine)
        //        default:
        //            view = try! SwiftMessages.viewFromNib()
        //        }

        //        view.configureContent(body: message)
        view.configureContent(body: message)
        //        view.configureContent(title: titleText.text, body: bodyText.text, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide(animated: false) })

        //        let iconStyle: IconStyle
        //        switch self.iconStyle.selectedSegmentIndex {
        //        case 1:
        //            iconStyle = .light
        //        case 2:
        //            iconStyle = .subtle
        //        default:
        //            iconStyle = .default
        //        }

        let backgroundColor = UIColor.white;
        let textColor = UIColor.black
        
        //        view.configureTheme(backgroundColor: .white, foregroundColor: UIColor.darkText)
        view.configureTheme(backgroundColor: backgroundColor, foregroundColor: textColor, iconImage: Bundle.main.icon, iconText: nil)
        //        switch theme.selectedSegmentIndex {
        //        case 0:
        //            view.configureTheme(.info, iconStyle: iconStyle)
        //            view.accessibilityPrefix = "info"
        //        case 1:
        //            view.configureTheme(.success, iconStyle: iconStyle)
        //            view.accessibilityPrefix = "success"
        //        case 2:
        //            view.configureTheme(.warning, iconStyle: iconStyle)
        //            view.accessibilityPrefix = "warning"
        //        case 3:
        //            view.configureTheme(.error, iconStyle: iconStyle)
        //            view.accessibilityPrefix = "error"
        //        default:
        //            let iconText = ["🐸", "🐷", "🐬", "🐠", "🐍", "🐹", "🐼"].sm_random()
        //            view.configureTheme(backgroundColor: UIColor.purple, foregroundColor: UIColor.white, iconImage: nil, iconText: iconText)
        //            view.button?.setImage(Icon.errorSubtle.image, for: .normal)
        //            view.button?.setTitle(nil, for: .normal)
        //            view.button?.backgroundColor = UIColor.clear
        //            view.button?.tintColor = UIColor.green.withAlphaComponent(0.7)
        //        }

        view.configureDropShadow()
        //        if dropShadow.isOn {
        //            view.configureDropShadow()
        //        }

        view.button?.isHidden = true
        //        if !showButton.isOn {
        //            view.button?.isHidden = true
        //        }

        view.iconImageView?.isHidden = true
        view.iconLabel?.isHidden = true
        //        if !showIcon.isOn {
        //            view.iconImageView?.isHidden = true
        //            view.iconLabel?.isHidden = true
        //        }

        view.titleLabel?.isHidden = true
        //        if !showTitle.isOn {
        //            view.titleLabel?.isHidden = true
        //        }

        view.bodyLabel?.isHidden = false
        view.bodyLabel?.font = UIFont.init(name: font_reguler, size: 14)
        view.bodyLabel?.textAlignment = .center;
        //        if !showBody.isOn {
        //            view.bodyLabel?.isHidden = true
        //        }

        // Config setup

        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .bottom
        //        switch presentationStyle.selectedSegmentIndex {
        //        case 1:
        //            config.presentationStyle = .bottom
        //        case 2:
        //            config.presentationStyle = .center
        //        default:
        //            break
        //        }

        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        //        switch presentationContext.selectedSegmentIndex {
        //        case 1:
        //            config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        //        case 2:
        //            config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        //        default:
        //            break
        //        }

        config.duration = .seconds(seconds: TimeInterval(duration))
        //        switch duration.selectedSegmentIndex {
        //        case 1:
        //            config.duration = .forever
        //        case 2:
        //            config.duration = .seconds(seconds: 1)
        //        case 3:
        //            config.duration = .seconds(seconds: 5)
        //        default:
        //            break
        //        }

        config.dimMode = .gray(interactive: true)
        //        switch dimMode.selectedSegmentIndex {
        //        case 1:
        //            config.dimMode = .gray(interactive: true)
        //        case 2:
        //            config.dimMode = .color(color: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 0.7477525685), interactive: true)
        //        case 3:
        //            config.dimMode = .blur(style: .dark, alpha: 1.0, interactive: true)
        //        default:
        //            break
        //        }

        //        config.shouldAutorotate = self.autoRotate.isOn

        config.interactiveHide = true
        //        config.interactiveHide = interactiveHide.isOn

        // Set status bar style unless using card view (since it doesn't
        // go behind the status bar).
//        config.preferredStatusBarStyle = .lightContent
        //        if case .top = config.presentationStyle, layout.selectedSegmentIndex != 1 {
        //            switch theme.selectedSegmentIndex {
        //            case 1...4:
        //                config.preferredStatusBarStyle = .lightContent
        //            default:
        //                break
        //            }
        //        }

        // Show
        SwiftMessages.show(config: config, view: view)

    }

    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func addConstaints(top: CGFloat?, right: CGFloat?, bottom: CGFloat?, left: CGFloat?, width: CGFloat?, height: CGFloat?) {
        translatesAutoresizingMaskIntoConstraints = false
        if top != nil { self.addConstaint(top: top!) }
        if right != nil { self.addConstaint(right: right!) }
        if bottom != nil { self.addConstaint(bottom: bottom!) }
        if left != nil { self.addConstaint(left: left!) }
        if width != nil {   widthAnchor.constraint(equalToConstant: width!).isActive = true }
        if height != nil { heightAnchor.constraint(equalToConstant: height!).isActive = true }
    }
    
    func addConstaint(top offset: CGFloat) {
        guard superview != nil else { return }
        topAnchor.constraint(equalTo: superview!.topAnchor, constant: offset).isActive = true
    }
    func addConstaint(right offset: CGFloat) {
        guard superview != nil else { return }
        rightAnchor.constraint(equalTo: superview!.rightAnchor, constant: offset).isActive = true
    }
    func addConstaint(bottom offset: CGFloat) {
        guard superview != nil else { return }
        bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: offset).isActive = true
    }
    func addConstaint(left offset: CGFloat) {
        guard superview != nil else { return }
        leftAnchor.constraint(equalTo: superview!.leftAnchor, constant: offset).isActive = true
    }
    
    @IBInspectable var borderColor: UIColor? {
        get { return layer.borderColor.map(UIColor.init) }
        set { layer.borderColor = newValue?.cgColor }
    }
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue ; layer.masksToBounds = true;}
    }
    
    ///Add border color with corners
    func addBorderWithColor(color: UIColor, roundingCorners: UIRectCorner) {
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
        self.addRoundingCorners(roundingCorners: roundingCorners)
    }
    
    ///Use corner radius depending on UIRectCorner
    private func addRoundingCorners(roundingCorners: UIRectCorner) {
        let path = UIBezierPath(roundedRect:self.bounds, byRoundingCorners:roundingCorners, cornerRadii: CGSize(width: 4, height: 4))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}

extension UIApplication
{
    class   func getDateTimeDiff(endDate:String) -> String {
        
        var timeAgo = ""
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss a"
        let now = dateFormatter.string(from: NSDate() as Date)
        let startDate = dateFormatter.date(from: now)
        let end = dateFormatter.date(from: endDate)!
        //    print("Date Difference :   ", end.offsetFrom(date: startDate!))
        
        
        
        // *** create calendar object ***
        var calendar = NSCalendar.current
        // *** Get components using current Local & Timezone ***
        //    print(calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newStart!))
        
        // *** define calendar components to use as well Timezone to UTC ***
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
        calendar.timeZone = TimeZone(identifier: "UTC")!
        calendar.locale = Locale(identifier: calendar.timeZone.identifier)
        let dateComponents = calendar.dateComponents(unitFlags, from: startDate!, to: end)
        
        // *** Get Individual components from date ***
        let years = dateComponents.year!
        let months = dateComponents.month!
        let days = dateComponents.day!
        let hours = dateComponents.hour!
        let minutes = dateComponents.minute!
        let seconds = dateComponents.second!
        
        
        //    let diff_date =  self.makeDate(year: years, month: months, day: days, hr: hours, min: minutes, sec: seconds) as Date
        
        
        
        if (years <= 0 && months <= 0 && days <= 0 && hours <= 0 && minutes <= 0 && seconds <= 0) {
            timeAgo = "Time Up"
            return timeAgo
        }
        
        if (days > 0)
        {
            timeAgo += "\(days)d"
        }
        else
        {
            // timeAgo += "0D"
        }
        
        if(hours > 0) && (days > 0)
        {
            timeAgo += " : \(hours)h"
        }
        else if(hours > 0) && (days == 0)
        {
            timeAgo += "\(hours)h"
        }
        else if (days > 0) && (hours == 0)
        {
            timeAgo += " : 00h"
        }
        
        if (minutes > 0) && (hours > 0)
        {
            timeAgo += " : \(minutes)m"
        }
        else if (minutes > 0) && (hours == 0) && (days == 0)
        {
            timeAgo += "\(minutes)m"
        }
        else if (minutes == 0) && (hours > 0)
        {
            timeAgo += " : 00m"
        }
        
        
        if (seconds > 0) && (minutes > 0)
        {
            timeAgo += " : \(seconds)s"
        }
        else if (seconds > 0) && (minutes == 0) && (hours == 0) && (days == 0)
        {
            timeAgo += "\(seconds)s"
        }
        else if (seconds == 0) && (minutes > 0)
        {
            timeAgo += " : 00s"
        }
        
        //  print("timeAgo is ===> \(timeAgo)")
        
        return timeAgo;
    }
    
    class func matchTime(_ match:HomeMatchList, diffrence :  Double = 0) -> (String, Bool) {
        
        var what = false
        var time = ""
        
        if let mDate = Double(match.closeDate) {
            var diff : Double = 0
            if diffrence > 0{
                diff = mDate - match.serverDate - diffrence
            }else{
                diff = mDate - Common.serverTime
            }
            if diff > 0 {
                time = UIApplication.timeStringFromStamp(Int(diff))
                what = true
            } else {
                time = "In Progress"
                if match.matchProgress == "R" {
                    time = "Completed"
                } else if match.matchProgress == "AB"{
                    time = "Abandoned"
                } else if match.matchProgress == "IR"{
                    time = "In Review"
                }
            }
        }
        
        return (time, what)
    }
    
    class func timeStringFromStamp(_ stamp:Int) -> String {
        
        var items:[String] = []
        
        func devide(_ time:Int, by unit:Int, unitString string:String) {
            
            let whole = time / unit
            
            if whole > 0 {
                
                items.append("\(whole)\(string)")
            }
        }
        
        let aMin:Int = 60
        let anHour:Int = aMin * 60
        let aDay:Int = anHour * 24
        
        if aDay > 1 {
          devide(stamp, by: aDay, unitString: " days")
        }
        
        devide(stamp % aDay, by: anHour, unitString: "h")
        devide(stamp % anHour, by: aMin, unitString: "m")
        devide(stamp % aMin, by: 1, unitString: "s")
        
        let timeS = items.joined(separator: " ")
        //        NSLog("\(timeS) \(stamp % 27)")
        return timeS
    }
    
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

extension UIViewController {
    
    func loadNib<T: UIViewController>(_ type : T.Type) -> T {
        return T(nibName: String(describing: T.self), bundle: nil)
    }
    
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[(() -> Void)?]) {
        
        let alert = EMAlertController(title: title, message: message)
        alert.titleLabel.font = UIFont(name: font_bold, size: 14);
        alert.titleLabel.textColor = UIColor(red: 71.0/255, green: 71.0/255, blue: 71.0/255, alpha: 1);
        alert.messageTextView.textColor = UIColor(red: 71.0/255, green: 71.0/255, blue: 71.0/255, alpha: 1);
        alert.messageTextView.font = UIFont(name: font_reguler, size: 12);
        alert.lineUnderTitle.isHidden = true;
        if title != nil && title != ""{
            alert.lineUnderTitle.isHidden = false;
        }
        
        for (index, text) in actionTitles.enumerated() {
            let action = EMAlertAction(title: text!, style: (["cancel", "no"].contains(text?.lowercased())) ? .cancel : .normal, action: actions[index])
            
            alert.addAction(action)
            action.titleColor = whiteColor
            action.titleFont = UIFont(name: font_bold, size: 14);
            action.backgroundColor = APPCOLOR.redCustom;
        }
        alert.buttonSpacing = 1
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func popupAlertWithActions(title: String?, message: String, actions:[EMAlertAction]) {
        let alert = EMAlertController(icon: UIImage(named: Utility.sharedInstance.appTheme == kDarkTheme ? "alertLightlogo" : "alertlogo"), title: "", message: message)
        
        alert.messageColor = AppGrayTextColor;
        alert.backgroundColor = AppInsideBgColor;
        for alt in actions{
            alt.titleColor = .black;
            alert.addAction(alt);
        }
        present(alert, animated: true, completion: nil)
    }
    
    func popupAlertNormal(title: String?, message: String, buttonTitle: String) {
        let alert = EMAlertController(icon: UIImage(named: Utility.sharedInstance.appTheme == kDarkTheme ? "alertLightlogo" : "alertlogo"), title: "", message: message)
        alert.messageColor = AppGrayTextColor;
        alert.backgroundColor = AppInsideBgColor;
        let action1 = EMAlertAction(title: buttonTitle, style: .cancel)
        alert.addAction(action1)
        present(alert, animated: true, completion: nil)
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        viewControllerToPresent.modalPresentationStyle = .overFullScreen
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissDetail(_ completion: (() -> Void)?) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: completion)
    }
}


extension UINavigationController {
    func addCustomBackButton(title: String = "Back") {
        let backButton = UIBarButtonItem()
        backButton.title = title
        navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func open(vc: UIViewController) {
        let settingsVC = vc
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        self.view.layer.add(transition, forKey: kCATransition)
        self.pushViewController(settingsVC, animated: false)
    }
    
    func close() {
        let transition = CATransition()
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.layer.add(transition, forKey:kCATransition)
        let _ = self.popViewController(animated: false)
    }

}

//MARK:- Date
extension Date {
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        //        print("toGlobalTime")
        //        print(seconds)
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        //        print("toLocalTime")
        //        print(seconds)
        return Date(timeInterval: seconds, since: self)
    }
    
    
    struct Gregorian {
        static let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
    }
    var startOfWeek: Date
    {
        return Gregorian.calendar.date(from: Gregorian.calendar.components([.yearForWeekOfYear, .weekOfYear ], from: self))!
    }
    
    
    func toString(format:String = "yyyy-MM-dd") -> String{
        let df:DateFormatter = DateFormatter();
        df.dateFormat = format;
        df.amSymbol = "AM"
        df.pmSymbol = "PM"
        return df.string(from: self)
        
    }
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        return self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        return self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending
    }
    
    func addDays(daysToAdd: Int) -> Date {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)
        
        // Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)
        
        // Return Result
        return dateWithHoursAdded
    }
    
    func format(format:String = "dd-MM-yyyy hh:mm:ss") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: self)
        if let newDate = dateFormatter.date(from: dateString) {
            return newDate
        } else {
            return self
        }
    }
    
}
/*******end*******/


extension UIDatePicker {
    
    // MARK: - Picker Validation Method
    func set18YearValidation() {
        
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -18
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -150
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    }
    
}

extension UITableView {
    
    func  registerTableViewCellWithNib(nibName:String){
        let cellNib = UINib(nibName: nibName, bundle: nil)
        self.register(cellNib, forCellReuseIdentifier: nibName)
        self.tableFooterView = UIView()
    }
    
    func scrollToTop() {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections - 1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func setNoDataMessage(_ message: String ) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0 , width: self.bounds.size.width, height: self.bounds.size.height ))
        messageLabel.text = message
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Poppins-Medium", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore(_ separatorStyle: UITableViewCell.SeparatorStyle) {
        self.backgroundView = nil
        self.separatorStyle = separatorStyle
    }
    
}


extension UICollectionView {
    
    func  registerCollectionViewCellWithNib(nibName:String){
        let cellNib = UINib(nibName: nibName, bundle: nil)
        self.register(cellNib, forCellWithReuseIdentifier: nibName)
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = AppGrayTextColor;
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: font_medium, size: 20)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

extension UIButton {
    override open var intrinsicContentSize: CGSize {
        let intrinsicContentSize = super.intrinsicContentSize
        
        let adjustedWidth = intrinsicContentSize.width + titleEdgeInsets.left + titleEdgeInsets.right
        let adjustedHeight = intrinsicContentSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom
        
        return CGSize(width: adjustedWidth, height: adjustedHeight)
    }
}

extension Bundle {
    public var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
}

//MARK:- UIApplication
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    class func getPresentedViewController() -> UIViewController? {
        var presentViewController = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentViewController?.presentedViewController
        {
            presentViewController = pVC
        }
        
        return presentViewController
    }
    
    class func tryURL(urls: [String]) {
        
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                //                application.openURL(URL(string: url)!)
                application.open(URL(string: url)!, options: [:], completionHandler: nil)
                return
            }
        }
    }
}

extension Double {
    
    // MARK: - Decimal Format Method(Double)
    
    func format() -> String { // Formatting double's decimal value.
        
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
    
    func getDate(_ format : String = "yyyy-MM-dd HH:mm" ) -> String{
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate;
    }
    
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", self)
    }
    
}

extension Float {
    
    // MARK: - Decimal Format Method(Float)
    
    func format() -> String { // Formatting float's decimal value.
        
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
    
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", self)
    }
    
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

extension StringProtocol { 
    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors    = [startColor.cgColor, endColor.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt32 = 0
                
                if scanner.scanHexInt32(&hexNumber) {
                    r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0
                    g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0
                    b = CGFloat(hexNumber & 0x0000FF) / 255.0
                    a = 1
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

