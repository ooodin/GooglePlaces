//
//  CollectionViewController.swift
//  GooglePlaces
//
//  Created by Artem Semavin on 07/08/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    //MARK: - Properties
    
    var refresher: UIRefreshControl?
    let location = Location()
    let dataSource = SourceDataManagerImp()
    
    var pageToken: String?
    var places: [PlaceModel] = []
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        refresher.tintColor = UIColor.white
        refresher.addTarget(self, action: #selector(pullAndRefresh), for: .valueChanged)
        self.collectionView!.addSubview(refresher)
        self.refresher = refresher
        
        location.delegate = self
        
        readPlacesAndUpdateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        location.requestPermissions()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stroboard = UIStoryboard(name: "Detail", bundle: nil)
       
        if let controller = stroboard.instantiateInitialViewController()  as? DetailViewController {
            controller.place = places[indexPath.item]
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
}

extension CollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer", for: indexPath)
        
        view.isHidden = places.count > 0
        return view
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as! CollectionViewCell
        let place = places[indexPath.item]
   
        cell.place = place
        
        getImage(cell: cell)
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0 && pageToken != nil {
            updateData()
        }
    }
    
}

extension CollectionViewController: LocationDelegate {
    
    //MARK: Fetch data
    
    func pullAndRefresh() {
        self.pageToken = nil
        updateData()
    }
    
    func readPlacesAndUpdateUI(){
    
        dataSource.readObjects(type: PlaceModel.self) { [weak self] places in
            self?.places.append(contentsOf: places)
            self?.collectionView?.reloadData()
        }
    }
    
    func updateData() {
        
        if let pageToken = pageToken {
            self.pageToken = nil
            Network.nextPage(pageToken: pageToken, completion: { [weak self] (places, token) in
                
                self?.places.append(contentsOf: places)
                self?.collectionView?.reloadData()
                
                self?.dataSource.addObjects(places)
                self?.pageToken = token
            })
            return
        }
        
        if let coordinates = location.currentLocation {
            self.pageToken = nil
            Network.firstPage(latitude: coordinates.latitude, longitude: coordinates.longitude) { [weak self] (places, token) in
                self?.refresher?.endRefreshing()
                
                self?.places.append(contentsOf: places)
                self?.collectionView?.reloadData()
                
                self?.dataSource.addObjects(places)
                self?.pageToken = token
            }
        }
        
    }
    
    func getImage(cell: CollectionViewCell) {
        if let ref = cell.place?.photos.first?.ref {
            Network.photo(reference: ref) { image in
                cell.setImage(image: image)
            }
        } else {
            cell.setImage(image: nil)
        }
    }
    
}
