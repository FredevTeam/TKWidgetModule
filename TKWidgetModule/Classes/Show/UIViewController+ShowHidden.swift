//
//  UIViewController+ShowHidden.swift
//  TKWidgetModule
//
//  Created by tao on 2021/8/4.
//

import UIKit


public enum ViewControllerStatus: Int {
    case normal
    case showing
}


protocol ShowViewControllerProtocl {
    var statusType: ViewControllerStatus { get set }
}


extension UIViewController {
    
    /// hidden view Controller
    /// - Parameters:
    ///   - flag: animated status
    ///   - completion: completion description
    public func hidden( animated flag: Bool, completion: (() -> Void)? = nil) {
        ShowAndHiddenAuxiliary.instance.hidden(flag ? 0.25 : 0) { to in
            var toVC = to
            if let nav = toVC as? UINavigationController {
                toVC = nav.viewControllers.first
            }
            
            if let alert = toVC as? AlertViewController {
                to?.view.frame = CGRect.init(x: (UIScreen.main.bounds.size.width - alert.view.frame.size.width ) / 2,
                                               y: UIScreen.main.bounds.size.height,
                                               width: alert.view.frame.size.width,
                                               height: alert.view.frame.size.height)
            }
            else if let popup = toVC as? PopupViewController {
                switch popup.orientationForPresentation() {
                case .portrait:
                    to?.view.frame = CGRect.init(x: 0,
                                                   y: UIScreen.main.bounds.size.height,
                                                   width: popup.view.frame.size.width,
                                                   height: popup.view.frame.size.height)
                    break
                case .landscape:
                    switch popup.direction {
                    case .portrait:
                        break
                    case .landscapeLeft:
                        to?.view.frame = CGRect.init(x: -UIScreen.main.bounds.size.width - popup.view.frame.size.width,
                                                       y: 0,
                                                       width: popup.view.frame.size.width,
                                                       height: popup.view.frame.size.height)
                        break
                    case .landscapeRight:
                        to?.view.frame = CGRect.init(x: UIScreen.main.bounds.size.width + popup.view.frame.size.width,
                                                       y: 0,
                                                       width: popup.view.frame.size.width,
                                                       height: popup.view.frame.size.height)
                        break
                    }
                    break
                }
            }else {
                to?.view.frame = CGRect.init(x: 0, y: -(toVC?.view.frame.size.height ?? 0), width: toVC?.view.frame.size.width ?? 0, height: toVC?.view.frame.size.height ?? 0)
            }
            
            if var showingVC = toVC as? ShowViewControllerProtocl {
                showingVC.statusType = .normal
            }
            
        } completion: { finished in
            ShowAndHiddenAuxiliary.instance.reset()
            completion?()
        }
    }
}


extension UIViewController {
    
