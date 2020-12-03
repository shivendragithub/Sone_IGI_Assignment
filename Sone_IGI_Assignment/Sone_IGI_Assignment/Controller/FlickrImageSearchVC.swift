//
//  FlickrImageSearchVC.swift
//  Medtrail_assignment
//
//  Created by shivendra pandey on 3/12/20.
//  Copyright © 2020 shivendra pandey. All rights reserved.
//

import UIKit
import Kingfisher


private let reuseIdentifier = "ImageCVCell"
let footerViewReuseIdentifier = "CustomFooterView"

class FlickrImageSearchVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    var httpUtility = HttpUtility()
    @IBOutlet weak var collectionView: UICollectionView!
    let itemsPerRow: CGFloat = 3
    var widthPerItem : CGFloat = 0.0
    var photo = [Photo]()
    var pagination     = Pagination()
    var searchController: UISearchController!
    var footerView:CustomFooterView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        self.collectionView.register(UINib(nibName: footerViewReuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
        setCellSize()
        self.collectionView.reloadData()
    }
}

// MARK: - collectionViewDataSource 
extension FlickrImageSearchVC : UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        setCollectionViewBackground()
        return photo.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)  as! ImageCVCell
        let photoData = photo[indexPath.row]
        let imageStr = Constants.photo_url + "/"  + photoData.server + "/" + photoData.id + "_" + photoData.secret + ".jpg"
        guard let image_url = URL(string:imageStr) else {return cell}
        cell.imageView.kf.setImage(with: image_url, placeholder: UIImage(named:Constants.placeholderImg))
        return cell
    }
    //for Pagination Setup
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photo.count - 1 {
            searchController.searchBar.isLoading = true
            self.fetchDataFromFlickrAPI()
        }
    }
    // MARK: search bar delegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
        searchController.searchBar.isLoading = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.isLoading = true
        pagination.resetPagination()
        fetchDataFromFlickrAPI()
    }
    
}

extension FlickrImageSearchVC {
    func URL_forImageSearch(forPageNo pageNo : String) -> URL? {
        var urlComponent = URLComponents()
        urlComponent.scheme = url_component.scheme
        urlComponent.host = url_component.host
        urlComponent.path = url_component.path
        urlComponent.queryItems = [
            URLQueryItem(name: QI_FlickrImageSearch.method, value: QI_FlickrImageSearch.methodValue),
            URLQueryItem(name: QI_FlickrImageSearch.api_key, value: Constants.api_key),
            URLQueryItem(name: QI_FlickrImageSearch.tags, value: self.searchController.searchBar.text),
            URLQueryItem(name: QI_FlickrImageSearch.format, value: "json"),
            URLQueryItem(name: QI_FlickrImageSearch.nojsoncallback, value: "1"),
            URLQueryItem(name: QI_FlickrImageSearch.page, value: pageNo),
        ]
        return urlComponent.url
    }
    
    func fetchDataFromFlickrAPI(){
        func reloadData(){
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.searchController.searchBar.isLoading = false
            }
        }
        guard self.pagination.has_more() else { return }
        guard (self.searchController.searchBar.text != nil) && self.searchController.searchBar.text?.count != 0 else {return}
        var pageNo = "1"
        if self.pagination.has_more() {
            pageNo    = String(self.pagination.current_page + 1)
        }
        guard let url = URL_forImageSearch(forPageNo: pageNo) else{return}
        httpUtility.performRequest(requestUrl: url, methodType: .get, requestBody: nil, resultType: ResponceDataModel.self) { (responceData,isSuccess)  in
            if (!isSuccess){
                reloadData()
                return
            }
            guard let responceDataModel = responceData else {return}
            self.pagination.current_page = self.pagination.current_page + 1
            self.pagination.total_page_count = responceDataModel.photos.pages
            self.pagination.item_in_page = responceDataModel.photos.perpage
            if self.pagination.is_refreshing {
                self.photo =  responceDataModel.photos.photo
                self.pagination.is_refreshing = false
            }else{
                self.photo.append(contentsOf: responceDataModel.photos.photo)
            }
            reloadData()
        }
    }
}
