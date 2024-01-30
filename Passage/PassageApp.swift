import SwiftUI
import Combine
import Foundation

let calendar = Calendar.current
let currentYear = calendar.dateComponents([.year], from: Date()).year!

let schoolStartDate = calendar.date(from: DateComponents(year: 2023, month: 9, day: 5, hour: 8, minute: 20))!
let schoolEndDate = calendar.date(from: DateComponents(year: 2024, month: 6, day: 14, hour: 12, minute: 30))!

let yearStartDate = calendar.date(from: DateComponents(year: currentYear, month: 1, day: 1, hour: 0, minute: 0))!
let yearEndDate = calendar.date(from: DateComponents(year: currentYear + 1, month: 1, day: 1, hour: 0, minute: 0))!

func getPercentageBetween(start: Date, end: Date, decimals: Int) -> Double {
    let startTimestamp = start.timeIntervalSince1970
    let endTimestamp = end.timeIntervalSince1970
    let currentTimestamp = Date().timeIntervalSince1970

    if currentTimestamp <= startTimestamp {
        return 0
    } else if currentTimestamp >= endTimestamp {
        return 100
    } else {
        let percentage = ((currentTimestamp - startTimestamp) / (endTimestamp - startTimestamp)) * 100
        return percentage.rounded(toPlaces: decimals)
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

@main
struct PassageApp: App {
    func getPercentage() -> Double {
        let schoolYear = selectedDateType == "school_year"
        return getPercentageBetween(start: schoolYear ? schoolStartDate : yearStartDate, end: schoolYear ? schoolEndDate : yearEndDate, decimals: decimalPlaces);
    }
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var percentage: Double = 0
    @AppStorage("selectedDateType") var selectedDateType = "school_year"
    @AppStorage("decimalPlaces") var decimalPlaces = 2
    
    var body: some Scene {
        MenuBarExtra() {
            Picker("Countdown To", selection: $selectedDateType) {
                Text("School Year").tag("school_year")
                Text("Calendar Year").tag("calendar_year")
            }
            Picker("Decimal Places", selection: $decimalPlaces) {
                Text("No Decimals").tag(0)
                Text("1 Decimal").tag(1)
                Text("2 Decimals").tag(2)
                Text("3 Decimals").tag(3)
            }
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            Text("By Henry Langmack").font(.footnote)
        } label: {
            Text("\(selectedDateType == "school_year" ? "School year" : "Year") \(String(format: "%.\(decimalPlaces)f", percentage))% over").onReceive(timer) { _ in
                percentage = getPercentage()
            }
        }
    }
}
