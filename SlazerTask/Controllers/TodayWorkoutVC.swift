//
//  TodayWorkoutVC.swift
//  SlazerTask
//
//  Created by Prasad Ch on 28/08/19.
//  Copyright © 2019 Prasad Ch. All rights reserved.
//

import UIKit

class TodayWorkoutVC: UIViewController {

    @IBOutlet var workoutTblView:UITableView!
    @IBOutlet var lblWorkoutTitle:UILabel!

    var workoutListItems:[Workout] = []
    var excerciseList:[Exercise] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register Cell Nib
        let nib = UINib(nibName: "WorkoutCell", bundle: nil)
        workoutTblView.register(nib, forCellReuseIdentifier: "WorkoutCellID")
        
        workoutTblView.sectionHeaderHeight = UITableView.automaticDimension;
        workoutTblView.estimatedSectionHeaderHeight = 50;
        
        fetchDailyWorkouts()
    }
    
    // MARK: - Customized methods
    func fetchDailyWorkouts() {
        
        let paramValues = ["WTOKEN":Constants.WorkoutHeaders.wToken,
                           "WLOCATION":Constants.WorkoutHeaders.wLocation] as [String : Any]

        makeAPIRequest(requestUrl: Constants.API.kWorkout, paramValues: paramValues, requestMethod: .GET)  { (responseData, statusCode, error) in
            self.handleWorkoutResponse(responseData: responseData, statusCode: statusCode)
        }
    }
    
    func handleWorkoutResponse(responseData: Data, statusCode:Int) {
        
        do {
            let dictionary = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? NSDictionary
            
            if let responseDict = dictionary {
                if statusCode == 200 {
                    if let responseObj = try? JSONDecoder().decode(WorkoutList.self, from: responseData) {
                        print(responseObj)
                        
                        if let workout = responseObj.data.workouts.first {
                            lblWorkoutTitle.text = workout.name
                            workoutListItems = responseObj.data.workouts
                            workoutTblView.reloadData()
                        }
                    }
                }
                else {
                    if let errorMessage = responseDict.value(forKey: "error") as? String {
                        print(errorMessage)
                    }
                }
            }
        }
        catch {
            print("Error in response")
        }
    }
}

extension TodayWorkoutVC:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workoutListItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        excerciseList = workoutListItems[section].exercises
        return excerciseList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = WorkoutHeaderView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        let currentWorkout = workoutListItems[section]
        headerView.lblWorkoutDescription.text = currentWorkout.workoutDescription
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celldentifier = "WorkoutCellID"
        
        guard let workoutCell = tableView.dequeueReusableCell(withIdentifier: celldentifier, for: indexPath) as? WorkoutCell else {
            return UITableViewCell()
        }
        
        let excercise = excerciseList[indexPath.row]
        workoutCell.configureExcerciseItem(excerciseObj: excercise)
        
        return workoutCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
}

