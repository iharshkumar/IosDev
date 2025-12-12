import SwiftUI
import UserNotifications

@main
struct RemainderAssignmentApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var reminderStore = ReminderStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(reminderStore)
                .onAppear {
                    appDelegate.reminderStore = reminderStore
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var reminderStore: ReminderStore?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Permission error: \(error.localizedDescription)")
                } else {
                    print("✅ Permission granted: \(granted)")
                }
            }
        }
        return true
    }
    
    // Notification delivered while app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        DispatchQueue.main.async {
            if let id = UUID(uuidString: notification.request.identifier),
               let index = self.reminderStore?.reminders.firstIndex(where: { $0.id == id }) {
                self.reminderStore?.reminders[index].isDone = true
            }
        }
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }
}
