//
//  ExKeyboardAvoidingCollectionView.swift
//  ExKit
//
//  Created by 周玉震 on 2021/11/16.
//

import UIKit

open class ExKeyboardAvoidingCollectionView: UICollectionView {
    
    override public var frame: CGRect {
        willSet {
            super.frame = frame
        }
        didSet {
            self.ExKeyboardAvoiding_updateContentInset()
        }
    }
    
    override public var contentSize: CGSize {
        willSet(newValue) {
            guard !newValue.equalTo(self.contentSize) else { return }
            super.contentSize = newValue
            self.ExKeyboardAvoiding_updateContentInset()
        }
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(ExKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
        self.perform(#selector(ExKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), with: self, afterDelay: 0.1)
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard newSuperview != nil else { return }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(ExKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.ExKeyboardAvoiding_findFirstResponderBeneathView(self)?.resignFirstResponder()
    }
}
