//
//  PageViewController.swift
//  TicTacToe
//
//  Created by Necanow on 7/6/18.
//  Copyright © 2018 Gaby Ecanow. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.addNewVC(viewController: "tttVC"),
                self.addNewVC(viewController: "mainVC"),
                self.addNewVC(viewController: "cfVC")]
    }()
    
    var dateLabel : UILabel!
    var settingsToolbar : UIView!
    var mainButton : UIButton!
    
    let shortFriSwitch = UISwitch()
    let extendedSwitch = UISwitch()
    
    var dayList : [UIButton]!
    var dayListCenters : [CGPoint]!
    var currentDay : UIButton!
    
    //===============//
    // VIEW DID LOAD //
    //===============//
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        // This sets up the first view that will show up on our page control
        setViewControllers([orderedViewControllers[1]],
                               direction: .forward,
                               animated: true,
                               completion: nil)
    }
    
    //--------------------------------------------------
    // Is used to add new view controllers to page
    //--------------------------------------------------
    func addNewVC(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    //--------------------------------------------------
    // Delegate function - scrolls backwards
    //--------------------------------------------------
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        guard orderedViewControllers.count > previousIndex else { return nil }
        
        return orderedViewControllers[previousIndex]
    }
    
    //--------------------------------------------------
    // Delegate function - scrolls forwards
    //--------------------------------------------------
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else { return nil }
        guard orderedViewControllersCount > nextIndex else { return nil }
        
        return orderedViewControllers[nextIndex]
    }
    
}
