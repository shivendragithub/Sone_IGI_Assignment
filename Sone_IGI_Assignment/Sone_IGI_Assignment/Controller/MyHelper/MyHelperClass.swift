//
//  MyHelperClass.swift
//  Medtrail_assignment
//
//  Created by shivendra pandey on 3/12/20.
//  Copyright © 2020 shivendra pandey. All rights reserved.
//

import Foundation
import UIKit


class MyHelper: NSObject {
    class func showAlertTostWithTitle(_ title : String?, message : String) ->(){
        let valid_Title = (title == nil) ? "" : title
        let alertController = UIAlertController(title: valid_Title,
                                                message: message, preferredStyle: .alert)
        alertController.show()
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            alertController.dismiss(animated: true, completion: nil)
        })
    }
}

