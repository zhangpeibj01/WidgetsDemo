//
//  ContentView.swift
//  DoubleClolurBall
//
//  Created by 张培 on 2023/7/9.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    var body: some View {
        List(content: {
            Button("reload Timeline") {
                WidgetCenter.shared.reloadTimelines(ofKind: "PredictWidget")
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
