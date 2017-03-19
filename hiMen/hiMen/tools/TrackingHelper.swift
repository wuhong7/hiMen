//
//  TrackingHelper.swift
//  hiMen
//
//  Created by 盖特 on 2017/3/19.
//  Copyright © 2017年 盖特. All rights reserved.
//

import UIKit

class TrackingHelper {
    
    class func trackSetting(
        Appid:String,
        CollectorStatus:Bool,
        DebugMode:Bool,CaptureUncaughtException:Bool,
        MonitorStatus:Bool,
        MonitorTimeInterval:Double,
        AutoLocation:Bool,
        Duid:String)
    {
        //开启日志收集总开关
        IFlyFlowerCollector.setCollectorStatus(CollectorStatus)
        IFlyFlowerCollector.setDebugMode(DebugMode)
        IFlyFlowerCollector.setCaptureUncaughtException(CaptureUncaughtException)
        //开启卡顿信息收集
        IFlyFlowerCollector.setBlockMonitorStatus(MonitorStatus)
        IFlyFlowerCollector.setBlockMonitorTimeInterval(MonitorTimeInterval)
        IFlyFlowerCollector.setAppid(Appid)
        IFlyFlowerCollector.setAutoLocation(AutoLocation)
        IFlyFlowerCollector.setDuid(Duid)
        
    }
    

}
