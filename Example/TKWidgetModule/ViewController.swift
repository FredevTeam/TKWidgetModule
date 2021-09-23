//
//  ViewController.swift
//  TKWidgetModule
//
//  Created by playtomandjerry on 08/03/2021.
//  Copyright (c) 2021 playtomandjerry. All rights reserved.
//

import UIKit
import TKWidgetModule


class ViewController: UIViewController {

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hiddenSubViewControllers()
    }

}


extension ViewController {
    
    
    @IBAction func presentAction(_ sender: Any) {
        print("\(#function)")
        self.present(PresentViewController.init(), animated: true, completion: nil)
        showAfter(5)
    }
    
    @IBAction func alertViewAction(_ sender: Any) {
        print("\(#function)")
        self.present(MTAlertViewController.init(), animated: true, completion: nil)
    }
    
    @IBAction func presentNavAction(_ sender: Any) {
        print("\(#function)")
        let presentvc = PresentViewController.init()
        let nav = UINavigationController.init(rootViewController: presentvc)
        presentvc.infectNavigationController = true
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func systemAlertAction(_ sender: Any) {
        
    }
    // 以下两种方式是错误的， 左侧(竖屏无效)
    @IBAction func leftAction(_ sender: Any) {
        print("\(#function)")
        return
        let presentvc = PresentViewController.init()
        let nav = UINavigationController.init(rootViewController: presentvc)
        presentvc.infectNavigationController = true
        // TODO: 竖屏模式下。此属性无效
        presentvc.direction =  .landscapeLeft
        self.present(nav, animated: true, completion: nil)
    }
    // 右侧(竖屏无效)
    @IBAction func rightAction(_ sender: Any) {
        print("\(#function)")
        return
        let presentvc = PresentViewController.init()
        let nav = UINavigationController.init(rootViewController: presentvc)
        presentvc.infectNavigationController = true
        // TODO: 竖屏模式下。此属性无效
        presentvc.direction =  .landscapeRight
        self.present(nav, animated: true, completion: nil)
    }
}


extension ViewController {
    
    @IBAction func showLeftActionb(_ sender: Any) {
        print("\(#function)")
        let presentvc = PresentViewController.init()
        let nav = UINavigationController.init(rootViewController: presentvc)
        presentvc.infectNavigationController = true
        presentvc.direction =  .landscapeLeft
        self.show(nav, animated: true, completion: nil)
        showAfter(5)
    }
    @IBAction func showRightAction(_ sender: Any) {
        print("\(#function)")
        let presentvc = PresentViewController.init()
        let nav = UINavigationController.init(rootViewController: presentvc)
        presentvc.infectNavigationController = true
        presentvc.direction =  .landscapeRight
        self.show(nav, animated: true, completion: nil)
        showAfter(5)
    }
    
    
    @IBAction func showAction(_ sender: Any) {
        print("\(#function)")
        self.show(PresentViewController.init(), animated: true, completion: nil)
        showAfter(5)
    }
    
    @IBAction func showNavAction(_ sender: Any) {
        print("\(#function)")
        let presentvc = PresentViewController.init()
        let nav = UINavigationController.init(rootViewController: presentvc)
        presentvc.infectNavigationController = true
        self.show(nav, animated: true, completion: nil)
        showAfter(5)
    }
    

    @IBAction func showAlertAction(_ sender: Any) {
        print("\(#function)")
        self.show(MTAlertViewController.init(), animated: true, completion: nil)
        showAfter(5)
    }
    
    
    @IBAction func showSystemAction(_ sender: Any) {
        print("\(#function)")
        self.show(ViewController.init(), animated: true)
    }
    
}


extension ViewController {
    func  showAfter(_ duration: TimeInterval)  {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            print("popViewController")
            self.navigationController?.popViewController(animated: true)
        }
    }
}
