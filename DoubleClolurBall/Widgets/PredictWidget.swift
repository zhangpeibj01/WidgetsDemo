//
//  PredictWidget.swift
//  Widgets
//
//  Created by 张培 on 2023/7/9.
//

import WidgetKit
import SwiftUI
import Alamofire

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> PredictWidgetEntry {
        PredictWidgetEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (PredictWidgetEntry) -> ()) {
        let entry = PredictWidgetEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            do {
                let response = try await AF.request("http://127.0.0.1:1234/result").validate().serializingDecodable(DoubleClolurBallResult.self).value
                let entries = [PredictWidgetEntry(date: Date(), resultsDate: response.date, results: response.award)]
                completion(Timeline(entries: entries, policy: .never))
            } catch {
                print(error)
            }

        }
    }
}

struct PredictWidgetEntry: TimelineEntry {
    let date: Date
    let resultsDate: String
    let results: [Int]
    
    init(date: Date = Date(), resultsDate: String = "", results: [Int] = [8, 8, 8, 8, 8, 8]) {
        self.date = date
        self.resultsDate = resultsDate
        self.results = results
    }
}

struct PredictWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("开奖时间: \(entry.resultsDate)")
            itemView(current: entry.results)
        }
    }
    
    @ViewBuilder
    func itemView(current: [Int]) -> some View {
        HStack {
            ForEach(Array(current.prefix(6).enumerated()), id: \.offset) { (index, number) in
                Text("\(number)")
                    .font(.system(size: 22))
                    .foregroundColor(Color.primary)
                    .frame(width: 36, height: 36)
                    .background(Color.red.cornerRadius(18))
            }
            if let last = current.last {
                Text("\(last)")
                    .font(.system(size: 22))
                    .foregroundColor(Color.primary)
                    .frame(width: 36, height: 36)
                    .background(Color.blue.cornerRadius(18))
            }
        }
    }
}

struct PredictWidget: Widget {
    let kind: String = "PredictWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PredictWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Predict")
        .description("Good Luck")
    }
}

struct Widgets_Previews: PreviewProvider {
    static var previews: some View {
        PredictWidgetEntryView(entry: PredictWidgetEntry())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct DoubleClolurBallResult: Codable {
    let date: String
    let award: [Int]
}
