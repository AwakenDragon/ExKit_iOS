//
//  ExKeyboardAvoidingScrollView.swift
//  ExKit
//
//  Created by 周玉震 on 2021/11/16.
//

import UIKit
/**
 * 参考 [TPKeyboardAvoiding](https://github.com/michaeltyson/TPKeyboardAvoiding)
 * 1. 在键盘弹出时, 保证TextField和TextView不被遮挡
 * 2. 如果有多个TextField和TextView, returnKeyType自动设置为Next, 点击后自动设置下一个TextField或TextView为第一响应；最后一个TextField或TextView的returnKeyType设置为Done
 *  - 此功能仅在UIScrollView内可用
 *  - 在UITableView和UICollectionView中，由于Cell复用机制，不知道最后一个TextField或TextView，无法设置为Done
 **/

open class ExKeyboardAvoidingScrollView: UIScrollView {
    
    override public var frame: CGRect {
        didSet {
            self.ExKeyboardAvoiding_updateContentInset()
        }
    }
    
    override public var contentSize: CGSize {
        didSet {
            self.ExKeyboardAvoiding_updateFromContentSizeChange()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    func contentSizeToFit() {
        self.contentSize = self.ExKeyboardAvoiding_calculatedContentSizeFromSubviewFrames()
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

let kCalculatedContentPadding: CGFloat = 10
let kMinimumScrollOffsetPadding: CGFloat = 20

extension UIScrollView {
    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(ExKeyboardAvoiding_keyboardWillShow(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ExKeyboardAvoiding_keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToActiveTextField), name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToActiveTextField), name: UITextField.textDidBeginEditingNotification, object: nil)
    }
    
    @objc func ExKeyboardAvoiding_keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let rectNotification = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardRect = self.convert(rectNotification.cgRectValue, from: nil)
        guard !keyboardRect.isEmpty else { return }
        
        let state = self.state
        
        guard let firstResponder = self.ExKeyboardAvoiding_findFirstResponderBeneathView(self) else { return }
        
        state.keyboardRect = keyboardRect
        if !state.keyboardVisible {
            state.priorInset = self.contentInset
            state.priorScrollIndicatorInsets = self.scrollIndicatorInsets
            state.priorPagingEnabled = self.isPagingEnabled
        }
        
        state.keyboardVisible = true
        self.isPagingEnabled = false
        
        if self is ExKeyboardAvoidingScrollView {
            state.priorContentSize = self.contentSize
            if self.contentSize.equalTo(CGSize.zero) {
                self.contentSize = self.ExKeyboardAvoiding_calculatedContentSizeFromSubviewFrames()
            }
        }
        
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Float ?? 0.0
        let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0
        let options = UIView.AnimationOptions(rawValue: UInt(curve))
        
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: options, animations: { [weak self] in
            guard let self = self else { return }
            
            self.contentInset = self.ExKeyboardAvoiding_contentInsetForKeyboard()
            let viewableHeight = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom
            let point = CGPoint(x: self.contentOffset.x, y: self.ExKeyboardAvoiding_idealOffsetForView(firstResponder, viewAreaHeight: viewableHeight))
            self.setContentOffset(point, animated: false)
            
            self.scrollIndicatorInsets = self.contentInset
            self.layoutIfNeeded()
        })
    }
    
    @objc func ExKeyboardAvoiding_keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        guard let rectNotification = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRect = self.convert(rectNotification.cgRectValue, from: nil)
        guard !keyboardRect.isEmpty else { return }
        
