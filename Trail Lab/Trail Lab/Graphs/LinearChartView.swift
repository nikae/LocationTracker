//
//  LinearChartView.swift
//  Trail Lab
//
//  Created by Nika Elashvili on 2/21/21.
//  Copyright © 2021 nilka. All rights reserved.
//

import SwiftUICharts
import SwiftUI

struct LinearChartView: View {
    let data: [Double]
    let title: String
    let color: Color
    
    @State var smoothValue = 0
    @State var showDetailed = false
  
    let unit = UnitPreference(rawValue: Preferences.unit)
    
    var min: Double {
        data.min() ?? 0
    }
    
    var max: Double {
        data.max() ?? 0
    }
    
    var legend: String {
        "Min: \(min.rounded())\(unit?.stringValue ?? "") Max: \(max.rounded())\(unit?.stringValue ?? "")"
    }

    func getShortedLineChartData(width: Int) -> [Double] {
        var rowData:[Double] = data // your full data source
        while rowData.count > width {
            rowData = rowData.enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }
        }
        return rowData
    }
    
    var chartStyle: ChartStyle {
        ChartStyle(backgroundColor: Color(.systemBackground),
                                accentColor: color,
                                secondGradientColor: color.adjust(),
                                textColor: Color(.label),
                                legendTextColor: color,
                                dropShadowColor: .yellow)
    }
    
    var body: some View {
        VStack {
            DismissIcon()
            LineView(data: showDetailed ? data : getShortedLineChartData(width: 20),
                     title: title,
                     legend: legend,
                     style: chartStyle,
                     valueSpecifier: "%.0f \(unit?.stringValue ?? "")")
                .frame(maxHeight: UIScreen.main.bounds.width)
                .onTapGesture {
                    self.showDetailed.toggle()
                }

            Spacer()
        }
        .padding(.horizontal)
    }
}

struct LinearChartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LinearChartView(data: [12, 6, 34, 6, 7, 8, 3], title: "Altitude", color: .red)
            LinearChartView(data: [12, 6, 34, 6, 7, 8, 3], title: "Altitude", color: .red)
                .preferredColorScheme(.dark)
        }
    }
}


//TODO: This needs to be worked on
//func filter() -> [Double] {
//    var result: [Double] = data
//    var previous: Double = result.first ?? 0
//    let last = result.last ?? 0
//    let first = result.first ?? 0
//    var num: Double = last > first ? last - first : first - last
//
//    while result.count > 20 {
//        result = result.enumerated().compactMap { index, element in
//            defer { previous = result[index > 0 ? index - 1 : 0] }
//            return  (element < previous + num) || (element > previous - num) ? element : nil // elem - previous > 10 ? 0 : elem
//        }
//
//        previous = result.first ?? 0
//        num -= 0.5
//    }
//
//    return result
//}
