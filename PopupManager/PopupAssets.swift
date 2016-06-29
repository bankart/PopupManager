//
//  PopupProtocol.swift
//  PopupManager
//
//  Created by taehoon lee on 2016. 6. 23..
//  Copyright © 2016년 taehoon lee. All rights reserved.
//

import UIKit

// type alias
typealias confirmCompletion = () -> ()
typealias cancelCompletion = (NSError) -> ()
typealias messageTuple = (message:String, confirm:confirmCompletion?, cancel:cancelCompletion?)
typealias DelayedAction = () -> ()


// string key
let KEY_CONFIRM_ITEM: String = "keyConfirmItem"
let KEY_CANCEL_ITEM: String = "keyCancelItem"


// popup button item
struct PopupButtonItem {
    let title:String
    var confirm:confirmCompletion?
    var cancel:cancelCompletion?
    
    init(titleString: String!, confirmBlock:confirmCompletion?) {
        title = titleString
        confirm = confirmBlock
    }
    
    init(titleString: String!, cancelBlock:cancelCompletion?) {
        title = titleString
        cancel = cancelBlock
    }
    
    init(titleString:String!, confirmBlock:confirmCompletion?, cancelBlock:cancelCompletion?) {
        title = titleString
        confirm = confirmBlock
        cancel = cancelBlock
    }
}

protocol PopupItemBase {
    var size: CGSize {get}
    init(title: String?, message: String!, buttonItems: [PopupButtonItem]!, size: CGSize?)
    init(message: String!, buttonItems: [PopupButtonItem]!)
    init(message: String!)
}

struct PopupItem: PopupItemBase {
    
    let title: String?
    let message: String!
    let buttonItems: [PopupButtonItem]!
    private var _size: CGSize
    var size: CGSize {
        return _size
    }
    
    init(title: String?, message: String!, buttonItems: [PopupButtonItem]!, size: CGSize?) {
        self.title = title
        self.message = message
        self.buttonItems = buttonItems
        self._size = size ?? CGSize.zero
    }
    
    init(message: String!, buttonItems: [PopupButtonItem]!) {
        self.title = ""
        self.message = message
        self.buttonItems = buttonItems
        self._size = CGSize.zero
    }
    
    init(message: String!) {
        self.title = "Notice"
        self.message = message
        self.buttonItems = [PopupButtonItem(titleString:"OK", confirmBlock: {})]
        self._size = CGSize.zero
    }
}





