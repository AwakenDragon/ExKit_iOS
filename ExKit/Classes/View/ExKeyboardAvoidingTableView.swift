//
//  ExKeyboardAvoidingTableView.swift
//  ExKit
//
//  Created by 周玉震 on 2021/11/16.
//

import UIKit

open class ExKeyboardAvoidingTableView: UITableView {
    
    override public var frame: CGRect {
        willSet {
            super.frame = frame
        }
        didSet {
            guard !hasAutomaticKeyboardAvoidingBehaviour else { return }
            ExKeyboardAvoiding_updateContentInset()
        }
    }
    
    override public var contentSize: CGSize {
        willSet(newValue) {
            guard !hasAutomaticKeyboardAvoidingBehaviour else {
                super.contentSize = newValue
                return
            }
            
            guard !newValue.equalTo(self.contentSize) else { return }
            
            super.contentSize = newValue
            self.ExKeyboardAvoiding_updateContentInset()
        }
    }
    
    var hasAutomaticKeyboardAvoidingBehaviour: Bool {
        if #available(iOS 8.3, *), self.delegate is UITableViewController {
            return true
        }
        return false
    }
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        guard !hasAutomaticKeyboardAvoidingBehaviour else { return }
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard !hasAutomaticKeyboardAvoidingBehaviour else { return }
        self.setup()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        guard !hasAutomaticKeyboardAvoidingBehaviour else { return }
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
        self.ExKeyboardAvoiding_findFirstResponderBeneathView(self)?.resignFirstResponder()
        super.touchesEnded(touches, with: event)
    }
}
