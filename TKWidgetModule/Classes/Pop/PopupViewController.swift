//
//  PopupViewController.swift
//  TKWidgetModule
//
//  Created by tao on 2021/8/4.
//

import UIKit

open class PopupViewController: UIViewController {
    
    private var popupTransitioningDelegate:PopupTransitioningDelegate?
    private var animation = PopupAnimation.init()
    
    
    
    /// visible value , default 0.7 and support  size 300
    public var visibleValue: CGFloat = 0.7 {
        didSet {
            animation.visibleValue = visibleValue
        }
    }
    
    /// pop background view color
    public  var popBackgroundColor:UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2) {
        didSet {
            animation.backgroundColor = popBackgroundColor
        }
    }
    
    /// corner
    public var corner: UIRectCorner = UIRectCorner.init() {
        didSet {
                animation.corner = corner
        }
    }
    
    /// corner radius
    public  var cornerRadius:  CGFloat = 0 {
        didSet {
            animation.cornerRadius = cornerRadius
        }
    }
    
    
    /// animate direction
    public var direction: PopupAnimationDirectionType = .landscapeRight  {
        didSet {
            animation.direction = direction
        }
    }
    
    /// show mode status. present mode is not work
    public internal(set) var statusType: ViewControllerStatus = .normal 
    
    /// infect navigation controller , defualt false 
    public var infectNavigationController: Bool = false {
        didSet {
            if infectNavigationController , let nav = self.navigationController {
                nav.transitioningDelegate = self.transitioningDelegate
                nav.modalPresentationStyle = .custom
            }
        }
    }
    
    
    /// animate duration
    public var duration: TimeInterval = 0.15 {
        didSet {
            animation.duration = duration
        }
    }
    
    
    
    
    open override var transitioningDelegate: UIViewControllerTransitioningDelegate? {
        didSet {
            if transitioningDelegate?.isEqual(self.popupTransitioningDelegate) ?? false {
                return
            }
            transitioningDelegate = self.popupTransitioningDelegate
        }
    }
    open override var modalPresentationStyle: UIModalPresentationStyle {
        didSet {
            if modalPresentationStyle !=  .custom {
                modalPresentationStyle = .custom
            }
        }
    }



    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        popupTransitioningDelegate = PopupTransitioningDelegate.init(animation, viewController: self)
        self.transitioningDelegate = popupTransitioningDelegate
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("PopupViewController")
    }
}

extension PopupViewController {
    open override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
    }
}

extension PopupViewController : ShowViewControllerProtocl {
    
}



class PopupTransitioningDelegate: NSObject {
    private var animation:PopupAnimation
    private weak var viewController: PopupViewController?
    init(_ animation: PopupAnimation, viewController: PopupViewController) {
        self.animation = animation
        self.viewController = viewController
    }
}

extension PopupTransitioningDelegate:UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (viewController?.infectNavigationController ?? false), let _ = viewController?.navigationController {
            viewController?.navigationController?.transitioningDelegate = viewController?.transitioningDelegate
            viewController?.navigationController?.modalPresentationStyle = .custom
        }
        return animation
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animation
    }
}
