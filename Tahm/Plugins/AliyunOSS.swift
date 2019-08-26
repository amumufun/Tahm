//
//  AliyunOSS.swift
//  Tahm
//
//  Created by Chace on 2019/8/12.
//  Copyright © 2019 Chace. All rights reserved.
//

import AliyunOSSiOS

class AliyunOSS: UploadClient {
    var bucketName = "test12121212"
    var endPoint = "oss-cn-beijing.aliyuncs.com"
    var accessKeyId = "LTAIz9SxEpl2RAee"
    var secretKeyId = "rhAGk1nnr0I2xECUhw4joKAuBPrDi5"
    
    var totalBytesExpectedToSend: Int64 = 0
    var bytesSent: Int64 = 0
    
    var results: [UploadResult] = []
    
    override func upload(_ urls: [URL]) {
        totalBytesExpectedToSend = 0
        bytesSent = 0
        let provider = OSSCustomSignerCredentialProvider { (content, error) -> String? in
            let tToken = OSSFederationToken()
            tToken.tAccessKey = self.accessKeyId
            tToken.tSecretKey = self.secretKeyId
            
            return OSSUtil.sign(content, with: tToken)
        }
        let client = OSSClient(endpoint: endPoint, credentialProvider: provider!)
        
        let opt = BlockOperation()
        for url in urls {
            totalBytesExpectedToSend += FileUtil.getSizeWithFilePath(url)
            
            let request = OSSMultipartUploadRequest()
            request.uploadingFileURL = url
            request.bucketName = bucketName
            request.objectKey = url.lastPathComponent
            // request.partSize = 102400
            request.uploadProgress = { (bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) -> Void in
                self.uploadProgress(bytesSent: bytesSent)
            }
            let task = client.multipartUpload(request)
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
                    self.results.append(UploadResult(originalName: url.lastPathComponent, url: "\(self.endPoint).\(self.endPoint)/\(url.lastPathComponent)", uploadTime: date, storage: "AliyunOSS"))
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
}
