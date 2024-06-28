//
//  TutorialPageViewController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/28/24.
//

import UIKit

class TutorialPageViewController: BaseViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageViewController: UIPageViewController?
    
    let pageControl = UIPageControl.appearance().then {
        $0.pageIndicatorTintColor = UIColor(named: "fontGray")
        $0.currentPageIndicatorTintColor = UIColor(named: "pointOrange")
        $0.backgroundColor = .clear
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setTutorialPage()
    }
    
    func setTutorialPage() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        
        if let firstTutorialVC = getTutorialPageViewController(at: 0) {
            pageViewController?.setViewControllers([firstTutorialVC], direction: .forward, animated: true, completion: nil)
        }
        // PageViewController를 자식 뷰 컨트롤러로 추가
        addChild(pageViewController!)
        view.addSubview(pageViewController!.view)
        pageViewController?.didMove(toParent: self)
    }
    
    func getTutorialPageViewController(at index: Int) -> TutorialPageView? {
        guard index >= 0, index < 6 else { return nil }
        let tutorialVC = TutorialPageView(index: index)
        return tutorialVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let tutorialVC = viewController as? TutorialPageView,
              let index = tutorialVC.index, index > 0 else {
            return nil
        }
        return getTutorialPageViewController(at: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let tutorialVC = viewController as? TutorialPageView,
              let index = tutorialVC.index, index < 5 else {
            return nil
        }
        return getTutorialPageViewController(at: index + 1)
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 6
    }
}
