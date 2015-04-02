//
//  ViewController.swift
//  BLEPeripheral_Lynda_Example
//
//  Copyright (c) 2015 yuryg. All rights reserved.
//  cleanest possible swift re-write.
//
//  Created by Michael Lehman on 4/6/14.
//  Copyright (c) 2014 Michael Lehman. All rights reserved.

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralManagerDelegate {

   
    // UI Elements
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var startAdvertisingButton: UIButton!
    
    @IBOutlet weak var myTextView: UITextView!
    
    //  CoreBluetooth Objects
    var myPeripheralManager = CBPeripheralManager()
    var transferCharacteristic = CBMutableCharacteristic()  // supports both read and notify
    
    // BLE Flow and Logic Control
    var bluetoothOn = false
    var advertising = false
    var initialized = false
    var advertisingData = NSDictionary()

    //Defined Constants
    let CHARACTERISTIC_UUID = CBUUID(string: "FFF3")  // To be Put in Dictionary
    let SERVICE_UUID = CBUUID(string: "FFF0")       // To be put in dictionary

   
    
//MARK viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    
        bluetoothOn = false
        advertising = false
        initialized = false

     myPeripheralManager = CBPeripheralManager(delegate: self, queue: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//MARK  UI
    
    func printToMyTextView(passedString: String){
        myTextView.text = passedString + "\r" + myTextView.text
    }
    
    
    
    @IBAction func startStopAdvertising(sender: UIButton) {
        println("start Button Pressed")
        
        if (advertising == true ){
            advertising = false
            myPeripheralManager.stopAdvertising()
            printToMyTextView("** Stopped Adverstising **")

            return
        }
    
        if(!self.initialized){
            
        // Make a Characteristic
        transferCharacteristic = CBMutableCharacteristic(type: CHARACTERISTIC_UUID ,
                                                       properties: CBCharacteristicProperties.Notify | CBCharacteristicProperties.Read,
                                                            value: nil,
                                                      permissions: CBAttributePermissions.Readable)
        
        
        // Make A Service
        var transferService =  CBMutableService(type: SERVICE_UUID, primary: true)
        
        var myCharacteristicsArray: NSArray = [transferCharacteristic]  // put one item into array.
            
        // At Character to Service
        transferService.characteristics = myCharacteristicsArray  //pass this array to service's characteristics
        

        myPeripheralManager.addService(transferService)
            
            
            var myDictionary: [NSObject:AnyObject]? = [:]
            
            //  THIS WORKED
            myDictionary = [CBAdvertisementDataLocalNameKey : "Peripheral name"]
            
            myPeripheralManager.startAdvertising(myDictionary!)
            
            
            //myPeripheralManager.startAdvertising(advertisementData: [CBAdvertisementDataLocalNameKey : "Peripheral name"]!)
            
            
          //  [_peripheralManager startAdvertising:@{CBAdvertisementDataLocalNameKey : @"Peripheral name",
          //      CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:@"generated-string-using-uuidgen"]]}];
           
            
            
            
   //         advertisingData = CBAdvertisementDataTxPowerLevelKey(CBAdvertisementDataTxPowerLevelKey)
        
//        CBAdvertisementDataLocalNameKey: CBUUID(string: "BLEPeripheral") ,
  //                       CBAdvertisementDataServiceUUIDsKey: CBUUID(string: "SERVICE_UUID")
    //                        ]

}
 
        //       advertisingData = [ CBAdvertisementDataLocalNameKey: CBUUID(string: "BLEPeripheral") ,

        
        
        
        
        
        // Drum Roll Please.  Start Advertising
        myPeripheralManager.startAdvertising(advertisingData)
        printToMyTextView("* Started Adverstising *")

}


    
//Mark  BLE Code
    
    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {

        printToMyTextView("segmentedControlChanged")
        sendData()
    }
    
    
    
    func sendData(){
        printToMyTextView("sendData")

        var dataToSend = NSString()
        
        if (segControl.selectedSegmentIndex == 0){
            dataToSend = "0x0101"
        }
        else{
            dataToSend = "0x0202"
        }
        
      //  var chunk = dataToSend.dataUsingEncoding(NSStringenc )
        
        


    //    var myEOMData = "EOM".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
     //   var eomSent = peripheralManager.updateValue(myEOMData, forCharacteristic: transferCharacteristic, onSubscribedCentrals: nil)
        
     //   var myChunk = dataToSend.dataUsingEncoding(NSUTF8StringEncoding) //32 bit string encoding
//        var chunk = dataToSend.dataUsingEncoding(NSStringEncodingConversionOptions.ExternalRepresentation, allowLossyConversion: false)
        
//        chunk = dataToSend.dataUsingEncoding(NSStringEncodingConversionExternalRepresentation)
        
    
    
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        //
        println("peripheralManagerDidUpdateState")
        
        if ( peripheral.state ==  CBPeripheralManagerState.PoweredOff ){
            printToMyTextView("bluetoothOn = false")
            bluetoothOn = false
        } else{
            printToMyTextView("bluetoothOn = true")
            bluetoothOn = true
        }
        
    }

    
    
    
    func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager!) {
        //
    }
    
    func peripheralManager(peripheral: CBPeripheralManager!, central: CBCentral!, didSubscribeToCharacteristic characteristic: CBCharacteristic!) {
        //
    }
    
}

