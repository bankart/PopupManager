//
//  Popup.swift
//  PopupManager
//
//  Created by taehoon lee on 2016. 6. 11..
//  Copyright © 2016년 taehoon lee. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - class
class Popup: UIView {
    
    private let defaultSize: CGSize = CGSizeMake(280.0, 200.0)
    static let sharedInstance: Popup = Popup.init(frame: CGRectMake(0.0, 0.0, 280.0, 220.0))

    var buttonItems:[PopupItemBase]?
    var confirmButtonItem:PopupButtonItem?
    var cancelButtonItem:PopupButtonItem?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let compareFrame = CGRectMake(frame.origin.x, frame.origin.y, defaultSize.width, defaultSize.height)
        if !CGRectContainsRect(frame, compareFrame) {
            self.frame = compareFrame
            setNeedsLayout()
        }
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


extension Popup {
    
    func showWithItems(items:[PopupItemBase]) {
        
        self.snp_makeConstraints { (make) in
            make.center.equalTo(self.superview!)
        }
        
        self.buttonItems = items
        guard let buttons = self.buttonItems else {
            NSLog("have no button items")
            return
        }
        
        let buttonCount: Int = buttons.count
        let buttonWidth: CGFloat = self.bounds.size.width / CGFloat(buttonCount)
        buttons.enumerate().forEach { (index, item) in
            let btn: UIButton = UIButton.init(type: UIButtonType.Custom)
            var h: CGFloat = buttonWidth
            if let s: CGSize = item.size {
                if s.height > buttonWidth {
                    h = s.height
                }
            }
            btn.frame = CGRectMake(0.0, 0.0, buttonWidth, h)
            btn.setTitle(item.title, forState: UIControlState.Normal)
            self.addSubview(btn)
            btn.snp_makeConstraints(closure: { (make) in
                make.bottom.equalTo(self)
                make.left.equalTo(self).inset(buttonWidth*CGFloat(index))
            })
        }
        
    }
    
}



