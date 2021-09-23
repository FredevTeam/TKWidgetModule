//
//  PopupBackButtonAuxiliary.swift
//  LookinServer
//
//  Created by tao on 2021/8/4.
//

import Foundation


class PopupBackButtonAuxiliary {
    static let instance = PopupBackButtonAuxiliary.init()
    private init() {
        
    }
    
    private var transitionContext: UIViewControllerContextTransitioning?
    private var backAllAction: Bool = true
}

extension PopupBackButtonAuxiliary {
    func config(_ transitionContext: UIViewControllerContextTransitioning, backAllAction: Bool) {
        self.transitionContext = transitionContext
        self.backAllAction = backAllAction
    }
}

extension PopupBackButtonAuxiliary {
    @objc func backButtonAction(_ sender: UIButton) {
        guard let context = transitionContext, let to = context.viewController(forKey: .to) else {
            return
        }
        
        if backAllAction {
            to.dismiss(animated: true) {
                
            }
        }
        
    }
}
