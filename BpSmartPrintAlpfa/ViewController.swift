//
//  ViewController.swift
//  BpSmartPrintAlpfa
//
//  Created by Ankit Dabas on 08/09/23.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    var centralManager: CBCentralManager!
    var printerDevice: CBPeripheral?
    var printingCharacterStick: CBCharacteristic?
    var peripherals = Array<CBPeripheral>()
    var DevicelistViewCtrl: PrinterListViewViewController!
    var state = CBManagerState(rawValue:0)
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)        // Do any additional setup after loading the view.
    }
    @IBAction func btnTapConnect(_ sender: Any) {
        if(state == .poweredOn)
        {
            peripherals.removeAll()
            var specifiedServices: Set<String> = ["E7810A71-73AE-499D-8C15-FAA9AEF0C3F2"]
            let serviceUUIDs = specifiedServices.map { CBUUID(string: $0) }
            
            centralManager.scanForPeripherals(withServices: nil/*serviceUUIDs,options: nil*/)
        }
        else {
            print("BT Power DN")
        }
    }
    
    func onUserAction(data: String)
    {
        centralManager.stopScan()
        print(data)
       // TitleLbl.text="Data received: \(data)"
    }
    
    func onUserselectprinter(p_dev: CBPeripheral)
    {
        centralManager.stopScan()
        print(p_dev)
        centralManager.connect(p_dev, options: nil)
        p_dev.delegate = self
       // TitleLbl.text="Data received: \(data)"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //let name = "Deviec List"
            
        let destinationVC = segue.destination as! PrinterListViewViewController
            
        //destinationVC.tableViewData = self.tableViewData.map{$0}
        DevicelistViewCtrl = destinationVC
        destinationVC.periphrallist = self.peripherals.map{$0}
        destinationVC.MainViewCtrl = self
    }
    @IBAction func btnPrintTap(_ sender: Any) {
        guard let printerDevice = printerDevice else { return }
        guard let printingCharacterStick = printingCharacterStick else { return }

        let text = "demo line 1 demo line 2 demo line 1 demo line 2 demo line 1 demo line 2 \n"
        let data = text.data(using: .ascii)
        printerDevice.writeValue(data ?? Data(), for: printingCharacterStick, type: .withoutResponse)
        guard let image = UIImage(named: "bp"), let cgImage = image.cgImage
        else {
            return
        }
        
        let qrCodeA = BpQRCode(string: "hello", size: CGSize(width: 130, height: 130))!
        guard let QRImage = try? qrCodeA.image() ,  let cgQRimage = QRImage.cgImage
        else {
            return
            
        }
        let receipt = Receipt(.init(maxWidthDensity: 500, fontDensity: 12, encoding: .utf8))
            <<~ .style(.initialize)
            <<~ .page(.printAndFeed(lines: 3))
            <<~ .layout(.justification(.center))
            <<< Dividing.default()
            <<~ .style(.underlineMode(.enable2dot))
            <<< "This is test line data to be print - 1\n"
            <<< "This is test line data to be print - 2\n"
            <<< "This is test line data to be print - 3\n"
            <<< "This is test line data to be print - 4\n"
            <<< "This is test line data to be print - 5\n"
            <<< "This is test line data to be print - 6\n"
            <<< "This is test line data to be print - 7\n"
            <<< "This is test line data to be print - 8\n"
            <<< "This is test line data to be print - 9\n"
            <<< "This is test line data to be print - 10\n"
        <<< "This is test line data to be print - 11\n"
        <<< "This is test line data to be print - 12\n"
        <<< "This is test line data to be print - 13\n"
        <<< "This is test line data to be print - 14\n"
        <<< "This is test line data to be print - 15\n"
        <<< "This is test line data to be print - 16\n"
        <<< "This is test line data to be print - 17\n"
        <<< "This is test line data to be print - 18\n"
        <<< "This is test line data to be print - 19\n"
        <<< "This is test line data to be print - 20\n"            //<<< KVItem("k", "v")
            <<~ .style(.clear)
           <<< ImageItem(cgImage, grayThreshold: 64)
            <<< Dividing.default()
            <<~ .page(.printAndFeed(lines: 0))
            <<~ .style(.initialize)
          <<< ImageItem(cgQRimage , grayThreshold: 28)
            //<<< QRCode(content: "https://www.yuxiaor.com")
        <<< "This is test line data to be print - 19\n"
        <<< "This is test line data to be print - 20\n"
            //<<~ .cursor(.lineFeed)
            //<<< Command.cursor(.lineFeed)
           // <<~ .cursor(.lineFeed)
        <<~ .page(.partialCut)
        
        var start_idx = 0
        var end_idx = 0
        var rem_data_cnt = receipt.data.count
        while rem_data_cnt > 0
        {
            if( rem_data_cnt > 512  )
            {
                if( (start_idx  + 512) < receipt.data.count)
                {
                    end_idx = start_idx + 512
                }
                else
                {
                    end_idx = receipt.data.count
                }
                rem_data_cnt -= (end_idx-start_idx);
                let data1 = receipt.data[start_idx..<end_idx]
                printerDevice.writeValue(Data(data1), for: printingCharacterStick, type: .withoutResponse)
                
                print("##Data sent  \(rem_data_cnt) ::: \(receipt.data.count)::::\(data1.count)")
                start_idx = end_idx;
                
            }
            else if( rem_data_cnt > 0 )
            {
                
                end_idx = receipt.data.count
                if( start_idx < receipt.data.count )
                {
                  
                    let data1 = receipt.data[start_idx..<end_idx]
                    printerDevice.writeValue(Data(data1), for: printingCharacterStick, type: .withoutResponse)
                    print("@@Data sent \(rem_data_cnt) ::: \(receipt.data.count)::::\(data1.count)")
                    rem_data_cnt = 0;
                    //break
                }
                else
                {
                    rem_data_cnt = 0
                }
            }
            
        }
        centralManager.cancelPeripheralConnection(printerDevice)
       // printerDevice = nil
        //while rem_data_cnt > 0
        //let data1 = receipt.data[0..<100]
        //printerDevice.writeValue(Data(data1), for: printingCharacterStick, type: .withoutResponse)
        //print("Data sent \(receipt.data.count)::::\(data1.count)")
        
    }
       
}
extension ViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
                print(central, central.state)

        switch central.state {
          case .unknown:
            print("central.state is .unknown")
          case .resetting:
            print("central.state is .resetting")
          case .unsupported:
            print("central.state is .unsupported")
          case .unauthorized:
            print("central.state is .unauthorized")
          case .poweredOff:
            print("central.state is .poweredOff")
          case .poweredOn:
            print("central.state is .poweredOn")
            var specifiedServices: Set<String> = ["E7810A71-73AE-499D-8C15-FAA9AEF0C3F2"]
            let serviceUUIDs = specifiedServices.map { CBUUID(string: $0) }
            //centralManager.scanForPeripherals(withServices: nil, options: nil)
            state = central.state
            print(centralManager!, centralManager.state)
            count = 0
       
        @unknown default:
            print("default")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        if printerDevice == nil {
           if advertisementData.keys.contains("kCBAdvDataManufacturerData")
            {
               
               
               
               if peripheral.name != nil /*"ET16_NORM_BLE" */{
                   // printerDevice = peripheral
                   let val:NSData = advertisementData["kCBAdvDataManufacturerData"] as! NSData
                   
                  var bytes:Int32 = 0
                   val.getBytes(&bytes, length: 3)
                   if bytes == 1055488 {
                       print("\(count)", peripheral, advertisementData,"::::")
                       count += 1
                       
                      // print( "value is \(bytes)")
                       
                       peripherals.append(peripheral)
                       DevicelistViewCtrl.periphrallist = self.peripherals.map{$0}
                       DevicelistViewCtrl.BPprinterList.reloadData()
                   }
                   
                   
                   //     centralManager.stopScan()
                   
                   //    centralManager.connect(peripheral, options: nil)
                   //    peripheral.delegate = self
               }
           }
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected")
        printerDevice = peripheral
        peripheral.discoverServices(nil)
    }
    public func centralManager(_ central: CBCentralManager,
                               didDisconnectPeripheral peripheral: CBPeripheral,
                               error: Error?)
    {
        print("Disconnected")
        printerDevice = nil
    }
   
}

extension ViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        //print("didDiscoverServices", error ?? <#default value#> ?? <#default value#>, error?.localizedDescription //?? <#default value#> ?? <#default value#>)

        guard let services = peripheral.services else { return }

        for service in services {
            print(service, service.uuid)
            print(service.characteristics ?? "characteristics are nil", "adadgsfsd")
            peripheral.discoverCharacteristics(nil, for: service)

        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            print(characteristic.uuid.uuidString)
            if characteristic.uuid.uuidString ==  "FFE3"  {
                printingCharacterStick = characteristic

                print("sending data")
                let text = "demo line 1 demo line 2 demo line 1 demo line 2 demo line 1 demo line 2 "
                let data = text.data(using: .ascii)
                print(peripheral.maximumWriteValueLength(for: .withoutResponse))
                peripheral.writeValue(data ?? Data(), for: characteristic, type: .withoutResponse)
                
                print("sending data 2")

            }
        }
    }
}