        let state = self.state
        guard state.keyboardVisible else { return }
        state.keyboardRect = CGRect.zero
        state.keyboardVisible = false
        
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Float ?? 0.0
        let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0
        let options = UIView.AnimationOptions(rawValue: UInt(curve))
        
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: options, animations: { [weak self] in
            guard let self = self, self is ExKeyboardAvoidingScrollView else { return }
            
            self.contentSize = state.priorContentSize
            self.contentInset = state.priorInset
            self.scrollIndicatorInsets = state.priorScrollIndicatorInsets
            self.isPagingEnabled = state.priorPagingEnabled
            self.layoutIfNeeded()
        })
    }
    
    @objc func scrollToActiveTextField() {
        return self.ExKeyboardAvoiding_scrollToActiveTextField()
    }
    
    func ExKeyboardAvoiding_scrollToActiveTextField() {
        let state = self.state
        guard state.keyboardVisible else { return }
        
        let visibleSpace = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom
        let idealOffset = CGPoint(x: 0, y: self.ExKeyboardAvoiding_idealOffsetForView(self.ExKeyboardAvoiding_findFirstResponderBeneathView(self), viewAreaHeight: visibleSpace))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(0 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) { [weak self] in
            self?.setContentOffset(idealOffset, animated: true)
        }
    }
    
    func ExKeyboardAvoiding_findFirstResponderBeneathView(_ view: UIView) -> UIView? {
        for childView in view.subviews {
            if childView.responds(to: #selector(getter: isFirstResponder)) && childView.isFirstResponder {
                return childView
            }
            let result = ExKeyboardAvoiding_findFirstResponderBeneathView(childView)
            if result != nil {
                return result
            }
        }
        return nil
    }
    
    func ExKeyboardAvoiding_updateFromContentSizeChange() {
        let state = self.state
        if state.keyboardVisible {
            state.priorContentSize = self.contentSize
        }
    }
    
    func ExKeyboardAvoiding_updateContentInset() {
        let state = self.state
        if state.keyboardVisible {
            self.contentInset = self.ExKeyboardAvoiding_contentInsetForKeyboard()
        }
    }
    
    func ExKeyboardAvoiding_contentInsetForKeyboard() -> UIEdgeInsets {
        let state = self.state
        var newInset = self.contentInset
        
        let keyboardRect = state.keyboardRect
        newInset.bottom = keyboardRect.size.height - max(keyboardRect.maxY - self.bounds.maxY, 0)
        
        return newInset
    }
    
    // 根据subviews计算ContentSize
    internal func ExKeyboardAvoiding_calculatedContentSizeFromSubviewFrames() -> CGSize {
        let wasShowingVerticalScrollIndicator = self.showsVerticalScrollIndicator
        let wasShowingHorizontalScrollIndicator = self.showsHorizontalScrollIndicator
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        var rect = CGRect.zero
        
        for view in self.subviews {
            rect = rect.union(view.frame)
        }
        
        rect.size.height += kCalculatedContentPadding
        self.showsVerticalScrollIndicator = wasShowingVerticalScrollIndicator
        self.showsHorizontalScrollIndicator = wasShowingHorizontalScrollIndicator
        
        return rect.size
    }
    
    func ExKeyboardAvoiding_idealOffsetForView(_ view: UIView?, viewAreaHeight: CGFloat) -> CGFloat {
        let contentSize = self.contentSize
        
        var offset: CGFloat = 0.0
        let subviewRect = view != nil ? view!.convert(view!.bounds, to: self) : CGRect.zero
        
        var padding = (viewAreaHeight - subviewRect.height) / 2
        if padding < kMinimumScrollOffsetPadding {
            padding = kMinimumScrollOffsetPadding
        }
        
        offset = subviewRect.origin.y - padding - self.contentInset.top
        
        if offset > (contentSize.height - viewAreaHeight) {
            offset = contentSize.height - viewAreaHeight
        }
        
        if offset < -self.contentInset.top {
            offset = -self.contentInset.top
        }
        
        return offset
    }
}

extension UIScrollView: UITextFieldDelegate, UITextViewDelegate {
    
