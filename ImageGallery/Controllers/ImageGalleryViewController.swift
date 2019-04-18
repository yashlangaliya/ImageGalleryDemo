//
//  ImageGalleryViewController.swift
//  ImageGallery
//
//  Created by STL009 on 14/04/19.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa


class ImageGalleryViewController: UIViewController {
    let reuseIdentifier = "ImageCell"
    let searchController = UISearchController(searchResultsController: nil)
    let provider = ImagesProvider()
    let disposeBag = DisposeBag()
    let refreshController = UIRefreshControl()
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageProviderCallBacks()
        setupSearchBar()
        provider.getImagesFor(tag: "Kitten")
    }
    
    func setupImageProviderCallBacks() {
        provider.startLoading = showLoading
        provider.startNextPageLoading = showNextPageLoading
        provider.newDataAvailable = reloadImageList
        provider.noNewImages = allImagesFatched
        provider.errorHandler = showErrorAlert
    }
    
    func showLoading() {
        ProgressHUD.showProgressHUDOn(view: self.view)
    }
    
    func showNextPageLoading() {
        ProgressHUD.showProgressHUDOn(view: self.view)
    }
    
    func hideLoading() {
        ProgressHUD.hideProgressHUD()
    }
    
    func reloadImageList() {
        hideLoading()
        DispatchQueue.main.async { [weak self] in
            self?.imageCollectionView.reloadData()
        }
    }
    
    func showErrorAlert(message: String) {
        hideLoading()
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func allImagesFatched() {
        ProgressHUD.showToastHUDOn(view: self.view, test: "Thats all folks!")
    }
    
    func setupSearchBar() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Image"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.searchBar
            .rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [unowned self] key in
                self.provider.getImagesFor(tag: key)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowImageSegue",
            let indexPath = sender as? IndexPath,
        let imageViewController = segue.destination as? ImageViewController {
            imageViewController.imageURL = provider.getLargeImageUrlFor(index: indexPath.row)
            imageViewController.title = provider.currentTag
        }
    }
    

}

extension ImageGalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return provider.imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageCell else { return }
        cell.cellImageView.sd_setImage(with: provider.getThumbnailUrlFor(index: indexPath.row), placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageCell else { return }
        cell.cellImageView.sd_cancelCurrentImageLoad()
    }
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowImageSegue", sender: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 2 
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.last?.row == provider.imageCount - 1 {
            provider.getImagesFor(tag: provider.currentTag)
        }
    }
}
