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
    static let sharedInstance: Popup = Popup.init(frame: UIScreen.mainScreen().bounds)

    var popupItems:[PopupItem]!
    var confirmButtonItem:PopupButtonItem?
    var cancelButtonItem:PopupButtonItem?
    var popupView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.45)
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Popup.handleTap(_:)))
        self.addGestureRecognizer(tapGR)
        self.popupView = UIView.init(frame: CGRectMake(0.0, 0.0, self.defaultSize.width, self.defaultSize.height))
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

extension Popup: UIGestureRecognizerDelegate {
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.Ended {
            
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

extension Popup {
    
    func showWithItems(items:[PopupItem]) {
        
        self.popupItems = items
        guard let popupViewItems = self.popupItems else {
            NSLog("have no button items")
            return
        }
        
        if popupViewItems.isEmpty {
            return
        }
        
        let item = popupViewItems[0]
        
        self.frame = CGRectMake(0.0, 0.0, item.size.width, item.size.height)
        self.snp_makeConstraints { (make) in
            make.center.equalTo(self.superview!)
        }
        
        let buttonsCount: Int = item.buttonItems.count
        let buttonWidth: CGFloat = self.bounds.size.width / CGFloat(buttonsCount)
        let buttonHeight: CGFloat = 35.0
        item.buttonItems.enumerate().forEach { (index, item) in
            let btn: UIButton = UIButton.init(type: UIButtonType.Custom)
            btn.frame = CGRectMake(0.0, 0.0, buttonWidth, buttonHeight)
            btn.setTitle(item.title, forState: UIControlState.Normal)
            btn.setActionTo({ (button) in
                if let handler = item.confirm {
                    handler()
                }
                }, forEvents: UIControlEvents.TouchUpInside)
            self.addSubview(btn)
            btn.snp_makeConstraints(closure: { (make) in
                make.bottom.equalTo(self)
                make.left.equalTo(self).inset(buttonWidth*CGFloat(index))
            })
        }
    }
    
}

private extension UIButton {
    func setOrTriggerClosure(closure:((button: UIButton) -> Void)? = nil) {
        struct InternalClosureTemporary {
            static var closure: ((button: UIButton) -> Void)?
        }
        
        if closure != nil {
            InternalClosureTemporary.closure = closure
        } else {
            InternalClosureTemporary.closure?(button:self)
        }
    }
    
    @objc func triggerActionClosure() {
        self.setOrTriggerClosure()
    }
    
    func setActionTo(closure:(UIButton) -> Void, forEvents: UIControlEvents ) {
        self.setOrTriggerClosure(closure)
        self.addTarget(self, action: #selector(UIButton.triggerActionClosure), forControlEvents: forEvents)
    }
}



