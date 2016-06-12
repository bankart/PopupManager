//
//  Popup.swift
//  PopupManager
//
//  Created by taehoon lee on 2016. 6. 11..
//  Copyright © 2016년 taehoon lee. All rights reserved.
//

import UIKit

// type alias
typealias confirmCompletion = () -> ()
typealias cancelCompletion = (NSError) -> ()
typealias messageTuple = (message:String, confirm:confirmCompletion, cancel:cancelCompletion)

// string key
let KEY_CONFIRM_ITEM: String = "keyConfirmItem"
let KEY_CANCEL_ITEM: String = "keyCancelItem"

// popup button item
struct PopupButtonItem {
    let title:String
    var confirm:confirmCompletion?
    var cancel:cancelCompletion?
    
    init(titleString: String, confirmBlock:confirmCompletion) {
        title = titleString
        confirm = confirmBlock
    }
    
    init(titleString: String, cancelBlock:cancelCompletion) {
        title = titleString
        cancel = cancelBlock
    }
    
    init(titleString:String, confirmBlock:confirmCompletion, cancelBlock:cancelCompletion) {
        title = titleString
        confirm = confirmBlock
        cancel = cancelBlock
    }
}

// MARK: - class
class Popup: UIView {
    
    var confirmButtonItem:PopupButtonItem?
    var cancelButtonItem:PopupButtonItem?
    
    // MARK: use tuple
    func showWithMessageInfo(messageInfo:messageTuple) {
        let msg: String = messageInfo.message ?? "no message"
        NSLog("message: \(msg)")
        NSLog("confirm: \(messageInfo.confirm)")
        NSLog("cancel: \(messageInfo.cancel)")
    }
    
    // MARK: use dictionary
    func showWithMessage(message:String, and completions:Dictionary<String, PopupButtonItem>) -> Void {
        
        var log:String = "showWithMessageInfo2 >> message: \(message)"
        if let confirmItem:PopupButtonItem = completions[KEY_CONFIRM_ITEM] {
            confirmButtonItem = confirmItem
            log = log + ", has confirm"
        }
        
        if let cancelItem:PopupButtonItem = completions[KEY_CANCEL_ITEM] {
            cancelButtonItem = cancelItem
            log = log + ", has cancel"
        }
        
        NSLog(log)
        
    }
    
}