//
//  ScrollerImageViewCell.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 28/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

class ScrollingImageCell: UICollectionViewCell {
    fileprivate var imageView: UIImageView!
    private var scrollView: UIScrollView!
    private var tapGesture: UITapGestureRecognizer!
    
    var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            setNeedsLayout()
        }
    }
    var topInset: CGFloat = 0 {
        didSet {
            centerIfNeeded()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scrollView = UIScrollView(frame: bounds)
        imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        scrollView.maximumZoomScale = 3
        scrollView.delegate = self
        scrollView.contentMode = .center
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(with:)))
        tapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(tapGesture)
    }
    
    func zoomRect(for scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = imageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func doubleTapped(with gestureRecognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRect(for: scrollView.maximumZoomScale,
                                         center: gestureRecognizer.location(in: gestureRecognizer.view)),
                            animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        let size: CGSize
        if let image = imageView.image {
            size = CGSize(width: bounds.width, height: bounds.width * image.size.height / image.size.width )
        } else {
            size = CGSize(width: bounds.width, height: bounds.width)
        }
        imageView.frame = CGRect(origin: .zero, size: size)
        scrollView.contentSize = size
        centerIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.setZoomScale(1, animated: false)
    }
    
    func centerIfNeeded() {
        var inset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        if scrollView.contentSize.height < scrollView.bounds.height - topInset {
            let insetV = (scrollView.bounds.height - topInset - scrollView.contentSize.height) / 2
            inset.top += insetV
            inset.bottom = insetV
        }
        if scrollView.contentSize.width < scrollView.bounds.width {
            let insetV = (scrollView.bounds.width - scrollView.contentSize.width) / 2
            inset.left = insetV
            inset.right = insetV
        }
        scrollView.contentInset = inset
    }
}

extension ScrollingImageCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerIfNeeded()
    }
}
