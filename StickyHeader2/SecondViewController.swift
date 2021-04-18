//
//  ContentViewController1.swift
//  StickeyHeaderiOS
//
//  Created by Sowndharya M on 06/01/18.
//  Copyright © 2018 Sowndharya M. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
        
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate?
        
    private var dragDirection: DragDirection = .Up
    private var oldContentOffset = CGPoint.zero
        
    var numberOfCells: Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
        
    func setupTableView() {
        
        tableView.register(UINib(nibName: TabTableViewCellID, bundle: nil),
                           forCellReuseIdentifier: TabTableViewCellID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        
    }
}


extension SecondViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: TabTableViewCellID) as? TabTableViewCell {
            
            cell.cellLabel.text = "This is cell \(30 - indexPath.row)"
            return cell
        }
        
        return UITableViewCell()
    }
}

extension SecondViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        
        let delta = scrollView.contentOffset.y - oldContentOffset.y
                
        let topViewCurrentHeightConst = innerTableViewScrollDelegate?.currentHeaderHeight
        
        if let topViewUnwrappedHeight = topViewCurrentHeightConst {
            
            if delta > 0,
                topViewUnwrappedHeight > topViewHeightConstraintRange.lowerBound,
                scrollView.contentOffset.y > 0 {
                

                dragDirection = .Up
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
            
            
            if delta < 0,
                 topViewUnwrappedHeight < topViewHeightConstraintRange.upperBound,
                scrollView.contentOffset.y < 0 {
                
                dragDirection = .Down
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
        }
        
        oldContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
            
            innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
            
            innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            
            innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
    }
}
