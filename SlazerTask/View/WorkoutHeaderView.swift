//
//  WorkoutHeaderView.swift
//  SlazerTask
//
//  Created by Prasad Ch on 29/08/19.
//  Copyright © 2019 Prasad Ch. All rights reserved.
//

import UIKit

class WorkoutHeaderView: NibView {
    
    @IBOutlet var lblWorkoutDescription:UILabel!
    @IBOutlet var btnInfo:UIButton!

    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

