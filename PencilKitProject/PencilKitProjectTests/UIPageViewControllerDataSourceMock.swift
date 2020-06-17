//
//  UIPageViewControllerDataSourceMock.swift
//  PencilKitProjectTests
//
//  Created by gustavo.quenca on 17/06/20.
//  Copyright © 2020 gustavo.quenca. All rights reserved.
//

import XCTest
import PencilKitProject

final class UIPageViewControllerDataSourceMock: NSObject, UIPageViewControllerDataSource {
    
    private(set) var hasCalledViewControllerBefore = false
    private(set) var hasCalledViewControllerAfter = false
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        hasCalledViewControllerBefore = true
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        hasCalledViewControllerAfter = true
        return nil
    }
}
