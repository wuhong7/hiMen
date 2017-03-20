//
//  demoController.swift
//  hiMen
//
//  Created by 盖特 on 2017/3/20.
//  Copyright © 2017年 盖特. All rights reserved.
//

import UIKit

class demoController: UIViewController {

    var startRecBtn : UIButton?
    var textView : UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}


// MARK: - UI界面
extension demoController{
    
    func setupUI(){
        
        view.backgroundColor = UIColor.white
        
        textView = UITextView(frame: CGRect(x: 10, y: 10, width: 300, height: 200))
        textView?.backgroundColor = UIColor.red
        self.view.addSubview(textView!)
        
        
        startRecBtn = UIButton(frame: CGRect(x: 20, y: 300, width: 60, height: 40))
        startRecBtn?.setTitle("开始", for: .normal)
        startRecBtn?.setTitleColor(UIColor.black, for: .normal)
        startRecBtn?.addTarget(self, action: #selector(beginRecognize), for: .touchUpInside)
        self.view.addSubview(startRecBtn!)
        
        
        
    }
}


// MARK: - 用户交互层
extension demoController{
    
    func beginRecognize(){
        
        
        textView?.text = ""
        textView?.resignFirstResponder()
        
       SpeechHelper.shared.beginRecognize { [weak self] (result, currentState) in
        
        if result != nil{
            self?.textView?.text = result
        }else{
            self?.textView?.text = currentState
        }
        
        }
        
        
    }
    
}
