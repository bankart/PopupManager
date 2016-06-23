//
//  Popup.swift
//  PopupManager
//
//  Created by taehoon lee on 2016. 6. 11..
//  Copyright © 2016년 taehoon lee. All rights reserved.
//

import UIKit
import SnapKit

typealias DelayedAction = () -> ()

// MARK: - class
class Popup: UIView {
    
    private let defaultSize: CGSize = CGSizeMake(280.0, 200.0)
    private static let _sharedInstance: Popup = Popup.init(frame: UIScreen.mainScreen().bounds)
    static func sharedInstance() -> Popup {
        return _sharedInstance
    }

    var popupItems:[PopupItem]?
    var confirmButtonItem:PopupButtonItem?
    var cancelButtonItem:PopupButtonItem?
    private var popupView: UIView = UIView(frame: CGRectMake(0.0, 0.0, 280.0, 200.0))
    private var action: DelayedAction!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.popupView.backgroundColor = UIColor.darkGrayColor()
        self.popupView.layer.cornerRadius = 7
        self.popupView.layer.borderWidth = 2
        self.popupView.layer.borderColor = UIColor.redColor().CGColor
        
        self.addSubview(self.popupView)
        NSLog("Popup: \(self)")
        NSLog("PopupView: \(self.popupView)")
//        let compareFrame = CGRectMake(frame.origin.x, frame.origin.y, defaultSize.width, defaultSize.height)
//        if !CGRectContainsRect(frame, compareFrame) {
//            self.frame = compareFrame
//            setNeedsLayout()
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        if self.superview != nil {
            self.popupView.snp_makeConstraints(closure: { (make) in
                make.center.equalTo(self)
            })
            NSLog("snapkitting")
        }
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
    
    func hide() {
        
        let parent = rootView()
        if parent.subviews.contains(self.popupView) {
            self.popupView.removeFromSuperview()
        } else {
            NSLog("already hided")
        }
        
    }
    
    func showWithItems(items:[PopupItem]) {
        
        self.popupItems = items
        guard let popupViewItems = self.popupItems else {
            NSLog("have no popup items")
            return
        }
        
        self.popupView.removeConstraints(self.popupView.constraints)
        self.popupView.subviews.enumerate().forEach { (index, element) in
            element.removeFromSuperview()
        }
        
        let gap: CGFloat = 10.0
        let buttonItems = popupViewItems.first!.buttonItems
        let buttonCount: Int = buttonItems.count
        let buttonWidth: CGFloat = (self.popupView.bounds.size.width - (gap * (2 + CGFloat(buttonCount) - 1))) / CGFloat(buttonCount)
        let buttonHeight: CGFloat = 30.0
        NSLog("btnCount: \(buttonCount)")
        NSLog("btnW: \(buttonWidth), btnH: \(buttonHeight)")
        buttonItems.enumerate().forEach { (index, item) in
            let btn = self.makeDefaultButton(CGRectMake(0.0, 0.0, buttonWidth, buttonHeight), title: item.title)
            btn.setActionTo({ (button) in
                if let cancelBlock = item.cancel {
                    cancelBlock(NSError(domain: "Popup", code: 400, userInfo: nil))
                }
                if let confirmBlock = item.confirm {
                    confirmBlock()
                }
                }, forEvents: UIControlEvents.TouchUpInside)
            self.popupView.addSubview(btn)
            btn.snp_makeConstraints(closure: { (make) in
                make.bottom.equalTo(self.popupView)
                if index == 0 {
                    make.left.equalTo((buttonWidth + gap)*CGFloat(index)).offset(gap)
                } else {
                    make.left.equalTo((buttonWidth + gap)*CGFloat(index))
                }
            })
        }
        
        let parent = rootView()
        if parent.subviews.contains(self.popupView) {
            NSLog("todo: update ui")
        } else {
            parent.addSubview(self.popupView)
        }
        
    }
    
    func makeDefaultButton(frame: CGRect, title: String) -> UIButton {
        let btn: UIButton = UIButton.init(type: UIButtonType.Custom)
        btn.backgroundColor = UIColor.init(colorLiteralRed: 0.45, green: 0.65, blue: 0.15, alpha: 0.45)
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.blackColor().CGColor
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.frame = frame
        return btn
    }
    
    func rootView() -> UIView {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.window!
    }
}


private extension UIButton {
    
    private func setOrTriggerClosure(closure:((button:UIButton) -> Void)? = nil) {
        
        //struct to keep track of current closure
        struct ClosureStore {
            static var closure :((button:UIButton) -> Void)?
        }
        
        //if closure has been passed in, set the struct to use it
        if closure != nil {
            ClosureStore.closure = closure
        } else {
            //otherwise trigger the closure
            ClosureStore.closure?(button: self)
        }
    }
    
    @objc private func triggerActionClosure() {
        self.setOrTriggerClosure()
    }
    
    func setActionTo(closure:(UIButton) -> Void, forEvents :UIControlEvents) {
        
        NSLog("execute closure >> \(self.titleLabel?.text!)")
        closure(self)
        
        self.setOrTriggerClosure(closure)
        self.addTarget(self, action:
            #selector(UIButton.triggerActionClosure),
                       forControlEvents: forEvents)
    }
    
}

