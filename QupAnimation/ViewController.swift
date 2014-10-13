//
//  ViewController.swift
//  QupAnimation
//
//  Created by Matt Bridges on 10/13/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var rippleMask: CALayer! = nil
    var circleShape: CALayer! = nil
    var images: [UIImage] = []
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var container: UIView!
    var clickCount = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        var shape = CAShapeLayer()
        var circleMask = CAShapeLayer()
        var outline = CAShapeLayer()
        
        
        var offsetX = (self.view.bounds.size.width - 200) / 2
        
        var path = CGPathCreateWithEllipseInRect(CGRect(x: offsetX, y: 150, width: 200, height: 200), nil);
        
        shape.path = path;
        circleMask.path = path;
        outline.path = path;
        
        shape.fillColor = UIColor(red: 0.12, green: 0.73, blue: 0.85, alpha: 1).CGColor
        
        outline.lineWidth = 1.0
        outline.strokeColor = shape.fillColor
        outline.fillColor = UIColor.clearColor().CGColor
        
        self.view.layer.addSublayer(shape)
        self.view.layer.addSublayer(outline)
        
        var sine = CAShapeLayer()
        
//        var sinePath:CGMutablePath! = CGPathCreateMutable()
//        
//        CGPathMoveToPoint(sinePath, nil, 100, 100)
//        CGPathAddCurveToPoint(sinePath, nil, 150, 75, 150, 125, 200, 100)
        
        
        func createSine(start: CGPoint, amplitude: CGFloat, wavelength: CGFloat, phases: NSInteger) -> CGPath! {
            var path = CGPathCreateMutable()
            var x = start.x
            var y = start.y
            CGPathMoveToPoint(path, nil, x, y)
            for (var i = 0; i < phases; i++) {
                var rand = CGFloat(Int(arc4random_uniform(26)) % 10)
                CGPathAddCurveToPoint(path, nil, x + wavelength / 2, y - amplitude - rand, x + wavelength / 2, y + amplitude + rand, x + wavelength, y);
                x = x + wavelength
            }
            
            CGPathAddLineToPoint(path, nil, x, 1600)
            CGPathAddLineToPoint(path, nil, start.x, 1600)
            CGPathAddLineToPoint(path, nil, start.x, start.y)
            
            return path
        }
        
        let imageNames = ["daftpunk.png", "aboveandbeyond.png", "prettylights.png", "album.png"]
        for name in imageNames {
            self.images.append(UIImage(named: name))
        }
        
        sine.path = createSine(CGPoint(x: 0, y: 375), 40, 200, 25)
        
        //sine.path = sinePath
        //sine.lineWidth = 2.0
        //sine.strokeColor = UIColor.blueColor().CGColor
        //view.layer.addSublayer(sine)
        
        self.view.layer.mask = sine
        
        self.rippleMask = sine;
        self.circleShape = shape;
        self.container.layer.mask = circleMask
        
        
        //sine.position = CGPointMake(0, 10)
        
        

        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func runAnimation() {
        
        self.imageView.image = self.images[self.clickCount++ % self.images.count]
        
        var animation: CABasicAnimation = CABasicAnimation(keyPath: "position")
        animation.toValue = NSValue(CGPoint: CGPointMake(-400, -239))
        animation.duration = 2.0
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        self.rippleMask.addAnimation(animation, forKey: "move up")
        
        var animation2: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        animation2.toValue = 0.0
        animation2.duration = 3.0
        animation2.fillMode = kCAFillModeForwards
        animation2.removedOnCompletion = false
        animation2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        self.circleShape.addAnimation(animation2, forKey: "fade out")
        
    }
}

