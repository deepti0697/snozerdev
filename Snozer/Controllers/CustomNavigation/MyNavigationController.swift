//
//  MyNavigationController.swift
//  Snozer
//
//  Created by Admin on 27/09/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class MyNavigationController: UINavigationController {

    override func viewDidLoad() {
            super.viewDidLoad()

            self.navigationBar.setGradientBackground(colors: [
                UIColor(red: 202.0/255, green: 33.0/255, blue: 40.0/255, alpha: 1),
                UIColor(red: 128.0/255, green: 0/255, blue: 0/255, alpha: 1)
            ])
    
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white, .font : UIFont(name: font_bold, size: 16)!];
        }
    
}

extension UINavigationBar {
    func setGradientBackground(colors: [UIColor]) {
        let gradient: RadialGradientLayer = RadialGradientLayer()
//        gradient.locations = [0.0 , 0.5, 1.0]
//        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
//        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)

        var updatedFrame = self.bounds
        updatedFrame.size.height += self.frame.origin.y
        gradient.frame = updatedFrame
        gradient.colors = colors;
        self.setBackgroundImage(self.image(fromLayer: gradient), for: .default)
    }

    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
}


class RadialGradientLayer: CALayer {

    var center: CGPoint {
        return CGPoint(x: bounds.width/2, y: bounds.height/2)
    }

    var radius: CGFloat {
        return (bounds.width + bounds.height)/2
    }

    var colors: [UIColor] = [UIColor.red, UIColor.systemPink] {
        didSet {
            setNeedsDisplay()
        }
    }

    var cgColors: [CGColor] {
        return colors.map({ (color) -> CGColor in
            return color.cgColor
        })
    }

    override init() {
        super.init()
        needsDisplayOnBoundsChange = true
    }

    required init(coder aDecoder: NSCoder) {
        super.init()
    }

    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations: [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: locations) else {
            return
        }
        ctx.drawRadialGradient(gradient, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions(rawValue: 0))
    }

}

