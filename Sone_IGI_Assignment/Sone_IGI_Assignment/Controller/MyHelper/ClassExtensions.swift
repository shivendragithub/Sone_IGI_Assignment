//
//  ClassExtensions.swift
//  Medtrail_Assignment
//
//  Created by shivendra pandey on 3/12/20.
//  Copyright © 2020 shivendra pandey. All rights reserved.
//

import Foundation
import UIKit



extension UISearchBar {
  private var textField: UITextField? {
      let subViews = self.subviews.flatMap { $0.subviews }
      if #available(iOS 13, *) {
          if let _subViews = subViews.last?.subviews {
              return (_subViews.filter { $0 is UITextField }).first as? UITextField
          }else{
              return nil
          }
          
      } else {
          return (subViews.filter { $0 is UITextField }).first as? UITextField
      }
      
  }
    private var searchIcon: UIImage? {
        let subViews = subviews.flatMap { $0.subviews }
        return  ((subViews.filter { $0 is UIImageView }).first as? UIImageView)?.image
    }
    
    private var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            let _searchIcon = searchIcon
            if newValue {
                if activityIndicator == nil {
                    let _activityIndicator = UIActivityIndicatorView(style: .gray)
                    _activityIndicator.startAnimating()
                    _activityIndicator.backgroundColor = UIColor.clear
                    let clearImage = UIImage().imageWithPixelSize(size: CGSize.init(width: 14, height: 14)) ?? UIImage()
                    self.setImage(clearImage, for: .search, state: .normal)
                    textField?.leftViewMode = .always
                    textField?.leftView?.addSubview(_activityIndicator)
                    let leftViewSize = CGSize.init(width: 14.0, height: 14.0)
                    _activityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                self.setImage(_searchIcon, for: .search, state: .normal)
                activityIndicator?.removeFromSuperview()
            }
        }
    }
}

extension UIImage {
    func imageWithPixelSize(size: CGSize, filledWithColor color: UIColor = UIColor.clear, opaque: Bool = false) -> UIImage? {
        return imageWithSize(size: size, filledWithColor: color, scale: 1.0, opaque: opaque)
    }

    func imageWithSize(size: CGSize, filledWithColor color: UIColor = UIColor.clear, scale: CGFloat = 0.0, opaque: Bool = false) -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        color.set()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
extension UICollectionView {
    func setBackGround(_ message : String? , _ topSpacing : CGFloat? = 0.0){
        let Message = UILabel(frame: CGRect(x: 20, y: self.frame.size.height / 2, width: self.frame.size.width - 40, height: 50))
        Message.clipsToBounds = true
        Message.textAlignment = .center
        Message.backgroundColor = UIColor.white
        Message.numberOfLines = 0
        if let message = message {
            Message.text = message
            Message.font = UIFont.systemFont(ofSize: 25)
        }
        Message.textColor = UIColor.gray
        Message.sizeToFit()
        self.backgroundView = Message
    }
}

extension UIAlertController {
    func show() {
        present(animated: true, completion: nil)
    }
    func present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(rootVC, animated: animated, completion: completion)
        }
    }
    fileprivate func presentFromController(_ controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if  let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
                presentFromController(visibleVC, animated: animated, completion: completion)
        } else
            if  let tabVC = controller as? UITabBarController,
                let selectedVC = tabVC.selectedViewController {
                    presentFromController(selectedVC, animated: animated, completion: completion)
            } else {
                controller.present(self, animated: animated, completion: completion)
        }
    }
}

extension UIWindow {
    static var isLandscape: Bool {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows
                .first?
                .windowScene?
                .interfaceOrientation
                .isLandscape ?? false
        } else {
            return UIApplication.shared.statusBarOrientation.isLandscape
        }
    }
}

