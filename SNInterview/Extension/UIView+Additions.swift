//
//  UIView+Additions.swift
//  SNInterview
//
//  Copyright © 2019 ServiceNow. All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib() -> UIView {
        let bundle = Bundle(for: self)
        let name = String(describing: self)
        guard let objects = bundle.loadNibNamed(name, owner: self, options: nil) as? [UIView],
            let loadedView = objects.last else {
                fatalError("View doesn't exist")
        }
        
        return loadedView
    }
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        let bundle = Bundle(for: type(of: self))
        let name = String(describing: type(of: self))
        guard let contentView = bundle.loadNibNamed(name, owner: self, options: nil)?.first as? T else {
                return nil
        }
        return contentView
    }
    
    func fixSubview(_ subview: UIView!) -> Void{
        subview.translatesAutoresizingMaskIntoConstraints = false;
        subview.frame = self.frame;
        self.addSubview(subview);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: subview, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: subview, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: subview, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: subview, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
