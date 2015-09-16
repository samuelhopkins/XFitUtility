//
//  StartButtonClass.swift
//  XFit Utility
//
//  Created by Sam Hopkins on 9/15/15.
//  Copyright (c) 2015 Sam Hopkins. All rights reserved.
//

import UIKit
@IBDesignable
class StartButtonClass: UIButton {

    @IBInspectable var isReset : Bool = false
    @IBInspectable var isStop : Bool = false
    
    override func drawRect(rect: CGRect) {
        var path = UIBezierPath(ovalInRect: rect)
        UIColor.redColor().setFill()
        path.fill()
    }
    

}
