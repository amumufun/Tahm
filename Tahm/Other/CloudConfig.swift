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
}

let cloudConfigList: [CloudConfig] = [
    CloudConfig(key: AliyunOSSConfigKey, name: "阿里云OSS"),
    CloudConfig(key: TencentCOSConfigKey, name: "腾讯云COS")
]
