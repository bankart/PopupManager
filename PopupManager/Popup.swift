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
    
//    private let defaultSize: CGSize = CGSizeMake(280.0, 200.0)
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
        self.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        
        self.popupView.backgroundColor = UIColor.lightGrayColor()
        self.popupView.layer.cornerRadius = 5
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
    
//    override func didMoveToSuperview() {
//        if self.superview != nil {
//            self.popupView.snp_makeConstraints(closure: { (make) in
//                make.center.equalTo(self)
//            })
//            NSLog("snapkitting")
//        }
//    }
    
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
        if parent.subviews.contains(self) {
            self.removeFromSuperview()
        } else {
            NSLog("already hided")
        }
        
    }
    
    func showWithItems(items:[PopupItem]) {
        
        let parent = rootView()
        if parent.subviews.contains(self) {
            NSLog("todo: update ui")
        } else {
            parent.addSubview(self)
            self.snp_makeConstraints(closure: { (make) in
                make.center.equalTo(parent)
            })
        }
        
        self.popupItems = items
        guard let popupViewItems = self.popupItems else {
            NSLog("have no popup items")
            return
        }
        
        self.popupView.removeConstraints(self.popupView.constraints)
        self.popupView.subviews.enumerate().forEach { (index, element) in
            element.removeFromSuperview()
        }
        self.popupView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(self.popupView.bounds.size.width)
            make.height.equalTo(self.popupView.bounds.size.height)
        }
        
        let padding: CGFloat = 20.0
        let gap: CGFloat = 10.0
        let buttonItems = popupViewItems.first!.buttonItems
        let buttonCount: Int = buttonItems.count
        let buttonWidth: CGFloat = (self.popupView.bounds.size.width - (gap * (2 + CGFloat(buttonCount) - 1))) / CGFloat(buttonCount)
        let buttonHeight: CGFloat = 30.0
        
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
        }
        
        let buttons = self.popupView.subviews.filter { (subView) -> Bool in
            if subView.dynamicType == UIButton.self {
                return true
            }
            return false
        }
        
        for i in 0..<buttons.count {
            let btn = buttons[i]
            if i == 0 {
                btn.snp_makeConstraints(closure: { (make) in
                    make.left.equalTo(self.popupView).inset(padding)
                    make.bottom.equalTo(self.popupView).inset(gap)
                })
            } else {
                
                let lastObject = (i == buttons.count - 1)
                let prev = buttons[i - 1]
                btn.snp_makeConstraints(closure: { (make) in
                    make.left.equalTo(prev.snp_right).offset(gap)
                    make.bottom.equalTo(self.popupView).inset(gap)
                    make.width.equalTo(prev)
                    if lastObject {
                        make.right.equalTo(self.popupView).inset(padding)
                    }
                })
                
                if lastObject {
                    let first = buttons.first!
                    first.snp_makeConstraints(closure: { (make) in
                        make.width.equalTo(btn)
                    })
                }
            }
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
        self.setOrTriggerClosure(closure)
        self.addTarget(self, action:
            #selector(UIButton.triggerActionClosure),
                       forControlEvents: forEvents)
    }
    
}













/*

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
*/


