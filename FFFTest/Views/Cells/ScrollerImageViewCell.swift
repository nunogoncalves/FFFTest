//
//  ScrollerImageViewCell.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 28/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

class ScrollingImageCell: UICollectionViewCell {
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    var dTapGR: UITapGestureRecognizer!
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
        
        dTapGR = UITapGestureRecognizer(target: self, action: #selector(doubleTap(gr:)))
        dTapGR.numberOfTapsRequired = 2
        addGestureRecognizer(dTapGR)
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = imageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func doubleTap(gr: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: gr.location(in: gr.view)), animated: true)
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
            let insetV = (scrollView.bounds.height - topInset - scrollView.contentSize.height)/2
            inset.top += insetV
            inset.bottom = insetV
        }
        if scrollView.contentSize.width < scrollView.bounds.width {
            let insetV = (scrollView.bounds.width - scrollView.contentSize.width)/2
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


//class ScrollerImageViewCell: UICollectionViewCell {
//    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var scroller: UIScrollView!
//    
//    var dTapGR: UITapGestureRecognizer!
//    var image: UIImage? {
//        get { return imageView.image }
//        set {
//            imageView.image = newValue
//            setNeedsLayout()
//        }
//    }
//    var topInset: CGFloat = 0 {
//        didSet {
//            centerIfNeeded()
//        }
//    }
//    
//    override func awakeFromNib() {
//        scroller.addSubview(imageView)
//        scroller.maximumZoomScale = 3
//        scroller.delegate = self
//        scroller.contentMode = .center
//        scroller.showsHorizontalScrollIndicator = false
//        scroller.showsVerticalScrollIndicator = false
//        addSubview(scroller)
//        
//        dTapGR = UITapGestureRecognizer(target: self, action: #selector(doubleTap(gr:)))
//        dTapGR.numberOfTapsRequired = 2
//        addGestureRecognizer(dTapGR)
//    }
//    
//    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
//        var zoomRect = CGRect.zero
//        zoomRect.size.height = imageView.frame.size.height / scale
//        zoomRect.size.width  = imageView.frame.size.width  / scale
//        let newCenter = imageView.convert(center, from: scroller)
//        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
//        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
//        return zoomRect
//    }
//    
//    func doubleTap(gr: UITapGestureRecognizer) {
//        if scroller.zoomScale == 1 {
//            scroller.zoom(to: zoomRectForScale(scale: scroller.maximumZoomScale, center: gr.location(in: gr.view)), animated: true)
//        } else {
//            scroller.setZoomScale(1, animated: true)
//        }
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        scroller.frame = bounds
//        let size: CGSize
//        if let image = imageView.image {
//            size = CGSize(width: bounds.width, height: bounds.width * image.size.height / image.size.width )
//        } else {
//            size = CGSize(width: bounds.width, height: bounds.width)
//        }
//        imageView.frame = CGRect(origin: .zero, size: size)
//        scroller.contentSize = size
//        centerIfNeeded()
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        scroller.setZoomScale(1, animated: false)
//    }
//    
//    func centerIfNeeded() {
//        var inset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
//        if scroller.contentSize.height < scroller.bounds.height - topInset {
//            let insetV = (scroller.bounds.height - topInset - scroller.contentSize.height)/2
//            inset.top += insetV
//            inset.bottom = insetV
//        }
//        if scroller.contentSize.width < scroller.bounds.width {
//            let insetV = (scroller.bounds.width - scroller.contentSize.width)/2
//            inset.left = insetV
//            inset.right = insetV
//        }
//        scroller.contentInset = inset
//    }
//}
//
//extension ScrollerImageViewCell: UIScrollViewDelegate {
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return imageView
//    }
//    
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        centerIfNeeded()
//    }
//}


//class ScrollerImageViewCell: UICollectionViewCell {
//
//    @IBOutlet weak var scroller: UIScrollView!
//    @IBOutlet weak var imageView: UIImageView!
//    
//    var topInset: CGFloat = 0 {
//        didSet {
//            centerIfNeeded()
//        }
//    }
//    
//    var doubleTapGesture: UITapGestureRecognizer!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(gestureRecognizer:)))
//        doubleTapGesture.numberOfTapsRequired = 2
//        addGestureRecognizer(doubleTapGesture)
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        scroller.setZoomScale(1, animated: false)
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        scroller.frame = bounds
//        let size: CGSize
//        if let image = imageView.image {
//            size = CGSize(width: bounds.width, height: bounds.width * image.size.height / image.size.width )
//        } else {
//            size = CGSize(width: bounds.width, height: bounds.width)
//        }
//        imageView.frame = CGRect(origin: .zero, size: size)
//        scroller.contentSize = size
//        centerIfNeeded()
//    }
//
//    func centerIfNeeded() {
//        var inset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
//        if scroller.contentSize.height < scroller.bounds.height - topInset {
//            let insetV = (scroller.bounds.height - topInset - scroller.contentSize.height)/2
//            inset.top += insetV
//            inset.bottom = insetV
//        }
//        if scroller.contentSize.width < scroller.bounds.width {
//            let insetV = (scroller.bounds.width - scroller.contentSize.width)/2
//            inset.left = insetV
//            inset.right = insetV
//        }
//        scroller.contentInset = inset
//    }
//
//    @objc private func doubleTapped(gestureRecognizer: UITapGestureRecognizer) {
//        if scroller.zoomScale == 1 {
//            scroller.zoom(to: zoomRect(for: scroller.maximumZoomScale,
//                                       center: gestureRecognizer.location(in: gestureRecognizer.view)),
//                          animated: true)
//        } else {
//            scroller.setZoomScale(1, animated: true)
//        }
//    }
//    
//    private func zoomRect(for scale: CGFloat, center: CGPoint) -> CGRect {
//        var zoomRect = CGRect.zero
//        zoomRect.size.height = imageView.frame.size.height / scale
//        zoomRect.size.width  = imageView.frame.size.width  / scale
//        let newCenter = imageView.convert(center, from: scroller)
//        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
//        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
//        return zoomRect
//    }
//}
//
//extension ScrollerImageViewCell : UIScrollViewDelegate {
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return imageView
//    }
//    
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        centerIfNeeded()
//    }
//}
