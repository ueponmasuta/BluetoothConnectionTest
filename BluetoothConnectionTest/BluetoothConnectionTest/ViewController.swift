//
//  ViewController.swift
//  BluetoothConnectionTest
//
//  Created by 植原　駿 on 2017/06/17.
//  Copyright © 2017年 Shun Uehara. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    /// test用配列
    var arr = ["test1", "test2", "test3"]
    
    /// Bluetooth接続先リスト
    var connectionList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status Barの高さを取得する.
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        // Viewの高さと幅を取得する.
        let displayWidth: CGFloat = self.view.frame.width - 20
        let displayHeight: CGFloat = self.view.frame.height - 20
        
        // TableViewの生成(Status barの高さをずらして表示).
        connectionList = UITableView(frame: CGRect(x:10, y: barHeight + 10, width: displayWidth, height: displayHeight))
        connectionList.rowHeight = 30
        // Cell名の登録をおこなう.
        connectionList.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        // DataSourceを自身に設定する.
        connectionList.dataSource = self
        // Delegateを自身に設定する.
        connectionList.delegate = self
        // Viewに追加する.
        self.view.addSubview(connectionList)
        
        let blueToothSwicth: UISwitch = UISwitch()
        blueToothSwicth.layer.position = CGPoint(x: 0, y: 0)

        // Swicthの枠線を表示する.
        blueToothSwicth.tintColor = UIColor.black
        
        // SwitchをOnに設定する.
        blueToothSwicth.isOn = true
        
        // SwitchのOn/Off切り替わりの際に、呼ばれるイベントを設定する.
        blueToothSwicth.addTarget(self, action: Selector(("onClickMySwicth:")), for: UIControlEvents.valueChanged)
        
        // SwitchをViewに追加する.
        self.view.addSubview(blueToothSwicth)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     Cellが選択された際に呼び出される
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(arr[indexPath.row])")
    }
    
    /*
     Cellの総数を返す.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    /*
     Cellに値を設定する
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        // Cellに値を設定する.
        cell.textLabel!.text = "\(arr[indexPath.row])"
        
        return cell
    }


}

