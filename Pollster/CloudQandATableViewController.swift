//
//  CloudQandATableViewController.swift
//  Pollster
//
//  Created by H Hugo Falkman on 2016-06-22.
//  Copyright © 2016 H Hugo Falkman. All rights reserved.
//

import UIKit
import CloudKit

class CloudQandATableViewController: QandATableViewController {
    
    var ckQandARecord: CKRecord {
        get {
            if _ckQandARecord == nil {
                _ckQandARecord = CKRecord(recordType: Cloud.Entity.QandA)
            }
            return _ckQandARecord!
        }
        set {
            _ckQandARecord = newValue
        }
    }
    
    private var _ckQandARecord: CKRecord? {
        didSet {
            qanda = QandA(question: ckQandARecord.question,
                          answers: ckQandARecord.answers)
            asking = ckQandARecord.wasCreatedByThisUser
        }
    }
    
    private let database = CKContainer.defaultContainer().publicCloudDatabase
    
    @objc private func iCloudUpdate() {
        if !qanda.question.isEmpty && !qanda.answers.isEmpty {
            ckQandARecord[Cloud.Attribute.Question] = qanda.question
            ckQandARecord[Cloud.Attribute.Answers] = qanda.answers
            iCloudSaveRecord(ckQandARecord)
        }
    }
    
    private func iCloudSaveRecord(recordToSave: CKRecord) {
        database.saveRecord(recordToSave) { (savedRecord, error) in
            if error?.code == CKErrorCode.ServerRecordChanged.rawValue {
                // optimistic locking failed, ignore
            } else if error != nil {
                self.retryAfterError(error, withSelector: #selector(self.iCloudUpdate))
            }
        }
    }
    
    private func retryAfterError(error: NSError?, withSelector selector: Selector) {
        if let retryInterval = error?.userInfo[CKErrorRetryAfterKey] as? NSTimeInterval {
            dispatch_async(dispatch_get_main_queue()) {
                NSTimer.scheduledTimerWithTimeInterval(
                    retryInterval, target: self, selector: selector,
                    userInfo: nil, repeats: false)
            }
        }
    }
    
    override func textViewDidEndEditing(textView: UITextView) {
        super.textViewDidEndEditing(textView)
        iCloudUpdate()
    }
}
