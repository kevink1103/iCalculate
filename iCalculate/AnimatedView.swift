//
//  AnimatedView.swift
//  iCalculate
//
//  Created by Kevin Kim on 7/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import Macaw

class AnimatedView: MacawView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        backgroundColor = UIColor.black
    }

    required init?(coder aDecoder: NSCoder) {
        
        let form1 = Rect(x: 0.5, y: 0.5, w: 279.0, h: 279.0)
        let form2 = Circle(cx: 139.0, cy: 139.0, r: 138.5)
        
        let shape = Shape(
            form: form1,
            fill: Color(val: 0x000000),
            stroke: Stroke(fill: Color(val: 0xff7043), width: 1.0))
        
        let animation = shape.formVar.animation(to: form2, during:1.0, delay: 0.5)
        animation.autoreversed().cycle().play()
        
        super.init(node: shape, coder: aDecoder)
    }

}
