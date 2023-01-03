//
//  TrackModePaceView.swift
//  Run Tools
//
//  Created by Jake Smith on 12/7/22.
//

import SwiftUI

struct TrackModePaceView: View {
    
    @StateObject var vm = ViewModel()

    @State private var showingSplits = false
    
    let units = ["mile", "kilometer"]
    
    var body: some View {
        Form {
            Section("Distance") {
                TrackDistancePresets(distance: $vm.distanceString)
                HStack {
                    TextFieldWithText(userInput: $vm.distanceString, prompt: "Distance:", placeholder: "400m")
                        .keyboardType(.numberPad)
                    Text("/ meters")
                }
            }
            
            Section("Pace") {
                HStack {
                    Text("Average Pace:")
                        .font(.caption)
                    TextField("minutes", text: $vm.minutesString)
                        .keyboardType(.numberPad)
                        .frame(maxWidth: 64)
                    Text(":")
                    TextField("seconds", text: $vm.secondsString)
                        .frame(maxWidth: 96)
                        .keyboardType(.numberPad)
                    Text("/ \(vm.outputUnit)")
                }
                Picker("Distance Type", selection: $vm.outputUnit) {
                    ForEach(units, id: \.self) {
                        Text("\($0)s")
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section("Result") {
                Text("\(vm.resultString)")
                if vm.cantCalculate == false {
                    if showingSplits {
                        Stepper("splits at every \(vm.split) meters", value: $vm.split, step: 100)
                        List {
                            ForEach(Array(stride(from: vm.split, through: vm.distance, by: vm.split)), id: \.self) { split in
                                Text("\(String(split)) : \(vm.timeAtSplit(distance: split, paceInSeconds: vm.paceInSeconds))")
                            }
                        }
                    }
                    Button("\(showingSplits ? "hide" : "show") splits") {
                        withAnimation {
                            showingSplits.toggle()
                        }
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle("Track Calculator")
    }
}

struct TrackModePaceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TrackModePaceView()
        }
    }
}
