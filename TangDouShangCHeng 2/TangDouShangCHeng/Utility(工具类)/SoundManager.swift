//
//  SoundManager.swift
//  TangDouShangCHeng
//
//  Created by 黎应明 on 2018/6/14.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit
import AudioToolbox //导入框架

class SoundManager: NSObject {
    var soundId:SystemSoundID = 0
    
    enum SoundType {
        case doo, re, mi, fa, so, la, se
    }
    
    func loadaudioFile(soundType: SoundType) {
        var sound = (name:"error", type:"wav")
        switch soundType {
        case .doo:
            sound = (name:"doo", type:"wav")
        case .re:
            sound = (name:"re", type:"wav")
        case .mi:
            sound = (name:"mi", type:"mp3")
        case .fa:
            sound = (name:"fa", type:"wav")
        case .so:
            sound = (name:"so", type:"wav")
        case .la:
            sound = (name:"la", type:"wav")
        case .se:
            sound = (name:"se", type:"wav")
        }
        
        let soundUrl = URL.init(fileURLWithPath: Bundle.main.path(forResource: sound.name, ofType: sound.type)!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundId)
    }
    
    func playSound() {
        AudioServicesPlaySystemSound(soundId)
        // 震动
        //AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
}
