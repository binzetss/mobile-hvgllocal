import WidgetKit
import SwiftUI

// MARK: - Data Model

struct PunchRecord: Identifiable {
    let id = UUID()
    let time: String
    let type: String

    var isExit: Bool {
        let lower = type.lowercased()
        return lower.contains("ra") && !lower.contains("vào")
    }
}

struct AttendanceEntry: TimelineEntry {
    let date: Date
    let userName: String
    let punches: [PunchRecord]

    var checkin: String  { punches.first?.time ?? "--" }
    var checkout: String { punches.count > 1 ? punches.last!.time : "--" }
}

// MARK: - Timeline Provider

struct HvglWidgetProvider: TimelineProvider {
    private let appGroupId = "group.vn.hvgl.noibo"

    func placeholder(in context: Context) -> AttendanceEntry {
        AttendanceEntry(
            date: Date(), userName: "Nguyễn Văn A",
            punches: [
                PunchRecord(time: "08:05", type: "Vào ca"),
                PunchRecord(time: "17:30", type: "Ra ca"),
            ]
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (AttendanceEntry) -> Void) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AttendanceEntry>) -> Void) {
        let entry = loadEntry()
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }

    private func loadEntry() -> AttendanceEntry {
        let defaults = UserDefaults(suiteName: appGroupId)
        let userName    = defaults?.string(forKey: "widget_user_name") ?? ""
        let punchesJson = defaults?.string(forKey: "widget_punches") ?? "[]"

        var punches: [PunchRecord] = []
        if let data = punchesJson.data(using: .utf8),
           let arr  = try? JSONSerialization.jsonObject(with: data) as? [[String: String]] {
            punches = arr.compactMap { dict in
                guard let time = dict["time"], let type = dict["type"] else { return nil }
                return PunchRecord(time: time, type: type)
            }
        }
        return AttendanceEntry(date: Date(), userName: userName, punches: punches)
    }
}

// MARK: - Colors

private extension Color {
    static let hvglBlue     = Color(red: 0x18/255, green: 0x77/255, blue: 0xF2/255)
    static let hvglBlueDark = Color(red: 0x0D/255, green: 0x5B/255, blue: 0xC7/255)
    static let inGreen      = Color(red: 0.35, green: 0.95, blue: 0.55)
    static let outOrange    = Color(red: 1.00, green: 0.62, blue: 0.40)
}

// MARK: - Widget View

struct HvglWidgetEntryView: View {
    var entry: AttendanceEntry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.hvglBlue, .hvglBlueDark]),
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            VStack(alignment: .leading, spacing: 0) {
                headerRow
                userNameRow
                divider
                if widgetFamily == .systemSmall {
                    smallContent
                } else {
                    mediumContent
                }
                Spacer(minLength: 0)
            }
            .padding(10)
        }
    }

    // MARK: Header

    private var headerRow: some View {
        HStack(spacing: 6) {
            // Logo3D
            Image("Logo3D")
                .resizable()
                .scaledToFit()
                .frame(width: 26, height: 26)
                .cornerRadius(6)
            Text("HVGL Nội Bộ")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))
            Spacer()
            Text(todayLabel)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(.white.opacity(0.65))
        }
        .padding(.bottom, 5)
    }

    private var todayLabel: String {
        let f = DateFormatter()
        f.dateFormat = "dd/MM"
        f.locale = Locale(identifier: "vi_VN")
        return f.string(from: Date())
    }

    // MARK: User name

    private var userNameRow: some View {
        Group {
            if entry.userName.isEmpty {
                Text("Chưa đăng nhập")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.55))
            } else {
                Text(entry.userName)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
        }
        .padding(.bottom, 5)
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.2))
            .frame(height: 0.5)
            .padding(.bottom, 6)
    }

    // MARK: Small — VÀO / RA only

    private var smallContent: some View {
        HStack(alignment: .top, spacing: 0) {
            timeColumn(label: "VÀO", time: entry.checkin, accent: .inGreen)
            Spacer()
            Rectangle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 0.5, height: 34)
            Spacer()
            timeColumn(label: "RA", time: entry.checkout, accent: .outOrange)
        }
    }

    private func timeColumn(label: String, time: String, accent: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(accent.opacity(0.85))
            Text(time)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(time == "--" ? .white.opacity(0.4) : .white)
                .monospacedDigit()
        }
    }

    // MARK: Medium — VÀO/RA summary + full punch list

    private var mediumContent: some View {
        HStack(alignment: .top, spacing: 8) {
            // Left: VÀO / RA
            VStack(alignment: .leading, spacing: 6) {
                timeColumn(label: "VÀO", time: entry.checkin, accent: .inGreen)
                timeColumn(label: "RA",  time: entry.checkout, accent: .outOrange)
            }
            .frame(width: 68, alignment: .leading)

            // Vertical separator
            Rectangle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 0.5)
                .padding(.vertical, 2)

            // Right: all punches
            VStack(alignment: .leading, spacing: 3) {
                if entry.punches.isEmpty {
                    Text("Chưa chấm công")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.45))
                } else {
                    ForEach(Array(entry.punches.prefix(6).enumerated()), id: \.offset) { _, punch in
                        punchRow(punch)
                    }
                    if entry.punches.count > 6 {
                        Text("+\(entry.punches.count - 6) lần nữa…")
                            .font(.system(size: 9))
                            .foregroundColor(.white.opacity(0.45))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func punchRow(_ punch: PunchRecord) -> some View {
        HStack(spacing: 4) {
            Image(systemName: punch.isExit ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                .font(.system(size: 9))
                .foregroundColor(punch.isExit ? .outOrange : .inGreen)
            Text(punch.time)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white)
                .monospacedDigit()
                .frame(width: 40, alignment: .leading)
            Text(punch.type)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(1)
        }
    }
}

// MARK: - Widget Configuration

@main
struct HvglWidget: Widget {
    let kind: String = "HvglWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HvglWidgetProvider()) { entry in
            if #available(iOSApplicationExtension 17.0, *) {
                HvglWidgetEntryView(entry: entry)
                    .containerBackground(
                        LinearGradient(
                            gradient: Gradient(colors: [.hvglBlue, .hvglBlueDark]),
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ),
                        for: .widget
                    )
            } else {
                HvglWidgetEntryView(entry: entry)
            }
        }
        .configurationDisplayName("HVNB Chấm Công")
        .description("Xem tất cả lần chấm công trong ngày.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Previews

#if DEBUG
struct HvglWidget_Previews: PreviewProvider {
    static var previews: some View {
        let entry = AttendanceEntry(
            date: Date(), userName: "Nguyễn Văn A",
            punches: [
                PunchRecord(time: "08:05", type: "Vào ca"),
                PunchRecord(time: "12:00", type: "Ra ăn trưa"),
                PunchRecord(time: "13:00", type: "Vào ca"),
                PunchRecord(time: "17:30", type: "Ra ca"),
            ]
        )
        HvglWidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        HvglWidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
#endif
