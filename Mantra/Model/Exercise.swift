//
//  Exercise.swift
//  Mantra
//
//  Created by Ali Hodroj on 25/05/2024.
//

import Foundation

struct Exercise {
    var name: String
    var reps: Int
    var durationOfInhale: Int
    var durationOfHold: Int
    var durationOfExhale: Int
}

var exercises: [Exercise] = [
    .init(name: "main", reps: 3, durationOfInhale: 5, durationOfHold: 8, durationOfExhale: 5)
]
