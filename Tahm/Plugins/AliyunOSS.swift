//
//  AliyunOSS.swift
//  Tahm
//
//  Created by Chace on 2019/8/12.
//  Copyright © 2019 Chace. All rights reserved.
//

import AliyunOSSiOS

class AliyunOSS: UploadClient {
    
    var config: AliyunOSSConfig?
    var client: OSSClient?
    
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
            let request = OSSMultipartUploadRequest()
            request.uploadingFileURL = url
            request.bucketName = config!.bucketName
            request.objectKey = config!.path + "/" + filename
            request.uploadProgress = { (bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) -> Void in
                self.uploadProgress(bytesSent: bytesSent)
            }
            let task = client!.multipartUpload(request)
            task.continue({ (t) -> Any? in
                if (t.error != nil) {
                    let error = t.error! as NSError
                    print(error)
                } else {
                    let result = t.result as! OSSResumableUploadResult
                    let dict = result.httpResponseHeaderFields as NSDictionary
                    let dateStr = dict.value(forKey: "Date") as! String
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "E, d MMM yyyy HH:mm:ss 'GMT'"
                    let date = dateFormat.date(from: dateStr)!
                    self.results.append(UploadResult(originalName: url.lastPathComponent, url: "\(self.config!.ssl ? "https" : "http")://\(self.config!.bucketName).\(self.config!.endPoint)/\(filename)", uploadTime: date, storage: "AliyunOSS"))
                }
                if self.bytesSent == self.totalBytesExpectedToSend {
                    self.delegate?.uploadSuccess(results: self.results)
                }
                return nil
            })
        }
        OperationQueue.current?.maxConcurrentOperationCount = 2
        OperationQueue.current?.addOperation(opt)
    }
    
    override func uploadProgress(bytesSent: Int64) {
        self.bytesSent += bytesSent
        let percentage = Double(self.bytesSent) / Double(totalBytesExpectedToSend)
        self.delegate?.uploadProgress(percentage: percentage)
    }
    
    func checkConfig() -> Bool {
        if let configData = UserDefaults.standard.retrive(AliyunOSSConfig.self, key: AliyunOSSConfigKey) {
            if configData.accessKeyId.isEmpty || configData.secretKeyId.isEmpty || configData.bucketName.isEmpty || configData.endPoint.isEmpty {
                Utils.showNotification(message: "请填写配置必要数据", title: "提示")
                return false
            } else {
                config = configData
                return true
            }
        }
        Utils.showNotification(message: "请先修改图床配置", title: "提示")
        return false
    }
    
    func initClient() {
        let provider = OSSCustomSignerCredentialProvider { (content, error) -> String? in
            let tToken = OSSFederationToken()
            tToken.tAccessKey = self.config!.accessKeyId
            tToken.tSecretKey = self.config!.secretKeyId
            
            return OSSUtil.sign(content, with: tToken)
        }
        client = OSSClient(endpoint: config!.endPoint, credentialProvider: provider!)
    }
}
