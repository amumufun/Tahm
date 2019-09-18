//
//  TencentCOS.swift
//  Tahm
//
//  Created by Chace on 2019/9/2.
//  Copyright © 2019 Chace. All rights reserved.
//

import QCloudCore
import QCloudCOSXML

class TencentCOS: UploadClient {
    
    var config: TencentCOSConfig?
    var appID: String?
    var bucket: String?
    
    var totalBytesExpectedToSend: Int64 = 0
    var bytesSent: Int64 = 0
    var results: [UploadResult] = []
    
    required init() {
        super.init()
        
        guard checkConfig() else {
            return
        }
        
        initClient()
    }
    
    func initClient() {
        let qcConfig = QCloudServiceConfiguration()
        qcConfig.appID = appID
        qcConfig.signatureProvider = self
        
        let endPoint = QCloudCOSXMLEndPoint()
        endPoint.regionName = config!.endPoint
        
        qcConfig.endpoint = endPoint
        
        QCloudCOSXMLService.registerDefaultCOSXML(with: qcConfig)
        QCloudCOSTransferMangerService.registerDefaultCOSTransferManger(with: qcConfig)
    }
    
    override func upload(_ urls: [URL]) {
        results = []

        guard checkConfig() else {
            return
        }
        
        initClient()
        
        self.delegate?.uploadStart()
        
        totalBytesExpectedToSend = 0
        bytesSent = 0
        let opt = BlockOperation()
        
        for url in urls {
            totalBytesExpectedToSend += Utils.getSizeWithFilePath(url)
            
            let filename = self.getName(lastPathComponent: url.lastPathComponent)
            let put = QCloudCOSXMLUploadObjectRequest<AnyObject>()
            put.object = config!.path + filename
            put.bucket = bucket
            put.body = url as NSURL
            put.sendProcessBlock = { (bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) -> Void in
                self.uploadProgress(bytesSent: bytesSent)
            }
            put.setFinish({ (result, error) in
                if error != nil {
                    let error = error! as NSError
                    print(error)
                } else {
                    let date = Date()
                    self.results.append(UploadResult(originalName: url.lastPathComponent, url: "\(String(describing: result?.location))", uploadTime: date, storage: "TencentCOS"))
                    
                    self.delegate?.uploadSuccess(results: self.results)
                }
            })
            QCloudCOSTransferMangerService.defaultCOSTransferManager()?.uploadObject(put)
        }
        OperationQueue.current?.maxConcurrentOperationCount = 2
        OperationQueue.current?.addOperation(opt)
    }
    
    func checkConfig() -> Bool {
        if let configData = UserDefaults.standard.retrive(TencentCOSConfig.self, key: TencentCOSConfigKey) {
            if configData.bucketName.isEmpty || configData.endPoint.isEmpty || configData.secretId.isEmpty || configData.secretKey.isEmpty {
                Utils.showNotification(message: "请填写配置必要数据", title: "提示")
                return false
            } else {
                let arr = configData.bucketName.split(separator: "-")
                bucket = String(arr[0])
                appID = String(arr[1])
                config = configData
                return true
            }
        }
        Utils.showNotification(message: "请先修改图床配置", title: "提示")
        return false
    }
    
    override func uploadProgress(bytesSent: Int64) {
        self.bytesSent += bytesSent
        let percentage = Double(self.bytesSent) / Double(totalBytesExpectedToSend)
        self.delegate?.uploadProgress(percentage: percentage)
    }
}

extension TencentCOS: QCloudSignatureProvider {
    func signature(with fileds: QCloudSignatureFields!, request: QCloudBizHTTPRequest!, urlRequest urlRequst: NSMutableURLRequest!, compelete continueBlock: QCloudHTTPAuthentationContinueBlock!) {
        let credential = QCloudCredential()
        credential.secretID = config!.secretId
        credential.secretKey = config!.secretKey
        let creator = QCloudAuthentationV5Creator(credential: credential)
        let signature = creator?.signature(forData: urlRequst)
        continueBlock(signature, nil)
    }
}
