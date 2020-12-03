//
//  FlickrImageSearchVCExtension.swift
//  Medtrail_Assignment
//
//  Created by shivendra pandey on 3/12/20.
//  Copyright © 2020 shivendra pandey. All rights reserved.
//

import Foundation
import UIKit


// MARK: UI Setup
extension FlickrImageSearchVC : UISearchControllerDelegate, UISearchBarDelegate{
    func setCellSize(){
        func calculateWidth() -> CGFloat {
            if (UIWindow.isLandscape) {
                return UIScreen.main.bounds.size.height
            } else {
                return UIScreen.main.bounds.size.width
            }
        }
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let availableWidth = calculateWidth()
            widthPerItem = availableWidth / itemsPerRow
            flowLayout.itemSize = CGSize(width: widthPerItem, height: widthPerItem)
            flowLayout.minimumLineSpacing = 0.0
            flowLayout.minimumInteritemSpacing = 0.0
        }
    }
    func setCollectionViewBackground(){
        if (self.searchController.searchBar.text == nil) || self.searchController.searchBar.text?.count == 0 {
            collectionView.setBackGround(Constants.UserMessage.SearchForFmages)
        } else if photo.count == 0 {
            collectionView.setBackGround(Constants.UserMessage.NoImagesFound)
        }else{
            collectionView.setBackGround("")
        }
    }
    func setupSearchController(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for images"
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Search for images"
        navigationController!.navigationBar.sizeToFit()
    }
    
}
// MARK: - collectionViewDelegates CollectionViewFlowLayoutDelegate
extension FlickrImageSearchVC{
    //for orientation
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let collectionViewWidth = collectionView.frame.size.width
        if (UIWindow.isLandscape) {
            let mergin = (collectionViewWidth.truncatingRemainder(dividingBy: widthPerItem)) / 2
            return UIEdgeInsets(top: 0.0,left: mergin,bottom: 0.0,right: mergin)
        } else {
            return UIEdgeInsets(top: 0.0,left: 0.0,bottom: 0.0,right: 0.0)
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else{return}
        flowLayout.invalidateLayout()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! CustomFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.refreshControlIndicator.startAnimating()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.refreshControlIndicator.stopAnimating()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.pagination.has_more() && photo.count != 0 {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }else{
            return CGSize.zero
        }
    }
}
