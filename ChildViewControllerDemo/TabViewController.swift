//
//  TabViewController.swift
//  ChildViewControllerDemo
//
//  Created by taolv on 15/8/11.
//  Copyright (c) 2015年 taolv365.ios.recycle. All rights reserved.
//

import UIKit

class TabViewController: UIViewController {

    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let label = UILabel(frame: CGRect(x: 50, y: 100, width: 200, height: 20))
        label.text = "i am \(index)"
        label.textColor = UIColor.whiteColor()
        switch index {
        case 0 :
            label.backgroundColor = UIColor.redColor()
        case 1 :
            label.backgroundColor = UIColor.greenColor()
        case 2 :
            label.backgroundColor = UIColor.blueColor()
        default:
            // break 语句在swift中是不是没什么用？以后再补语法吧
            break
        }
        self.view.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