    /// show view controller
    /// - Parameters:
    ///   - viewControllerToShow: to view controller
    ///   - action: back isUserInteractionEnabled status , default true , will hidden  view controller
    ///   - flag: animated
    ///   - completion: completion description
    public func show(_ viewControllerToShow: UIViewController,back action: Bool = true, animated flag: Bool, completion: (() -> Void)? = nil) {
        var toViewController: UIViewController? = viewControllerToShow
        if let nav = toViewController as? UINavigationController {
            toViewController = nav.viewControllers.first
        }
        
        var backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        var corner = UIRectCorner.init()
        var cornerRadius:CGFloat = 0
        var size = CGSize.zero
        let canAction = action
        let orientation = self.orientationForPresentation()
        var direction: PopupAnimationDirectionType = .portrait
        
        if let alert = toViewController as? AlertViewController {
            alert.view.layoutIfNeeded()
            backgroundColor = alert.popupBackgroundColor
            corner = alert.corner
            cornerRadius = alert.cornerRadius
            size = alert.size
            viewControllerToShow.view.frame = CGRect.init(x: (UIScreen.main.bounds.size.width - size.width ) / 2,
                                                          y: UIScreen.main.bounds.size.height,
                                                          width: size.width,
                                                          height: size.height)
        }
        
        else if let popup =  toViewController as? PopupViewController {
            popup.view.layoutIfNeeded()
            backgroundColor = popup.popBackgroundColor
            corner = popup.corner
            cornerRadius = popup.cornerRadius
            direction = popup.direction
            
            switch orientation {
            case .portrait:
                let height = popup.visibleValue < 1 ? UIScreen.main.bounds.height * popup.visibleValue : popup.visibleValue
                size = CGSize.init(width: UIScreen.main.bounds.size.width, height: height)
                viewControllerToShow.view.frame = CGRect.init(x: 0,
                                                              y: UIScreen.main.bounds.size.height,
                                                              width: size.width,
                                                              height: size.height)
                break
            case .landscape:
                let width = popup.visibleValue < 1 ? UIScreen.main.bounds.size.width * popup.visibleValue : popup.visibleValue
                size = CGSize.init(width: width, height: UIScreen.main.bounds.size.height )
                
                switch direction {
                case .portrait:
                    break
                case .landscapeLeft:
                    viewControllerToShow.view.frame = CGRect.init(x: -UIScreen.main.bounds.size.width - size.width,
                                                                  y: 0,
                                                                  width: size.width,
                                                                  height: size.height)
                    break
                case .landscapeRight:
                    viewControllerToShow.view.frame = CGRect.init(x: UIScreen.main.bounds.size.width + size.width,
                                                                  y: 0,
                                                                  width: size.width,
                                                                  height: size.height)
                    break
                }
                break
            }
            
        }else {
            // TODO: 普通的view
            size = viewControllerToShow.view.frame.size
            switch orientation {
            case .landscape:
                viewControllerToShow.view.frame = CGRect.init(x: (UIScreen.main.bounds.size.width - size.width ) / 2, y: UIScreen.main.bounds.size.height, width:  size.width, height:  size.height)
                break
            case .portrait:
                viewControllerToShow.view.frame = CGRect.init(x: (UIScreen.main.bounds.size.width - size.width ) / 2, y: UIScreen.main.bounds.size.height, width: size.width, height:  size.height)
                break
            }
        }
        
        
        viewControllerToShow.view.alpha = 0
        let mask = CAShapeLayer.init()
        mask.path = UIBezierPath.init(roundedRect: viewControllerToShow.view.bounds,
                                      byRoundingCorners: corner,
                                      cornerRadii: CGSize.init(width: cornerRadius, height: cornerRadius)).cgPath
        viewControllerToShow.view.layer.mask = mask
        
        ShowAndHiddenAuxiliary.instance.config(self, to: viewControllerToShow, backButton: canAction, backgroundColor: backgroundColor)
        ShowAndHiddenAuxiliary.instance.show(flag ? 0.25 : 0) {
            viewControllerToShow.view.alpha = 1
            
            if let _ = toViewController as? PopupViewController {
                switch orientation {
                case .portrait:
                    viewControllerToShow.view.frame = CGRect.init(x: 0,
                                                                  y: UIScreen.main.bounds.size.height - size.height,
                                                                  width: size.width,
                                                                  height: size.height)
                    break
                case .landscape:
                    switch direction {
                    case .portrait:
                        break
                    case .landscapeLeft:
                        viewControllerToShow.view.frame = CGRect.init(x: 0,
                                                                      y: 0,
                                                                      width: size.width,
                                                                      height: size.height)
                        break
                    case .landscapeRight:
                        viewControllerToShow.view.frame = CGRect.init(x: UIScreen.main.bounds.size.width - size.width,
                                                                      y: 0,
                                                                      width: size.width,
                                                                      height: size.height)
                        break
                    }
                    break
                }
                
            }else if let _ = toViewController as? AlertViewController {
                viewControllerToShow.view.frame  = CGRect.init(x: (UIScreen.main.bounds.size.width - size.width ) / 2,
                                                               y: (UIScreen.main.bounds.size.height - size.height ) / 2,
                                                               width: size.width,
                                                               height: size.height)
            }else {
                    viewControllerToShow.view.frame = CGRect.init(x: 0,
                                                                  y: 0,
                                                                  width: size.width,
                                                                  height: size.height)
            }
            
            if var showVC = toViewController as? ShowViewControllerProtocl {
                showVC.statusType = .showing
            }
            
        } completion: { finished in
            completion?()
        }
    }
    
}


extension UIViewController {
    func orientationForPresentation() -> InterfaceOrientation {
        let presentation = self.preferredInterfaceOrientationForPresentation
        switch presentation {
        case .unknown:
            fallthrough
        case .portrait:
            fallthrough
        case .portraitUpsideDown:
            return .portrait
        case .landscapeLeft:
            fallthrough
        case .landscapeRight:
            return .landscape
        }
    }
}


extension UIViewController {
    
    /// hidden , when showing view controller, and present view controller will pop , need hidden sub view Controller,.
    ///
    ///  func viewWillDisappear(_ animated: Bool) {
    ///      super.viewWillDisappear(animated)
    ///      hiddenSubViewControllers()
    ///  }
    public func hiddenSubViewControllers() {
        for viewController in self.children {
            if let nav = viewController as? UINavigationController {
                hidden(nav.viewControllers.first, navigation: nav)
            }else {
                hidden(viewController, navigation: nil)
            }
        }
    }
    
    private func hidden(_ viewController: UIViewController?, navigation: UINavigationController?) {
        guard let viewController = viewController else {
            return
        }
        if let showViewController = viewController as? ShowViewControllerProtocl {
            switch showViewController.statusType {
            case .normal:
                break
            case .showing:
                if let nav = navigation {
                    nav.hidden(animated: true, completion: nil)
                    break
                }
                viewController.hidden(animated: true, completion: nil)
            }
        }
    }
    
}
