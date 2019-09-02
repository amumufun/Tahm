//
//  MenuTable.swift
//  Tahm
//
//  Created by Chace on 2019/8/21.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa

struct Menu {
    let image: String
    let text: String
    let tab: Int
}

class MenuTable: NSTableView {
    
    let menus = [
        Menu(image: "status-logo", text: "上传", tab: TabViews.Upload.rawValue),
        Menu(image: "record", text: "历史", tab: TabViews.History.rawValue),
        Menu(image: "setting", text: "配置", tab: TabViews.Preferences.rawValue),
        Menu(image: "help", text: "帮助", tab: TabViews.Help.rawValue)
    ]
    
    var activeIndex: Int = 0

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func awakeFromNib() {
        self.dataSource = self
        self.delegate = self
    }
    
    func clickMenu(row: Int, tab: Int) {
        guard activeIndex != row else {
            return
        }
        activeIndex = row
        Utils.switchTab(tab: tab)
        self.reloadData()
    }
    
}

extension MenuTable: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return menus.count
    }
}

extension MenuTable: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MenuCell"), owner: self) as? MenuTableCellView {
            cell.selected = activeIndex == row
            cell.iconView.image = NSImage(named: menus[row].image)
            cell.textLabel.stringValue = menus[row].text
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        clickMenu(row: row, tab: menus[row].tab)
        return false
    }
}

