//
//  MainView.swift
//  Mantra
//
//  Created by Ali Hodroj on 25/05/2024.
//

import SwiftUI

struct MainView: View {
    
    // view properties
    let mainTimer = Timer.publish(every: 1.25, on: .main, in: .common).autoconnect()
    @State private var currentChosenExercise = exercises[0] {
        didSet {
            forCountdownValue = currentChosenExercise.durationOfInhale
            repsCountDownValue = currentChosenExercise.reps
        }
    }
    @State var isDoingExercise: Bool = false
    @State private var actionButtonValue: String = "START"
    @State private var progressCircleSize: CGFloat = 120
    
    // counters
    @State var forCountdownValue: Int = 4
    @State var repsCountDownValue: Int = 3
    @State var timerCounter = 0
    
    // colors
    private var primaryColor: Color = Color("MainColor")
    private var secondaryColor: Color = .accentColor
    
    var body: some View {
        // main container
        ZStack {
            // background color
            primaryColor.ignoresSafeArea()
            // sub container
            VStack(spacing: 0) {
                topBar
                exerciseCircles
                bottomBar
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onReceive(mainTimer, perform: { _ in
            // check if user started the exercise
            if(isDoingExercise) { startExercise() }
        })
    }
    
    // subviews
    
    private var topBar: some View {
        HStack {
            // app name
            Text("MANTRA")
                .font(.custom("Montserrat-Bold", size: 24))
                .foregroundStyle(secondaryColor)
            Spacer()
            // settings button
            Button {
                // todo
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundStyle(secondaryColor)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var bottomBar: some View {
        ZStack {
            // background
            secondaryColor
                .opacity(0.2)
                .clipShape(.rect(cornerRadius: 22))
            // main
            HStack(alignment: .center, spacing: 0) {
                // action button
                Button {
                    if(isDoingExercise) {
                        isDoingExercise = false
                    } else {
                        isDoingExercise = true
                    }
                } label: {
                    ZStack {
                        secondaryColor
                            .clipShape(.rect(cornerRadius: 18))
                        Text(actionButtonValue)
                            .foregroundStyle(primaryColor)
                            .font(.custom("Montserrat-Bold", size: 18))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .padding(7)
                }
                // text label container
                HStack(alignment: .center, spacing: 0) {
                    // for label
                    VStack(alignment: .leading, spacing: 0) {
                        Text("FOR")
                            .font(.custom("Montserrat-Bold", size: 15))
                            .foregroundStyle(secondaryColor)
                        Text("\(forCountdownValue)")
                            .font(.custom("Montserrat-Regular", size: 14))
                            .foregroundStyle(secondaryColor)
                    }
                    .frame(maxWidth: .infinity)
                    // separator
                    primaryColor
                        .frame(width: 1)
                        .padding(.vertical, 10)
                    // reps label
                    VStack(alignment: .leading, spacing: 0) {
                        Text("REPS")
                            .font(.custom("Montserrat-Bold", size: 15))
                            .foregroundStyle(secondaryColor)
                        Text("\(repsCountDownValue)")
                            .font(.custom("Montserrat-Regular", size: 14))
                            .foregroundStyle(secondaryColor)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .padding(.horizontal)
    }
    
    private var exerciseCircles: some View {
        ZStack(alignment: .center) {
            Circle()
                .frame(height: progressCircleSize)
                .foregroundStyle(secondaryColor.opacity(0.1))
                .shadow(radius: 10)
            Circle()
                .frame(height: progressCircleSize - 30)
                .foregroundStyle(secondaryColor.opacity(0.2))
                .shadow(radius: 10)
            Circle()
                .frame(height: progressCircleSize - 60)
                .foregroundStyle(secondaryColor.opacity(1))
                .shadow(radius: 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
    
    // helper methods
    
    private func startExercise() -> Void {
        // check if reps are done
        if(repsCountDownValue > 0) {
            // perform rep
            // perform inhale
            if(timerCounter == 0) {
                forCountdownValue = currentChosenExercise.durationOfInhale
                actionButtonValue = "INHALE"
                performInhaleAnimation()
            }
            // perform hold
            else if (timerCounter - currentChosenExercise.durationOfInhale == 0) {
                forCountdownValue = currentChosenExercise.durationOfHold
                actionButtonValue = "HOLD"
            }
            // perform exhale
            else if (timerCounter - (currentChosenExercise.durationOfInhale + currentChosenExercise.durationOfHold) == 0) {
                forCountdownValue = currentChosenExercise.durationOfExhale
                actionButtonValue = "EXHALE"
                performExhaleAnimation()
            }
            // check if finished rep to reset counter
            if(timerCounter == (currentChosenExercise.durationOfInhale + currentChosenExercise.durationOfHold + currentChosenExercise.durationOfInhale - 1)) {
                timerCounter = 0
                repsCountDownValue -= 1
            }
            // if not done increment counter
            else { timerCounter += 1 }
            // decrement for countdown
            forCountdownValue -= 1
        } else {
            // stop exercise when reps are done
            stopExercise()
        }
    }
    
    private func stopExercise() -> Void {
        forCountdownValue = currentChosenExercise.durationOfInhale
        repsCountDownValue = currentChosenExercise.reps
        actionButtonValue = "START"
        isDoingExercise = false
    }
    
    private func performInhaleAnimation() -> Void {
        withAnimation(.linear(duration: TimeInterval(currentChosenExercise.durationOfInhale)).delay(0)) {
            progressCircleSize = UIScreen.main.bounds.width - 90
        }
    }
    
    private func performExhaleAnimation() -> Void {
        withAnimation(.linear(duration: TimeInterval(currentChosenExercise.durationOfExhale)).delay(0)) {
            progressCircleSize = 120
        }
    }
}

#Preview {
    MainView()
}
