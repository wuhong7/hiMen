//
//  RecognizerController.swift
//  hiMen
//
//  Created by 盖特 on 2017/3/20.
//  Copyright © 2017年 盖特. All rights reserved.
//

import UIKit

class RecognizerController: UIViewController {
    
    var iflyRecognizerView : IFlyRecognizerView?
    var startRecBtn : UIButton?
    
    
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
extension RecognizerController{
   
    func setupUI(){

        view.backgroundColor = UIColor.white
    
        let textView = UITextView(frame: CGRect(x: 10, y: 10, width: 300, height: 40))
        self.view.addSubview(textView)
        
        
        startRecBtn = UIButton(frame: CGRect(x: 20, y: 300, width: 60, height: 40))
        startRecBtn?.setTitle("开始", for: .normal)
        startRecBtn?.setTitleColor(UIColor.black, for: .normal)
        startRecBtn?.addTarget(self, action: #selector(beginRecognize), for: .touchUpInside)
        self.view.addSubview(startRecBtn!)
        

        
    }
    
}


// MARK: - 用户交互层
extension RecognizerController{
   
    func beginRecognize(){
        
        initRecognizer()
        print("开始")
    }
    
    
}


// MARK: - 语音识别
extension RecognizerController:IFlyRecognizerViewDelegate{
    
    
    
    func initRecognizer(){
        
        if iflyRecognizerView == nil {
            
            iflyRecognizerView = IFlyRecognizerView(center: self.view.center)
            self.view.addSubview(iflyRecognizerView!)
            iflyRecognizerView?.delegate = self
            
            iflyRecognizerView?.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
            
            //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
            iflyRecognizerView?.setParameter("asrview.pcm", forKey: IFlySpeechConstant.asr_AUDIO_PATH())
            
            
        }
        iflyRecognizerView?.start()
        
        
    }
    
    func onResult(_ resultArray: [Any]!, isLast: Bool) {
        print("\(resultArray)")
    }
    
    func onError(_ error: IFlySpeechError!) {
        print("\(error)")
    }

    
    
}