    @objc func ExKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_ obj: AnyObject) {
        func processWithView(_ view: UIView) {
            for childView in view.subviews {
                if childView is UITextField || childView is UITextView {
                    self.ExKeyboardAvoiding_initializeView(childView)
                } else {
                    self.ExKeyboardAvoiding_assignTextDelegateForViewsBeneathView(childView)
                }
            }
        }
        
        if let timer = obj as? Timer, let view = timer.userInfo as? UIView {
            processWithView(view)
        } else if let view = obj as? UIView {
            processWithView(view)
        }
    }
    
    func ExKeyboardAvoiding_initializeView(_ view: UIView) {
        if let textField = view as? UITextField, textField.returnKeyType == UIReturnKeyType.default &&
            textField.delegate !== self {
            textField.delegate = self
            let otherView = self.ExKeyboardAvoiding_findNextInputViewAfterView(view, beneathView: self)
            textField.returnKeyType = otherView != nil ? .next : .done
        }
    }
    
    func ExKeyboardAvoiding_findNextInputViewAfterView(_ priorView: UIView, beneathView view: UIView) -> UIView? {
        var candidate: UIView?
        self.ExKeyboardAvoiding_findNextInputViewAfterView(priorView, beneathView: view, candidateView: &candidate)
        return candidate
    }
    
    func ExKeyboardAvoiding_findNextInputViewAfterView(_ priorView: UIView, beneathView view: UIView, candidateView bestCandidate: inout UIView?) {
        let priorFrame = self.convert(priorView.frame, from: priorView.superview)
        let candidateFrame = bestCandidate == nil ? CGRect.zero : self.convert(bestCandidate!.frame, from: bestCandidate!.superview)
        
        var bestCandidateHeuristic = -sqrt(candidateFrame.origin.x * candidateFrame.origin.x + candidateFrame.origin.y * candidateFrame.origin.y) + ( Float(abs(candidateFrame.minY - priorFrame.minY)) < Float.ulpOfOne ? 1e6 : 0)
        
        for childView in view.subviews {
            if ExKeyboardAvoiding_viewIsValidKeyViewCandidate(childView) {
                let frame = self.convert(childView.frame, from: view)
                let heuristic = -sqrt(frame.origin.x * frame.origin.x + frame.origin.y * frame.origin.y)
                + (Float(abs(frame.minY - priorFrame.minY)) < Float.ulpOfOne ? 1e6 : 0)
                
                if childView != priorView && (Float(abs(frame.minY - priorFrame.minY)) < Float.ulpOfOne
                                              && frame.minX > priorFrame.minX
                                              || frame.minY > priorFrame.minY)
                    && (bestCandidate == nil || heuristic > bestCandidateHeuristic) {
                    bestCandidate = childView
                    bestCandidateHeuristic = heuristic
                }
            } else {
                self.ExKeyboardAvoiding_findNextInputViewAfterView(priorView, beneathView: childView, candidateView: &bestCandidate)
            }
        }
    }
    
    func ExKeyboardAvoiding_viewIsValidKeyViewCandidate(_ view: UIView) -> Bool {
        if view.isHidden || !view.isUserInteractionEnabled { return false}
        
        if let textField = view as? UITextField, textField.isEnabled {
            return true
        }
        
        if let textView = view as? UITextView, textView.isEditable {
            return true
        }
        
        return false
    }
    
    func ExKeyboardAvoiding_focusNextTextField() -> Bool {
        guard let firstResponder = self.ExKeyboardAvoiding_findFirstResponderBeneathView(self) else { return false }
        guard let view = self.ExKeyboardAvoiding_findNextInputViewAfterView(firstResponder, beneathView: self) else { return false }

        view.perform(#selector(becomeFirstResponder), with: nil, afterDelay: 0.1)
        
        return true
    }
    
    // MARK: UITextFieldDelegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !self.ExKeyboardAvoiding_focusNextTextField() {
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - Internal object observer
internal class ExKeyboardAvoidingState: NSObject {
    var priorInset = UIEdgeInsets.zero
    var priorScrollIndicatorInsets = UIEdgeInsets.zero
    var priorContentSize = CGSize.zero
    var priorPagingEnabled = false
    
    var keyboardVisible = false
    var keyboardRect = CGRect.zero
}

internal extension UIScrollView {
    
    fileprivate struct AssociatedKeysKeyboard {
        static var DescriptiveName = "KeyboardDescriptiveName"
    }
    
    var state: ExKeyboardAvoidingState {
        get {
            if let obj = objc_getAssociatedObject(self, &AssociatedKeysKeyboard.DescriptiveName) as? ExKeyboardAvoidingState {
                return obj
            } else {
                let obj = ExKeyboardAvoidingState()
                objc_setAssociatedObject(self, &AssociatedKeysKeyboard.DescriptiveName, obj, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return obj
            }
        }
    }
}
