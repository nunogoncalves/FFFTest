//
//  Reusable.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable where Self : UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

protocol Dequeuable {
    func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T : Reusable
}

extension Dequeuable where Self : UICollectionView {
    func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T : Reusable {
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

extension UICollectionViewCell : Reusable {}
extension UICollectionView : Dequeuable {}
