//
//  SMSView.swift
//  Vulcan
//
//  Created by Aiden McDougal on 10/7/23.
//

import SwiftUI

struct SMSPanel: View {
    @StateObject var smsTestData = SMSTestData()
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Awaiting Approval")
                .foregroundColor(.theme.white)
                .fontWeight(.semibold)
                .font(.title2)
            Divider()
            ScrollView(.vertical) {
                VStack(spacing: 10) {
                    ForEach(smsTestData.smsPushes) { sms in
                        SMSDisplay(sms: sms)
                    }
                }
            }
        }
        .padding(5)
    }
}

#Preview {
    SMSPanel()
}

struct SMSDisplay: View {
    var sms: SMSPush
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(sms.subject)
                    .font(.headline)
                Spacer(minLength: 0.0)
                Text("LVL: \(sms.severity)")
            }
            .foregroundColor(.theme.white)
            HStack(spacing: 0) {
                Text(sms.timeStamp, style: .time) +
                Text(": ") +
                Text(sms.message)
            }
                .multilineTextAlignment(.leading)
                .foregroundColor(.theme.lightGray)
            Text(sms.url!)
                .foregroundColor(.blue)
            Divider()
        }
        .font(.subheadline)
    }
}
