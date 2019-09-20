//
//  WorkoutList.swift
//  SlazerTask
//
//  Created by Prasad Ch on 29/08/19.
//  Copyright © 2019 Prasad Ch. All rights reserved.


import Foundation

// MARK: - WorkoutList
struct WorkoutList: Codable {
    let header: Header
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let workouts: [Workout]
}

// MARK: - Workout
struct Workout: Codable {
    let name, workoutDescription: String
    let exercises: [Exercise]
    
    enum CodingKeys: String, CodingKey {
        case name
        case workoutDescription = "description"
        case exercises
    }
}

// MARK: - Exercise
struct Exercise: Codable {
    let type, name: String
    let equipmentName: [String]
    let notes: String
    let workoutAttributes: [WorkoutAttribute]
    let previewImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case type, name
        case equipmentName = "equipment_name"
        case notes
        case workoutAttributes = "workout_attributes"
        case previewImageURL = "preview_image_url"
    }
}

// MARK: - WorkoutAttribute
struct WorkoutAttribute: Codable {
    let longName, value: String
    
    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case value
    }
}

// MARK: - Header
struct Header: Codable {
    let code, message: String
}
