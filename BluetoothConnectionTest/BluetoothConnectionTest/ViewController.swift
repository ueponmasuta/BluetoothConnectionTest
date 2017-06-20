//
//  ViewController.swift
//  BluetoothConnectionTest
//
//  Created by 植原　駿 on 2017/06/17.
//  Copyright © 2017年 Shun Uehara. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    /// UIパーツ
    var connectionList: UITableView!
    var bluetoothSwitch:UISwitch = UISwitch()
    /// BLE制御
    var centralManager: BLEManager = BLEManager()
    
    /// タイマー
    var timer:Timer!

    /// 定数
    let titleName = ["Bluetooth"]
    
    /// 配列
    var connectionName:[String] = []
    var sectionName = ["　"]
    
    /// 画面パラメータ保持
    var switchFlag:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status Barの高さを取得する.
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        // Viewの高さと幅を取得する.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // TableViewの生成(Status barの高さをずらして表示).
        connectionList = UITableView(frame: CGRect(x:0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        // Cellの高さを設定
        connectionList.rowHeight = 50
        // Cell名の登録をおこなう.
        connectionList.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        // DataSourceを自身に設定する.
        connectionList.dataSource = self
        // Delegateを自身に設定する.
        connectionList.delegate = self
        // Viewに追加する.
        self.view.addSubview(connectionList)
        
        // timerの設定
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.tableUpdate), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     セクションの数を返す.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionName.count
    }
    
    /*
     セクションのタイトルを返す.
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionName[section]
    }
    
    /*
     Cellが選択された際に呼び出される.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // デバッグ用
        print("Num: \(indexPath.row)")
        print("Value: \(connectionName[indexPath.row])")
        // ペリフェラルへ接続
        centralManager.connectPeripheral(selectRow: indexPath.row)
    }
    
    /*
     Cellの総数を返す.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return titleName.count
        } else if section == 1 {
            print("接続先数: \(connectionName.count)")
            return connectionName.count
        } else {
            return 0
        }
    }
    
    /*
     Cellに値を設定する.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        if indexPath.section == 0 {
            if (cell.accessoryView == nil) {
                cell.accessoryView = bluetoothSwitch
                bluetoothSwitch.addTarget(self, action: #selector(changeSwitch(sender:)), for: UIControlEvents.valueChanged)
            }
            cell.textLabel!.text = "\(titleName[indexPath.row])"
        
        } else if indexPath.section == 1 {
            // Cellに値を設定する.
            cell.textLabel!.text = "\(connectionName[indexPath.row])"
        }
        return cell
    }

    /*
     Switchを変更する.
     */
    func changeSwitch(sender: UISwitch){
        guard self.switchFlag != sender.isOn else {
            print("switchFlag : \(switchFlag)")
            // ON/OFFに変更がなければ処理をしない
            return
        }
        
        switchFlag = sender.isOn
        if switchFlag {
            // Bluetoothの接続先検索を開始する
            centralManager.initCentralManager()
            // timer開始
            timer.fire()
            // セクションを表示する
            sectionName = ["　", "myDevice"]
        } else {
            // Bluetoothの接続先検索を終了する
            centralManager.stopPeripheralScan()
            // timerを停止
            timer.invalidate()
            // 画面表示のリセット
            connectionName = []
            sectionName = ["　"]
        }
        connectionList.reloadData()
    }

    /*
     テーブルを更新する.
     */
    func tableUpdate () {
        self.connectionName = centralManager.names
        self.connectionList.reloadData()
    }
}

