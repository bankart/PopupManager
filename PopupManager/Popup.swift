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
typealias messageTuple = (message:String, confirm:confirmCompletion?, cancel:cancelCompletion?)

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
    var temp: String
    
    override init(frame: CGRect) {
        temp = ""
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: use tuple
    func showWithMessageInfo(messageInfo:messageTuple) {
        NSLog("== showWithMessageInfo ===========================================")
        NSLog("message: \(messageInfo.message)")
        if let confirmBlock = messageInfo.confirm {
            NSLog("confirm: \(messageInfo.confirm)")
            confirmBlock()
        }
        
        if let cancelBlock = messageInfo.cancel {
            NSLog("cancel: \(messageInfo.cancel)")
            cancelBlock(NSError(domain: "popupManager", code: 1000, userInfo: nil))
        }
    }
    
    // MARK: use dictionary
    func showWithMessage(message:String, buttonItems:Dictionary<String, PopupButtonItem>) -> Void {
        NSLog("== showWithMessage ===========================================")
        var log:String = "showWithMessageInfo2 >> message: \(message)"
        if let confirmItem:PopupButtonItem = buttonItems[KEY_CONFIRM_ITEM] {
            confirmButtonItem = confirmItem
            log = log + ", has confirm"
        }
        
        if let cancelItem:PopupButtonItem = buttonItems[KEY_CANCEL_ITEM] {
            cancelButtonItem = cancelItem
            log = log + ", has cancel"
        }
        
        NSLog(log)
        
    }
    
}