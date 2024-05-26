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
    var durationOfExhale: Int
    var durationOfHold: Int
}

var exercises: [Exercise] = [
    .init(name: "TEST", reps: 3, durationOfInhale: 4, durationOfExhale: 4, durationOfHold: 4)
]
