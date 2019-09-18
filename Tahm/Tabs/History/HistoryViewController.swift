//
//  HistoryViewController.swift
//  Tahm
//
//  Created by Chace on 2019/9/12.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa

class HistoryViewController: NSViewController {
    
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var emptyMessage: NSTextField!
    
    let itemId = NSUserInterfaceItemIdentifier("CollectionViewItem")
    var picList: [Pic] = []
    @objc dynamic lazy var coreDataManager: CoreDataManager = {
        return CoreDataManager()
    }()
    let prefs = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        scrollView.scrollerStyle = .overlay
        
        collectionView.register(CollectionViewItem.self, forItemWithIdentifier: itemId)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear() {
        getData()
    }
    
    func getData() {
        let request = NSFetchRequest<Pic>(entityName: "Pic")
        request.fetchOffset = 0
        request.fetchLimit = request.fetchOffset + 50
        
        let sort = NSSortDescriptor(key: "uploadTime", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            picList = try coreDataManager.managedObjectContext.fetch(request)
            
            if picList.count == 0 {
                emptyMessage.isHidden = false
            } else {
                emptyMessage.isHidden = true
            }
            
            collectionView.reloadData()
            collectionView.setFrameSize(collectionView.collectionViewLayout!.collectionViewContentSize)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        let selected = collectionView.selectionIndexPaths
        guard selected.count > 0 else {
            Utils.showNotification(message: "请选择图片", title: "提示")
            return
        }
        for indexPath in selected {
            coreDataManager.managedObjectContext.delete(picList[indexPath.item])
        }
        coreDataManager.saveAction(nil)
        getData()
    }
    
    @IBAction func copyButtonClicked(_ sender: Any) {
        var urls: [String] = []
        let selected = collectionView.selectionIndexPaths
        guard selected.count > 0 else {
            Utils.showNotification(message: "请选择图片", title: "提示")
            return
        }
        for indexPath in selected {
            urls.append(Utils.generateLinks(url: picList[indexPath.item].url!, type: prefs.format))
        }
        Utils.copyToPasteboard(string: urls.joined(separator: "\n"))
        if prefs.uploadMessage {
            Utils.showNotification(message: "\(urls.count)条图片地址已复制到剪贴板", title: "上传成功")
        }
        
    }
}

extension HistoryViewController: NSCollectionViewDelegateFlowLayout {
    // item 大小
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: 62, height: 60)
    }
    // 内边距
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, insetForSectionAt section: Int) -> NSEdgeInsets {
        return NSEdgeInsets(top: 20, left: 15, bottom: 10, right: 15)
    }
    // 行间距
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    // 列间距
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
}

extension HistoryViewController: NSCollectionViewDelegate {
}

extension HistoryViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return picList.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: itemId, for: indexPath)
        item.representedObject = picList[indexPath.item]
        return item
    }
    
    
}
