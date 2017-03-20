//
//  SpeechHelper.swift
//  hiMen
//
//  Created by 盖特 on 2017/3/19.
//  Copyright © 2017年 盖特. All rights reserved.
//

import UIKit

class SpeechHelper: NSObject {
    //单例
    static let shared = SpeechHelper()

    private override init() {}

    
    /// 初始化语音识别
    ///
    /// - Parameters:
    ///   - APPID: 用户id
    ///   - LogFileLevel: 打印日志等级
    ///   - showLogcat: 是否打印日志
    class func Speech(APPID:String,LogFileLevel:LOG_LEVEL,showLogcat:Bool){
        
        //设置sdk的log等级，log保存在下面设置的工作路径中
        IFlySetting.setLogFile(LogFileLevel)
        //打开输出在console的log开关
        IFlySetting.showLogcat(showLogcat)
        //设置sdk的工作路径
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let cachePath:String = paths[0]
        IFlySetting.setLogFilePath(cachePath)
        //创建语音配置,appid必须要传入，仅执行一次则可
        //所有服务启动前，需要确保执行createUtility
        IFlySpeechUtility.createUtility("appid=\(APPID)")
     
        
    }
    
}
