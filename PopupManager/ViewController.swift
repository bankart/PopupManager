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
    
    @IBOutlet weak var titleLabel : UILabel?
    @IBOutlet weak var styleButton0 : UIButton?
    @IBOutlet weak var styleButton1 : UIButton?
    @IBOutlet weak var styleButton2 : UIButton?
    
    @IBAction func onStyleButton0(sender:AnyObject?) {
        NSLog("onStyleButton0")
        let popup: Popup = Popup()
        popup.showWithMessageInfo(("style0", {NSLog("confirm completion")}, {_ in }))
//        popup.showWithMessageInfo((message:"style0", confirm:{NSLog("confirm completion")}, cancel:{NSLog("error: \($0)")}))
        
        
        let popupButtonItems: Dictionary<String, PopupButtonItem> =
            [KEY_CANCEL_ITEM:
                PopupButtonItem(titleString: "cancel", cancelBlock: {_ in })]
        popup.showWithMessage("style0", and: popupButtonItems)
    }
    
    @IBAction func onStyleButton1(sender:AnyObject?) {
        NSLog("onStyleButton1")
        let popup: Popup = Popup()
        let popupButtonItems: Dictionary<String, PopupButtonItem> =
            [KEY_CONFIRM_ITEM:
                PopupButtonItem(titleString: "confirm", confirmBlock: {NSLog("confirm completion")})]
        popup.showWithMessage("style1", and: popupButtonItems)
    }
    
    @IBAction func onStyleButton2(sender:AnyObject?) {
        NSLog("onStyleButton2")
        let popup: Popup = Popup()
        let popupButtonItems: Dictionary<String, PopupButtonItem> =
            [KEY_CONFIRM_ITEM:
                PopupButtonItem(titleString: "confirm", confirmBlock: {NSLog("confirm completion")}),
             KEY_CANCEL_ITEM:
                PopupButtonItem(titleString: "cancel", cancelBlock: {_ in })]
        popup.showWithMessage("style2", and: popupButtonItems)
    }
    
    private func resetUI() {
        self.view.removeConstraints(self.view.constraints)
        
        self.titleLabel?.snp_makeConstraints(closure: { (make) in
            make.centerX.equalTo(self.view);
            make.top.equalTo(70.0)
        })
        
        self.styleButton0?.snp_makeConstraints(closure: { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo((self.titleLabel?.snp_bottom)!).offset(5)
        })
        
        self.styleButton1?.snp_makeConstraints(closure: { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo((self.styleButton0?.snp_bottom)!).offset(5)
        })
        
        self.styleButton2?.snp_makeConstraints(closure: { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo((self.styleButton1?.snp_bottom)!).offset(5)
        })
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

