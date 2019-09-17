//
//  CloudConfig.swift
//  Tahm
//
//  Created by Chace on 2019/8/29.
//  Copyright © 2019 Chace. All rights reserved.
//

import Foundation

struct CloudConfig {
    let key: String
    let name: String
    let className: String
    let suffix: String
}

// 原本想支持手动添加配置，但是窗口设计的太小了，嗯，下一版重构再做吧
let cloudConfigList: [CloudConfig] = [
    CloudConfig(key: AliyunOSSConfigKey, name: "阿里云OSS", className: "AliyunOSS", suffix: "?x-oss-process=image/auto-orient,1/resize,m_lfit,w_120/quality,q_100/format,jpg"),
    CloudConfig(key: TencentCOSConfigKey, name: "腾讯云COS", className: "TencentCOS", suffix: "")
]
