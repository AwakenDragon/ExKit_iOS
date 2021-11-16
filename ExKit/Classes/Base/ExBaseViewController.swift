//
//  ExBaseViewController.swift
//  ExKit
//
//  Created by ZhouYuzhen on 2020/11/8.
//

import UIKit
import Jelly
import FDFullscreenPopGesture

public protocol ExStoryboardLoadable {
    static var storyboardBundle: Bundle? { get }
    static var storyboardName: String { get }
    static var storyboardIdentifier: String? { get }
}

public extension ExStoryboardLoadable {
    static var storyboardBundle: Bundle? { return nil}
    static var storyboardIdentifier: String? { return nil }
    static func loadFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)
        if let storyboardIdentifier =  storyboardIdentifier {
            return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
        } else {
            return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! Self
        }
    }
}

public enum ExViewControllerAnimation {
    case Push
    case Modal
    case Fade
}

public struct ExIntent {
    var to: ExBaseViewController!
    var finish: Bool = false
}

open class ExBaseViewController: UIViewController {
    
    public var statusBarHeight: CGFloat {
        get {
            UIApplication.shared.statusBarFrame.height
        }
    }
    
    public var navBarHeight: CGFloat {
        get {
            self.navigationController?.navigationBar.height ?? 0
        }
    }
    
    public var offsetY: CGFloat {
        get {
            self.statusBarHeight + self.navBarHeight
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: 回调参数
    open func onResponse(_ successful: Bool, message: String?, data: Any) {
        
    }
    
    
    // MARK: 页面跳转
    open func push(to controller: UIViewController?, finish: Bool = false) {
        if let vc = controller {
            self.navigationController?.pushViewController(vc)
            if finish, let count = self.navigationController?.viewControllers.count {
                self.navigationController?.viewControllers.remove(at: count - 2)
            }
        }
    }
    
    open func present(to controller: UIViewController?) {
        if let vc = controller {
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    open func dialog(to controller: UIViewController?, presentation: Presentation) {
        if let vc = controller {
            let animator = Animator(presentation: presentation)
            animator.prepare(presentedViewController: vc)
            present(vc, animated: true, completion: nil)
        }
    }
    
    open func bottomDialog(to controller: UIViewController?, size: PresentationSize = PresentationSize(width: .fullscreen, height: .halfscreen)) {
        let presentation = CoverPresentation(
            directionShow: .bottom,
            directionDismiss: .bottom,
            uiConfiguration: PresentationUIConfiguration(
                cornerRadius: 6,
                backgroundStyle: .dimmed(alpha: 0.5),
                isTapBackgroundToDismissEnabled: true,
                corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner]),
            size: size,
            alignment: PresentationAlignment(vertical: .bottom, horizontal: .center))
        self.dialog(to: controller, presentation: presentation)
    }
    
    open func centerDialog(to controller: UIViewController?, size: PresentationSize = PresentationSize(width: .fullscreen, height: .halfscreen)) {
        let presentation = FadePresentation(size: size,ui: PresentationUIConfiguration(cornerRadius: 8, backgroundStyle: .dimmed(alpha: 0.5), isTapBackgroundToDismissEnabled: true, corners: [.layerMaxXMaxYCorner,.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]))
        self.dialog(to: controller, presentation: presentation)
    }
    
    open func dismss(_ root: Bool = false) {
        if let nav = self.navigationController, nav.viewControllers.first != self {
            if root {
                nav.popToRootViewController(animated: true)
            } else {
                nav.popViewController(animated: true)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
