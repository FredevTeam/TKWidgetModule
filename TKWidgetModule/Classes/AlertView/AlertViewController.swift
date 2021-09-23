//
//  AlertProtocol.swift
//  TKWidgetModule
//
//  Created by tao on 2021/8/4.
//

import UIKit


open class AlertViewController: UIViewController {
    private var alertAnimation = AlertAnimation.init()
    private var alertTransitioningDelegate:AlertTransitioningDelegate
    
    
    ///  view size
    /// default width  = screen.width / 2
    /// default height  = screen.height / 2
    public var size: CGSize = CGSize.init(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2) {
        didSet {
            alertAnimation.size = size
        }
    }
    
    /// popup back view background color
    public var popupBackgroundColor: UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2) {
        didSet {
            alertAnimation.popupBackgroundColor = popupBackgroundColor
        }
    }
    
    /// corner
    public var corner: UIRectCorner = UIRectCorner.init() {
        didSet {
            alertAnimation.corner = corner
        }
    }
    
    /// corner radius
    public var cornerRadius: CGFloat = 0 {
        didSet {
            alertAnimation.cornerRadius = cornerRadius
        }
    }
    
    /// animate duration
    public var duration: TimeInterval = 0.15 {
        didSet {
            alertAnimation.duration = duration
        }
    }
    
    
    ///  show mode status , present mode  is not work
    public internal(set) var statusType: ViewControllerStatus = .normal
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.alertTransitioningDelegate = AlertTransitioningDelegate.init(alertAnimation)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.transitioningDelegate = self.alertTransitioningDelegate
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        debugPrint("AlertViewController")
    }
}

extension AlertViewController : ShowViewControllerProtocl {
    
}


extension AlertViewController {

    public override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.white
    }
    public override var transitioningDelegate: UIViewControllerTransitioningDelegate? {
        didSet {
            if transitioningDelegate?.isEqual(self.alertTransitioningDelegate) ?? false {
                return
            }
            transitioningDelegate = self.alertTransitioningDelegate
        }
    }
    public override var modalPresentationStyle: UIModalPresentationStyle {
        didSet {
            if modalPresentationStyle != .custom {
                modalPresentationStyle = .custom
            }
        }
    }
}
