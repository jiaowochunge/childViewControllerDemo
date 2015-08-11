//
//  ViewController.swift
//  ChildViewControllerDemo
//
//  Created by taolv on 15/8/11.
//  Copyright (c) 2015年 taolv365.ios.recycle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var container: UIScrollView!
    
    @IBOutlet weak var tab: UISegmentedControl!
    
    let tab1VC = TabViewController()
    
    let tab2VC = TabViewController()
    
    let tab3VC = TabViewController()

    var _currentTab = 0
    
    var isDragLeft = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tab1VC.index = 0
        tab2VC.index = 1
        tab3VC.index = 2
        
        self.addChildViewController(tab1VC)
        tab1VC.view.frame = container.bounds
        container.addSubview(tab1VC.view)
        tab1VC.didMoveToParentViewController(self)
        
        // 下面四个属性在storyboard中设置的。默认scrollview的contentSize小于frame时是不可拖动的
//        container.alwaysBounceHorizontal = true
//        container.showsHorizontalScrollIndicator = false
//        container.showsVerticalScrollIndicator = false
//        container.pagingEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func taptab(sender: UISegmentedControl) {
        let oldTab = _currentTab;
        
        _currentTab = sender.selectedSegmentIndex;
        
        self.replaceTabFrom(oldTab, To: _currentTab)
    }
    
    // 切换tab
    func replaceTabFrom(oldIndex : Int, To newIndex : Int) {
        let tabVC : Array<UIViewController> = [tab1VC, tab2VC, tab3VC];
        
        let oldVC = tabVC[oldIndex];
        let newVC = tabVC[newIndex];
        
        self.addChildViewController(newVC)
        var newViewFrame = container.bounds;
        if (newIndex > oldIndex) {
            newViewFrame.origin.x = CGRectGetWidth(newViewFrame);
        } else {
            newViewFrame.origin.x = -CGRectGetWidth(newViewFrame);
        }
        newVC.view.frame = newViewFrame;
        var oldViewFrame = container.bounds;
        if (newIndex > oldIndex) {
            oldViewFrame.origin.x = -CGRectGetWidth(oldViewFrame);
        } else {
            oldViewFrame.origin.x = CGRectGetWidth(oldViewFrame);
        }
        
        // 为了控制转场动画过程中不能再次触发动画
        self.tab.enabled = false
        // 根据文档描述，调用这个转场动画时，addSubview和removeFromSuperview两个函数由下面函数完成，无需显式调用
        self.transitionFromViewController(oldVC, toViewController: newVC, duration: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            newVC.view.frame = self.container.bounds;
            oldVC.view.frame = oldViewFrame;
            }) { (finished) -> Void in
                newVC.didMoveToParentViewController(self)
                oldVC.didMoveToParentViewController(nil)
                oldVC.removeFromParentViewController()
                self.tab.enabled = true
        }
    }
}


extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        http://stackoverflow.com/questions/9637203/check-direction-of-scroll-in-uiscrollview  判断拖动方向
        let translation = scrollView.panGestureRecognizer.translationInView(self.view)
        if translation.x > 0 {
            // 向右拖动
            self.dragRight()
        } else {
            // 向左拖动
            self.dragLeft()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // 没有添加其他view，无需理会
        if scrollView.contentSize.width != 2 * scrollView.bounds.size.width {
            return
        }
        // 移除掉屏幕外的view
        let page = (Int)(scrollView.contentOffset.x / scrollView.bounds.size.width);
        if isDragLeft {
            if page == 0 {
                self.removeViewAtIndex(_currentTab + 1)
            } else {
                self.removeViewAtIndex(_currentTab)
                // 修正subview frame
                let tabVC : Array<UIViewController> = [tab1VC, tab2VC, tab3VC]
                let childVC = tabVC[_currentTab + 1]
                childVC.view.frame = container.bounds
                
                ++_currentTab;
                tab.selectedSegmentIndex = _currentTab
            }
        } else {
            if page == 0 {
                self.removeViewAtIndex(_currentTab)
                --_currentTab;
                tab.selectedSegmentIndex = _currentTab
            } else {
                self.removeViewAtIndex(_currentTab - 1)
                // 修正 frame
                let tabVC : Array<UIViewController> = [tab1VC, tab2VC, tab3VC]
                let childVC = tabVC[_currentTab]
                childVC.view.frame = container.bounds
            }
        }
    }
    
    func removeViewAtIndex(index : Int) {
        let tabVC : Array<UIViewController> = [tab1VC, tab2VC, tab3VC]
        let attendRmVC = tabVC[index]
        attendRmVC.willMoveToParentViewController(nil)
        attendRmVC.view.removeFromSuperview()
        attendRmVC.removeFromParentViewController()
        attendRmVC.didMoveToParentViewController(nil)
        
        container.contentSize = container.bounds.size
    }
    
    func dragLeft() {
        // 最右边的视图向左拖，拖不出个什么
        if _currentTab == 2 {
            return;
        }
        isDragLeft = true
        
        let tabVC : Array<UIViewController> = [tab1VC, tab2VC, tab3VC]
        let attendAddVC = tabVC[_currentTab + 1]
        // 添加childViewController
        attendAddVC.willMoveToParentViewController(self)
        self.addChildViewController(attendAddVC)
        container.addSubview(attendAddVC.view)
        attendAddVC.didMoveToParentViewController(self)
        // 计算位置
        var frame = container.bounds
        frame.origin.x = frame.size.width
        attendAddVC.view.frame = frame;
        // 修改contentSize
        container.contentSize = CGSize(width: container.bounds.size.width * 2, height: container.bounds.size.height)
    }
    
    func dragRight() {
        if _currentTab == 0 {
            return;
        }
        isDragLeft = false
        
        let tabVC : Array<UIViewController> = [tab1VC, tab2VC, tab3VC]
        let attendAddVC = tabVC[_currentTab - 1]
        self.addChildViewController(attendAddVC)
        container.addSubview(attendAddVC.view)
        attendAddVC.didMoveToParentViewController(self)
        // 计算位置
        var frame = container.bounds
        attendAddVC.view.frame = frame;
        // 原本已添加在container上的view位置偏移
        frame = tabVC[_currentTab].view.frame
        frame.origin.x = frame.size.width
        tabVC[_currentTab].view.frame = frame
        // 修改contentSize
        container.contentSize = CGSize(width: container.bounds.size.width * 2, height: container.bounds.size.height)
        container.contentOffset = CGPoint(x: frame.size.width, y: 0)
    }
}