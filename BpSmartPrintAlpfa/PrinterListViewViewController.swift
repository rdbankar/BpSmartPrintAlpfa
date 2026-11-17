//
//  PrinterListViewViewController.swift
//  BpSmartPrintAlpfa
//
//  Created by Ankit Dabas on 12/09/23.
//

import UIKit
import CoreBluetooth

class PrinterListViewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var MainViewCtrl:ViewController?
   
    var periphrallist = Array<CBPeripheral>()
    var printerdevice:CBPeripheral?
    @IBOutlet weak var BPprinterList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        BPprinterList.register(UITableViewCell.self,forCellReuseIdentifier: "TableViewCell")
        BPprinterList.delegate = self
        BPprinterList.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnBackTap(_ sender: Any) {
        MainViewCtrl?.onUserAction(data:"Back From DeviceListView")
        dismiss(animated: false, completion: nil)
    }
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       BPprinterList.deselectRow(at: indexPath, animated: false)
        printerdevice = periphrallist[indexPath.row]
        print(printerdevice!)
       MainViewCtrl?.onUserselectprinter(p_dev: printerdevice!)
        dismiss(animated: false, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.periphrallist.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell",
                                                 for: indexPath)
        cell.textLabel?.text = self.periphrallist[indexPath.row].name
        return cell
    }
    
}
