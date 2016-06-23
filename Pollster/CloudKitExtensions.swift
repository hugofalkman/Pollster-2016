//
//  CloudKitExtensions.swift
//  Pollster
//
//  Created by H Hugo Falkman on 2016-06-22.
//  Copyright © 2016 H Hugo Falkman. All rights reserved.
//

import CloudKit

struct CloudKitNotifications {
    static let NotificationReceived = "iCloudRemoteNotificationReceived"
    static let NotificationKey = "Notification"
}

struct Cloud {
    struct Entity {
        static let QandA = "QandA"
        static let Response = "Response"
    }
    struct Attribute {
        static let Question = "question"
        static let Answers = "answers"
        static let ChosenAnswer = "chosenAnswer"
        static let QandA = "qanda"
    }
}

extension CKRecord {
    var wasCreatedByThisUser: Bool {
        // should be built in to CKRecord?
        return (creatorUserRecordID == nil) || (creatorUserRecordID?.recordName == "__defaultOwner__")
    }
}