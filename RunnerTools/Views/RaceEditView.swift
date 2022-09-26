//
//  RaceView.swift
//  RunnerTools
//
//  Created by Jake Smith on 9/25/22.
//

import SwiftUI

struct RaceEditView: View {
    @EnvironmentObject var dataController: DataController
    
    let race: Race
    
    @State private var name: String
    @State private var date: Date
    
    var body: some View {
        Form {
            Section("Race Information") {
                TextField("race name", text: $name.onChange({
                    update()
                }))
                DatePicker("race date", selection: $date.onChange {
                    update()
                }, displayedComponents: [.date])
                .datePickerStyle(.compact)
            }
        }
        .onDisappear {
            dataController.save()
        }
        .navigationTitle("\(race.raceName)")
    }
    
    init(race: Race) {
        self.race = race
        _name = State(wrappedValue: race.raceName)
        _date = State(wrappedValue: race.raceDate)
    }
    
    func update() {
        race.objectWillChange.send()
        
        race.name = name
        race.date = date
    }
}

struct RaceView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            RaceEditView(race: Race.example)
        }
    }
}
