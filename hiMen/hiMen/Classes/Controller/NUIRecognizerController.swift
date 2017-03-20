//
//  NUIRecognizerController.swift
//  hiMen
//
//  Created by 盖特 on 2017/3/20.
//  Copyright © 2017年 盖特. All rights reserved.
//

import UIKit

class NUIRecognizerController: UIViewController {

    
    var startRecBtn : UIButton?
    
    var textView : UITextView?
    
    var currenString : NSString?
    
    
    //语音识别器
    var iFlySpeechRecognizer : IFlySpeechRecognizer?

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
extension NUIRecognizerController{
    
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
extension NUIRecognizerController{
    
    func beginRecognize(){
        

        textView?.text = ""
        textView?.resignFirstResponder()

        if iFlySpeechRecognizer == nil {
            initRecognizer()
        }
        iFlySpeechRecognizer?.cancel()
        
        //设置音频来源为麦克风
        iFlySpeechRecognizer?.setParameter(IFLY_AUDIO_SOURCE_MIC, forKey: "audio_source")
        //设置听写结果格式为json
        iFlySpeechRecognizer?.setParameter("json", forKey: IFlySpeechConstant.result_TYPE())
        //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
        iFlySpeechRecognizer?.setParameter("asr.pcm", forKey: IFlySpeechConstant.asr_AUDIO_PATH())
        
        iFlySpeechRecognizer?.startListening()
  
        
    }
    
}


// MARK: - 语音识别
extension NUIRecognizerController:IFlySpeechRecognizerDelegate{
    
    func initRecognizer(){
        
        
        //单例模式，无UI的实例
        if iFlySpeechRecognizer == nil {
            iFlySpeechRecognizer = IFlySpeechRecognizer.sharedInstance()
            
            iFlySpeechRecognizer?.setParameter("", forKey: IFlySpeechConstant.params())
            
            //设置听写模式
            iFlySpeechRecognizer?.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
            
        }
        
        iFlySpeechRecognizer?.delegate = self
        
        if iFlySpeechRecognizer != nil {
            let instance = IATConfig.sharedInstance()
            //设置最长录音时间
            iFlySpeechRecognizer?.setParameter(instance?.speechTimeout, forKey: IFlySpeechConstant.speech_TIMEOUT())
            
            //设置后端点
            iFlySpeechRecognizer?.setParameter(instance?.vadEos, forKey: IFlySpeechConstant.vad_EOS())
            //设置前端点
            iFlySpeechRecognizer?.setParameter(instance?.vadBos, forKey: IFlySpeechConstant.vad_BOS())
            //网络等待时间
            iFlySpeechRecognizer?.setParameter("20000", forKey: IFlySpeechConstant.net_TIMEOUT())
            //设置采样率，推荐使用16K
            iFlySpeechRecognizer?.setParameter(instance?.sampleRate, forKey: IFlySpeechConstant.sample_RATE())
            
            
            if instance?.language == IATConfig.chinese()  {
                //设置语言
                iFlySpeechRecognizer?.setParameter(instance?.language, forKey: IFlySpeechConstant.language())
                //设置方言
                iFlySpeechRecognizer?.setParameter(instance?.accent, forKey: IFlySpeechConstant.accent())
            }
            else if instance?.language == IATConfig.english(){
            
                iFlySpeechRecognizer?.setParameter(instance?.language, forKey: IFlySpeechConstant.language())
        
            }
            //设置是否返回标点符号
            iFlySpeechRecognizer?.setParameter(instance?.dot, forKey: IFlySpeechConstant.asr_PTT())
            
        }
        
        
    }
    
    // MARK: IFlySpeechRecognizerDelegate
    
    
    /**
     听写结束回调（注：无论听写是否正确都会回调）
     error.errorCode =
     0     听写正确
     other 听写出错
     ****/
    func onError(_ errorCode: IFlySpeechError!) {
        
        var text : String?
        if errorCode.errorCode == 0 {
            if (currenString == nil) {
                text = "无识别结果";
            }else {
                text = "识别成功";
                //清空识别结果
                currenString = nil;
            }
        }else {
            text = NSString.localizedStringWithFormat("发生错误：%d %@", errorCode.errorCode,errorCode.errorDesc) as String
        }
        
        
        print("\(text!)")
        
    }
    
    /**
     无界面，听写结果回调
     results：听写结果
     isLast：表示最后一次
     ****/
    func onResults(_ results: [Any]!, isLast: Bool) {
        let resultString = NSMutableString()
        
        guard results != nil else {
            return
        }
        
        let dict = results[0] as? NSDictionary;
        
        dict?.enumerateKeysAndObjects({ (key, obj, nil) in
         
           resultString.appendFormat("%@", key as! CVarArg)
            
        })
        
        let resultFromJson = self.stringFromJson(params: resultString as String!)
        
        textView?.text = (textView?.text)!+resultFromJson!
        currenString = textView?.text as NSString?
        
        if isLast {
             print("\(resultFromJson!)")
        }
       
    }
    
    
    
    
    func stringFromJson(params:String?)->String?{
        
        if params == nil {
            return nil
        }
        
        var tempStr = String()
        let resultDic = try! JSONSerialization.jsonObject(with:(params?.data(using: .utf8))! , options: .allowFragments) as? [String: Any]
        
        if resultDic != nil {
            let wordArray = resultDic?["ws"] as? [Any]
            
            for (_, obj) in (wordArray?.enumerated())! {
                
                let wsDic = obj as? [String: Any]
                let cwArray = wsDic?["cw"] as? [Any]
                
                for(_, obj) in (cwArray?.enumerated())!{
                    
                    let wDic = obj as? [String: Any]
                    let str = wDic?["w"] as? String
                    tempStr = tempStr+str!
                }
            }
        }
        return tempStr
    }
    
}


