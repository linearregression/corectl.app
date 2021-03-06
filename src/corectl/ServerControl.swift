//
//  ServerControl.swift
//  corectl
//
//  Created by Rimantas Mocevicius on 06/07/2016.
//  Copyright © 2016 The New Normal. All rights reserved.
//

import Foundation
import Cocoa

// server control //

// start corectld server
func ServerStart() {
    // send stop to corectld just in case it was left running
    ServerStop()
    
    let menuItem : NSStatusItem = statusItem
    
    // start corectld server
    let task = NSTask()
    task.launchPath = "/usr/local/sbin/corectld"
    task.arguments = ["start"]
    task.launch()
    
    menuItem.menu?.itemWithTag(1)?.title = "Server is running"
    menuItem.menu?.itemWithTag(1)?.state = NSOnState
}


func ServerStartShell() {
    // send stop to corectld just in case it was left running
    ServerStop()
    
    let menuItem : NSStatusItem = statusItem
    
    // start corectld server
    let task: NSTask = NSTask()
    let launchPath = NSBundle.mainBundle().resourcePath! + "/start_corectld.command"
    task.launchPath = launchPath
    task.launch()
    //
    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
    dispatch_after(time, dispatch_get_main_queue()) {
        //
        let script = NSBundle.mainBundle().resourcePath! + "/check_corectld_status.command"
        let status = shell(script, arguments: [])
        NSLog("corectld status: '%@'",status)
        //
        if (status == "no"){
            let menuItem : NSStatusItem = statusItem
            menuItem.menu?.itemWithTag(1)?.title = "Server is Off"
            // display the error message
            let mText: String = "Corectl for macOS"
            let infoText: String = "Cannot start the \"corectld server\" !!!"
            displayWithMessage(mText, infoText: infoText)
        }
        else {
            menuItem.menu?.itemWithTag(1)?.title = "Server is running"
            menuItem.menu?.itemWithTag(1)?.state = NSOnState
            //
            let script = NSBundle.mainBundle().resourcePath! + "/check_corectld_version.command"
            let version = shell(script, arguments: [])
            NSLog("corectld version: '%@'",version)
            menuItem.menu?.itemWithTag(11)?.title = " Server version: " + version
        }
    }
}


// stop corectld server
func ServerStop() {
    let menuItem : NSStatusItem = statusItem
    
    // stop corectld server
    let task = NSTask()
    task.launchPath = "/usr/local/sbin/corectld"
    task.arguments = ["stop"]
    task.launch()
    
    menuItem.menu?.itemWithTag(1)?.title = "Server is off"
    menuItem.menu?.itemWithTag(1)?.state = NSOffState
}

