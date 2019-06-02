//
//  TestModeViewController.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

protocol TestModeCoordinator {
    func showAnalytics()
}

class TestModeViewController: UIViewController {
    
    init(with coordinator: TestModeCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red:0.03, green:0.05, blue:0.2, alpha:1)
        self.modalPresentationStyle = .overCurrentContext
        self.preferredContentSize = CGSize(width: 200, height: 100)
        self.transitioningDelegate = self
        
        let export = UIButton(type: .custom)
        let analytics = UIButton(type: .custom)
        [export, analytics].forEach {
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .semibold-16
            $0.backgroundColor = #colorLiteral(red:1, green:0.23, blue:0.45, alpha:1)
        }
        
        unowned let `self` = self
        export.setTitle("Export", for: .normal)
        analytics.setTitle("Analytic", for: .normal)
        export.addAction(self.export)
        analytics.addAction(self.coordinator.showAnalytics)
        
        view.addSubviews(export, analytics)
        
        export.layout(analytics.height.width.centerY, 15.leading)
        analytics.layout(15.leading.to(export), 50.height, 15.trailing, .centerY)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Private
    private let coordinator: TestModeCoordinator
    fileprivate let blurModalPresentation = BlurModalPresentation()
    
    private func export() {
        let data = Portfolio.export()
        let file = "export.txt"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let url = dir.appendingPathComponent(file)
            try? FileManager.default.removeItem(at: url)
            do {
                try data.write(to: url)
                let share = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                present(share, animated: true, completion: nil)
            } catch {
                alert(error.localizedDescription)
            }
            
        }
    }

}

extension TestModeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return blurModalPresentation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return blurModalPresentation
    }
}
