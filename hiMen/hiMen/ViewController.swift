//
//  ViewController.swift
//  hiMen
//
//  Created by 盖特 on 2017/3/17.
//  Copyright © 2017年 盖特. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,IFlyRecognizerViewDelegate{

    var iflyRecognizerView : IFlyRecognizerView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //语音识别
        SpeechHelper.Speech(APPID: "58cbba9d", LogFileLevel: .LVL_ALL, showLogcat: true)
        initRecognizer()
        
        
        
        
        print("nihao")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initRecognizer(){
        
        if iflyRecognizerView == nil {
            
            iflyRecognizerView = IFlyRecognizerView(center: self.view.center)
            self.view.addSubview(iflyRecognizerView!)
            iflyRecognizerView?.delegate = self
            
            iflyRecognizerView?.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
            
            //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
            iflyRecognizerView?.setParameter("asrview.pcm", forKey: IFlySpeechConstant.asr_AUDIO_PATH())
            
            iflyRecognizerView?.start()
        }
        
        
        
    }
    
    func onResult(_ resultArray: [Any]!, isLast: Bool) {
        print("\(resultArray)")
    }

    func onError(_ error: IFlySpeechError!) {
        print("\(error)")
    }

}

