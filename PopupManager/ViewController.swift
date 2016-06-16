//
//  ViewController.swift
//  PopupManager
//
//  Created by taehoon lee on 2016. 6. 11..
//  Copyright © 2016년 taehoon lee. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var styleButton0 : UIButton!
    @IBOutlet weak var styleButton1 : UIButton!
    @IBOutlet weak var styleButton2 : UIButton!
    
    @IBAction func onStyleButton0(sender:AnyObject?) {
        NSLog("onStyleButton0")
        let popup: Popup = Popup()
        popup.showWithMessageInfo(("style0-0", {NSLog("confirm completion")}, nil))
        popup.showWithMessageInfo(("style0-1", nil, {NSLog("error: \($0)")}))
        popup.showWithMessageInfo(("style0-2", {NSLog("confirm completion")}, {NSLog("error: \($0)")}))
        
        let popupButtonItems: Dictionary<String, PopupButtonItem> =
            [KEY_CANCEL_ITEM:
                PopupButtonItem(titleString: "cancel", cancelBlock: {_ in })]
        popup.showWithMessage("style0-3", buttonItems: popupButtonItems)
    }
    
    @IBAction func onStyleButton1(sender:AnyObject?) {
        NSLog("onStyleButton1")
        let popup: Popup = Popup()
        let popupButtonItems: Dictionary<String, PopupButtonItem> =
            [KEY_CONFIRM_ITEM:
                PopupButtonItem(titleString: "confirm", confirmBlock: {NSLog("confirm completion")})]
        popup.showWithMessage("style1", buttonItems: popupButtonItems)
    }
    
    @IBAction func onStyleButton2(sender:AnyObject?) {
        NSLog("onStyleButton2")
        let popup: Popup = Popup()
        let popupButtonItems: Dictionary<String, PopupButtonItem> =
            [KEY_CONFIRM_ITEM:
                PopupButtonItem(titleString: "confirm", confirmBlock: {NSLog("confirm completion")}),
             KEY_CANCEL_ITEM:
                PopupButtonItem(titleString: "cancel", cancelBlock: {_ in })]
        popup.showWithMessage("style2", buttonItems: popupButtonItems)
    }
    
    private let padding: CGFloat = 30.0
    private let buttonGapY: CGFloat = 20.0
    private let buttonGapX: CGFloat = 15.0
    private func resetUI() {
        self.view.removeConstraints(self.view.constraints)
        
        self.titleLabel?.snp_makeConstraints(closure: { (make) in
            make.centerX.equalTo(self.view);
            make.top.equalTo(70.0)
        })
        
//        self.styleButton0?.snp_makeConstraints(closure: { (make) in
//            make.top.equalTo((self.titleLabel?.snp_bottom)!).offset(buttonGapY)
//            make.left.equalTo(self.view).inset(padding)
//            make.width.equalTo(self.styleButton1!)
//        })
//        
//        self.styleButton1?.snp_makeConstraints(closure: { (make) in
//            make.top.equalTo(self.styleButton0!)
//            make.leftMargin.equalTo(((self.styleButton0)?.snp_right)!).offset(buttonGapX)
//            make.rightMargin.equalTo((styleButton0?.snp_left)!).offset(buttonGapX)
//            make.width.equalTo(self.styleButton0!)
//        })
//        
//        self.styleButton2?.snp_makeConstraints(closure: { (make) in
//            make.top.equalTo(self.styleButton0!)
//            make.right.equalTo(self.view).inset(padding)
//            make.width.equalTo(self.styleButton0!)
//        })
        
        let btns = [self.styleButton0, self.styleButton1, self.styleButton2]
        btns.enumerate().forEach { (index, btn) in
            btn.snp_makeConstraints(closure: { (make) in
                
                if index == 0 {
                    make.left.equalTo(self.view).inset(padding)
                    let nextBtn = btns[index+1]
                    make.width.equalTo(nextBtn)
                } else {
                    let prevBtn = btns[index-1]
                    make.left.equalTo(prevBtn.snp_right).offset(buttonGapX)
                    if index == btns.count-1 {
                        make.right.equalTo(self.view).inset(padding)
                        make.width.equalTo(prevBtn)
                    }
                }
                make.height.equalTo(30.0)
                make.top.equalTo(self.titleLabel.snp_bottom).offset(buttonGapY)
            })
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        resetUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

