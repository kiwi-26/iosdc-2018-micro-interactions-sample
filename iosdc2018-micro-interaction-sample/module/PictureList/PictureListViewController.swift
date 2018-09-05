//
//  PictureListViewController.swift
//  iosdc2018-micro-interaction-sample
//
//  Created by kiwi on 2018/08/19.
//  Copyright © 2018年 kiwi26. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PictureListViewController: UIViewController {
    
    // 遷移方法（モーダル/プッシュ）
    let transitionMode = TransitionMode.push
    
    let model: PictureListModel = PictureListModel()
    private var collectionView: UICollectionView!
    private var selectingPicture: UIImageView?
    
    // pushViewController するときはこちらを使う
    let transition = ImageApplyTransitionAnimator()

    // present(viewController) するときはこちらを使う
    let presentTransition = ImageApplyModalTransitionAnimator()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "ホーム"
        
        var collectionViewFrame = self.view.frame
        collectionViewFrame.size.width = self.view.frame.size.width - 16
        collectionViewFrame.origin.x = 8

        let layout = UICollectionViewFlowLayout()
        
        // 2列
        let itemWidth = (collectionViewFrame.size.width - 10) / 2
        // 1列
//        let itemWidth = collectionViewFrame.size.width

        // アイテムサイズ
        let itemHeight = 44 + itemWidth + 44
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)

        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: "PictureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(collectionView)
        
        // UINavigationController のデリゲートにselfを指定（push時に利用）
        navigationController?.delegate = self
        
        // popされて戻ってきたら実行
        transition.dismissCompletion = {
            self.selectingPicture?.isHidden = false
            self.selectingPicture?.alpha = 1.0
            self.selectingPicture = nil
        }

        // dismissされて戻ってきたら実行
        presentTransition.dismissCompletion = {
            self.selectingPicture?.isHidden = false
            self.selectingPicture?.alpha = 1.0
            self.selectingPicture = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: UICollectionViewDataSource
extension PictureListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PictureCollectionViewCell
        
        guard let item = model.picture(at: indexPath) else {
            return cell
        }

        cell.listItem = item
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension PictureListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PictureCollectionViewCell, let item = model.picture(at: indexPath) else {
            return
        }
        
        let detail = PictureDetailViewController(nibName: "PictureDetailViewController", bundle: nil)
        detail.pictureItem = item
        selectingPicture = cell.pictureImage

        switch transitionMode {
        case .modal:
            detail.transitioningDelegate = self
            navigationController?.present(detail, animated: true, completion: nil)
        case .push:
            navigationController?.pushViewController(detail, animated: true)
        }
    }
}

// モーダル表示の場合（detailViewController.transitionDelegate）
extension PictureListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let selecting = selectingPicture {
            presentTransition.originFrame = selecting.superview!.convert(selecting.frame, to: nil)
        }
        presentTransition.presenting = true
        return presentTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentTransition.presenting = false
        return presentTransition
    }
}

// プッシュ表示の場合（navigationController.delegate）
extension PictureListViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            transition.operation = operation
            
            if let selecting = selectingPicture, operation == UINavigationControllerOperation.push {
                transition.originFrame = selecting.superview!.convert(selecting.frame, to: nil)
                transition.presentingImageView = selecting
                selecting.alpha = 0.0
            }
            
            return transition
    }
}

enum TransitionMode {
    case modal
    case push
}
