//
//  WorkoutCell.swift
//  SlazerTask
//
//  Created by Prasad Ch on 29/08/19.
//  Copyright © 2019 Prasad Ch. All rights reserved.
//

import UIKit
import SDWebImage

class WorkoutCell: UITableViewCell {

    @IBOutlet var lblExcerciseName:UILabel!
    @IBOutlet var lblEquipmentName:UILabel!
    @IBOutlet var lblExcerciseType:UILabel!
    @IBOutlet var lblWorkoutAttributes:UILabel!
    @IBOutlet var previewImage:UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureExcerciseItem(excerciseObj:Exercise) {
        lblExcerciseName.text = excerciseObj.name
        lblExcerciseType.text = excerciseObj.type
        
        if excerciseObj.equipmentName.count > 0 {
            lblEquipmentName.text = excerciseObj.equipmentName.first
        }
       
        if excerciseObj.workoutAttributes.count > 0 {
            let attributeObj = excerciseObj.workoutAttributes.first
            lblWorkoutAttributes.text = "\(attributeObj?.value ?? "0") \(attributeObj?.longName ?? "")"
        }
        
        if let prevImageUrl = URL(string: excerciseObj.previewImageURL) {
            previewImage.sd_setImage(with: prevImageUrl, placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, completed: nil)
        }
    }
    
}
