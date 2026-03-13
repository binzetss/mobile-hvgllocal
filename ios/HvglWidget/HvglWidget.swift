import WidgetKit
import SwiftUI

struct AttendanceEntry: TimelineEntry {
    let date: Date
    let userName: String
    let checkin: String
    let checkout: String
}

// MARK: - Timeline Provider

struct HvglWidgetProvider: TimelineProvider {
    private let appGroupId = "group.vn.hvgl.noibo"

    func placeholder(in context: Context) -> AttendanceEntry {
        AttendanceEntry(date: Date(), userName: "Nguyen Van A", checkin: "08:00", checkout: "--")
    }

    func getSnapshot(in context: Context, completion: @escaping (AttendanceEntry) -> Void) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AttendanceEntry>) -> Void) {
        let entry = loadEntry()
        // Refresh every 15 minutes
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
        let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
        completion(timeline)
    }

    private func loadEntry() -> AttendanceEntry {
        let defaults = UserDefaults(suiteName: appGroupId)
        let userName = defaults?.string(forKey: "widget_user_name") ?? ""
        let checkin  = defaults?.string(forKey: "widget_checkin")   ?? "--"
        let checkout = defaults?.string(forKey: "widget_checkout")  ?? "--"
        return AttendanceEntry(date: Date(), userName: userName, checkin: checkin, checkout: checkout)
    }
}

// MARK: - Colors

private extension Color {
    static let hvglBlue     = Color(red: 0x18 / 255, green: 0x77 / 255, blue: 0xF2 / 255)
    static let hvglBlueDark = Color(red: 0x0D / 255, green: 0x5B / 255, blue: 0xC7 / 255)
    static let dividerWhite = Color.white.opacity(0.25)
}

// MARK: - Widget View

struct HvglWidgetEntryView: View {
    var entry: AttendanceEntry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        ZStack {
            // Blue gradient background
            LinearGradient(
                gradient: Gradient(colors: [.hvglBlue, .hvglBlueDark]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(alignment: .leading, spacing: 0) {
                // Header row: logo placeholder + app name
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 20, height: 20)
                        .overlay(
                            Text("H")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                        )
                    Text("HVNB Nội Bộ")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                    Spacer()
                }
                .padding(.bottom, 6)

                // User name
                if !entry.userName.isEmpty {
                    Text(entry.userName)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .padding(.bottom, 8)
                } else {
                    Text("Chưa đăng nhập")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.bottom, 8)
                }

                // Divider
                Rectangle()
                    .fill(Color.dividerWhite)
                    .frame(height: 1)
                    .padding(.bottom, 8)

                // Check-in / Check-out row
                HStack(spacing: 0) {
                    AttendanceItem(label: "Vào", time: entry.checkin, icon: "arrow.right.circle.fill")
                    Spacer()
                    Rectangle()
                        .fill(Color.dividerWhite)
                        .frame(width: 1, height: 36)
                    Spacer()
                    AttendanceItem(label: "Ra", time: entry.checkout, icon: "arrow.left.circle.fill")
                }
            }
            .padding(12)
        }
    }
}

struct AttendanceItem: View {
    let label: String
    let time: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.8))
                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            Text(time)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .monospacedDigit()
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
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        for: .widget
                    )
            } else {
                HvglWidgetEntryView(entry: entry)
            }
        }
        .configurationDisplayName("HVNB Chấm Công")
        .description("Hiển thị giờ vào/ra của ngày hôm nay.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Previews

#if DEBUG
struct HvglWidget_Previews: PreviewProvider {
    static var previews: some View {
        HvglWidgetEntryView(
            entry: AttendanceEntry(date: Date(), userName: "Nguyen Van A", checkin: "08:05", checkout: "17:32")
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))

        HvglWidgetEntryView(
            entry: AttendanceEntry(date: Date(), userName: "Nguyen Van A", checkin: "08:05", checkout: "--")
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
#endif
