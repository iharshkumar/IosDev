import SwiftUI
import UserNotifications

struct Reminder: Identifiable, Codable {
    let id: UUID
    let text: String
    let date: Date
    var isDone: Bool = false
}

class ReminderStore: ObservableObject {
    @Published var reminders: [Reminder] = []
}

struct ContentView: View {
    
    @EnvironmentObject var reminderStore: ReminderStore
    @State private var reminderText: String = ""
    @State private var reminderDate: Date = Date().addingTimeInterval(60)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                Text("📌 Reminders")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.blue)
                    .padding(.top)
                
                VStack(spacing: 15) {
                    TextField("Enter reminder message", text: $reminderText)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(radius: 1)
                    
                    DatePicker(
                        "Select Time",
                        selection: $reminderDate,
                        in: Date()...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                    .padding(.horizontal)
                    
                    Button(action: scheduleReminder) {
                        Text("Set Reminder")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    colors: [Color.blue, Color.purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(15)
                            .shadow(radius: 3)
                    }
                }
                .padding(.horizontal)
                
                Divider().padding(.vertical, 10)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Upcoming Reminders")
                        .font(.headline)
                        .padding(.leading)
                    
                    if upcomingReminders.isEmpty {
                        Text("No upcoming reminders")
                            .foregroundColor(.gray)
                            .italic()
                            .padding(.leading)
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(upcomingReminders) { reminder in
                                    ReminderCard(reminder: reminder, deleteAction: {
                                        deleteReminder(reminder)
                                    }, isHistory: false)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(maxHeight: 250)
                    }
                }
                
                Divider().padding(.vertical, 10)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("History")
                        .font(.headline)
                        .padding(.leading)
                    
                    if historyReminders.isEmpty {
                        Text("No past reminders")
                            .foregroundColor(.gray)
                            .italic()
                            .padding(.leading)
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(historyReminders) { reminder in
                                    ReminderCard(reminder: reminder, deleteAction: {
                                        deleteReminder(reminder)
                                    }, isHistory: true)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(maxHeight: 250)
                    }
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
    
    var upcomingReminders: [Reminder] {
        reminderStore.reminders.filter { !$0.isDone }.sorted { $0.date < $1.date }
    }
    
    var historyReminders: [Reminder] {
        reminderStore.reminders.filter { $0.isDone }.sorted { $0.date > $1.date }
    }
    
    func scheduleReminder() {
        guard reminderDate > Date() else {
            print("❌ ERROR: Time must be in the future.")
            return
        }
        
        let id = UUID()
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = reminderText.isEmpty ? "It's time!" : reminderText
        content.sound = UNNotificationSound(named: UNNotificationSoundName("aag.caf"))

        
        // Use time interval trigger for reliable testing
        let interval = max(reminderDate.timeIntervalSinceNow, 1)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: id.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Notification scheduling error: \(error.localizedDescription)")
                } else {
                    print("✅ Notification scheduled for \(self.reminderDate)")
                    let newReminder = Reminder(id: id, text: self.reminderText, date: self.reminderDate)
                    withAnimation {
                        self.reminderStore.reminders.append(newReminder)
                        self.reminderText = ""
                        self.reminderDate = Date().addingTimeInterval(60)
                    }
                }
            }
        }
    }
    
    func deleteReminder(_ reminder: Reminder) {
        withAnimation {
            reminderStore.reminders.removeAll { $0.id == reminder.id }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
        }
    }
}

struct ReminderCard: View {
    let reminder: Reminder
    let deleteAction: () -> Void
    let isHistory: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.text.isEmpty ? "No message" : reminder.text)
                    .font(.headline)
                    .foregroundColor(.white)
                Text("At: \(formattedDate(reminder.date))")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            Spacer()
            Button(action: deleteAction) {
                Image(systemName: "trash")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: isHistory ? [Color.gray, Color.black.opacity(0.7)] : [Color.purple, Color.blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(15)
        .shadow(radius: 4)
    }
    
    func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.timeStyle = .short
        f.dateStyle = .medium
        return f.string(from: date)
    }
}

#Preview {
    ContentView()
        .environmentObject(ReminderStore())
}
