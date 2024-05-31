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
    @State var didStartExercise: Bool = false
    @State private var actionButtonValue: String = "Tap circle to start"
    @State private var progressCircleSize: CGFloat = 120
    
    // counters
    @State var forCountdownValue: Int = exercises[0].durationOfInhale
    @State var repsCountDownValue: Int = exercises[0].reps
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
                if(didStartExercise) {
                    exerciseCircles(widthOfCircles: progressCircleSize)
                        .transition(.scale)
                } else {
                    exerciseCircles(widthOfCircles: 120)
                        .transition(.scale)
                }
                bottomBar
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onReceive(mainTimer, perform: { _ in
            // check if user started the exercise
            if(didStartExercise) {
                startExercise()
            }
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
//            Button {
//                // todo
//            } label: {
//                Image(systemName: "gearshape.fill")
//                    .font(.title2)
//                    .foregroundStyle(secondaryColor)
//            }
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
                ZStack {
                    secondaryColor
                        .clipShape(.rect(cornerRadius: 18))
                    Text(actionButtonValue)
                        .foregroundStyle(primaryColor)
                        .font(.custom("Montserrat-Bold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                }
                .padding(7)
                // text label container
                HStack(alignment: .center, spacing: 0) {
                    // for label
                    VStack(alignment: .leading, spacing: 2) {
                        Text("FOR")
                            .font(.custom("Montserrat-Bold", size: 18))
                            .foregroundStyle(secondaryColor)
                        Text("\(forCountdownValue)")
                            .font(.custom("Montserrat-Regular", size: 16))
                            .foregroundStyle(secondaryColor)
                    }
                    .frame(maxWidth: .infinity)
                    // separator
                    primaryColor
                        .frame(width: 1)
                        .padding(.vertical, 10)
                    // reps label
                    VStack(alignment: .leading, spacing: 2) {
                        Text("REPS")
                            .font(.custom("Montserrat-Bold", size: 18))
                            .foregroundStyle(secondaryColor)
                        Text("\(repsCountDownValue)")
                            .font(.custom("Montserrat-Regular", size: 16))
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
    
    @ViewBuilder
    private func exerciseCircles(widthOfCircles: CGFloat) -> some View {
        ZStack(alignment: .center) {
            Circle()
                .frame(height: widthOfCircles)
                .foregroundStyle(secondaryColor.opacity(0.1))
                .shadow(radius: 10)
            Circle()
                .frame(height: widthOfCircles - 30)
                .foregroundStyle(secondaryColor.opacity(0.2))
                .shadow(radius: 10)
            Circle()
                .frame(height: widthOfCircles - 60)
                .foregroundStyle(secondaryColor.opacity(1))
                .shadow(radius: 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
        .onTapGesture {
            if(didStartExercise) {
                withAnimation{ didStartExercise = false }
                stopExercise()
            } else {
                didStartExercise = true
            }
        }
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
            if(timerCounter == (currentChosenExercise.durationOfInhale + currentChosenExercise.durationOfHold + currentChosenExercise.durationOfExhale - 1)) {
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
        timerCounter = 0
        forCountdownValue = currentChosenExercise.durationOfInhale
        repsCountDownValue = currentChosenExercise.reps
        actionButtonValue = "Tap circle to start"
        progressCircleSize = 120
        didStartExercise = false
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
