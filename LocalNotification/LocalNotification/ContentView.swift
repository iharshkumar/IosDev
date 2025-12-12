//
//  ContentView.swift
//  LocalNotification
//
//  Created by BATCH02L1 on 12/12/25.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack {
            Text("Local Notifications Batch Example")
                .font(.title)
                .padding()
            
            Button("Send Batch Notification"){
                sendNotification()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
    func sendNotification(){
        let content = UNMutableNotificationContent()
        content.title="Batch Notification"
        content.body="This is a batch local notification example"
        content.sound = UNNotificationSound.default
        
        let trigger =
        UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats:false)
        
        let request =
        UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request){
            error in
            if let error = error{
                print("Error scheduling notification : \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ContentView()
}
