//
//  ContentView.swift
//  ClinicDemo
//
//  Created by Bhumika Patel on 29/06/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ClinicViewModel()
    
    var body: some View {
        ZStack{
            NavigationView {
                VStack{
                    if viewModel.clinics.isEmpty {
                        ProgressView()
                            .onAppear(perform:viewModel.loadClinics)
                    } else {
                        List(viewModel.clinics, id: \.self) { clinic in
                            NavigationLink {
                                TimeSlotListView(clinic: clinic, todayTimeSlots: viewModel.todayTimeSlots,tomorrowTimeSlots: viewModel.tomorrowTimeSlots)
                                    .onAppear{
                                        viewModel.loadTimeSlots(for: clinic)
                                    }
                            } label: {
                                Text(clinic.displayName)
                            }
                        }
                    }
                }
                .navigationTitle("Clinics")
            }
            
            .alert(isPresented: $viewModel.showErrorDialog) {
                Alert(title: Text("Sorry"), message: Text("No appointments available."), dismissButton: .default(Text("Ok")))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

