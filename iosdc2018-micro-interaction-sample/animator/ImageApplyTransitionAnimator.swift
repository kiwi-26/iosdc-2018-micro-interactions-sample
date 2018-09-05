//
//  PopAnimator.swift
//  iosdc2018-micro-interaction-sample
//
//  Created by kiwi on 2018/08/25.
//  Copyright © 2018年 kiwi26. All rights reserved.
//

import UIKit

class ImageApplyTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.4
    
    /// プッシュかポップか
    var operation: UINavigationControllerOperation?
    
    /// 一覧表示側のImageViewの位置
    /// 詳細から一覧に戻る際、同じ位置に戻すために使用
    var originFrame = CGRect.zero

    /// 一覧側で表示している画像
    var presentingImageView: UIImageView?

    /// 表示を消すアニメーションが完了した時のDelegate
    var dismissCompletion: (() -> Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let presenting = operation == UINavigationControllerOperation.push
        
        guard let listImageView = presentingImageView else {
            transitionContext.completeTransition(true)
            return
        }
        
        // containerView, fromView, toView を取得
        let containerView = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        
        // 詳細画面側のViewを取得し、アニメーション中は非表示にする
        let detailView = presenting ? toView : fromView
        toView.alpha = 0
        
        // 詳細画面のImageViewの位置（ここでは固定）, ImageViewの初期位置と最終位置
        let detailFrame = CGRect(x: 0, y: 64, width: detailView.frame.width, height: detailView.frame.width)
        let initialFrame = presenting ? originFrame : detailFrame
        let finalFrame = presenting ? detailFrame : originFrame
        
        // 遷移中のみ表示させるImageView
        let transitionImageView = UIImageView(frame: initialFrame)
        transitionImageView.image = listImageView.image
        transitionImageView.contentMode = .scaleAspectFill
        transitionImageView.clipsToBounds = true
        
        containerView.addSubview(toView)
        containerView.addSubview(transitionImageView)
        containerView.bringSubview(toFront: transitionImageView)
        
        fromView.alpha = 0
        let animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            // 0.2秒後からEaseInOutでImageViewの位置を移動
            // 合わせて、一覧に戻る遷移の場合は一覧画面を徐々に表示
            transitionImageView.frame = finalFrame
            if !presenting {
                toView.alpha = 1
            }
        }, completion: {_ in
            // 非表示にした詳細画面を表示
            // 遷移中に表示していたimageViewを削除
            toView.alpha = 1
            fromView.alpha = 1
            if presenting {
                detailView.alpha = 1
            } else {
                self.dismissCompletion?()
            }
            transitionImageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
        animator.startAnimation()
        
        // 角丸はCABasicAnimationを使う
        let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadiusAnimation.fromValue = presenting ? 16 : 0
        cornerRadiusAnimation.toValue = presenting ? 0 : 16
        cornerRadiusAnimation.duration = duration
        cornerRadiusAnimation.fillMode = kCAFillModeBoth
        cornerRadiusAnimation.isRemovedOnCompletion = false
        transitionImageView.layer.add(cornerRadiusAnimation, forKey: nil)
    }
}
