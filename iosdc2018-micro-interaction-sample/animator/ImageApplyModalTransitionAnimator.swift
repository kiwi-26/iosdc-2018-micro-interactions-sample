//
//  PopAnimator.swift
//  iosdc2018-micro-interaction-sample
//
//  Created by 長谷川敬 on 2018/08/25.
//  Copyright © 2018年 kiwi26. All rights reserved.
//

import UIKit

class ImageApplyModalTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.4
    
    /// 表示するときのアニメーションならtrue, 非表示時ならfalse
    var presenting = true

    /// 一覧表示側のImageViewの位置
    /// 詳細から一覧に戻る際、同じ位置に戻すために使用
    var originFrame = CGRect.zero

    /// 表示を消すアニメーションが完了した時のクロージャ
    var dismissCompletion: (() -> Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        let listView = presenting ? fromView : toView
        let detailView = presenting ? toView : fromView

        let initialFrame = presenting ? originFrame : detailView.frame
        let finalFrame = presenting ? detailView.frame : originFrame

        let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        let yScaleFactor = presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

        if presenting {
            detailView.transform = scaleTransform
            detailView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            detailView.clipsToBounds = true
            detailView.alpha = 0.0
        }

        containerView.addSubview(toView)
        containerView.bringSubview(toFront: detailView)

        UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
            detailView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
            detailView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            detailView.alpha = self.presenting ? 1.0 : 0.0
            listView.alpha = self.presenting ? 0.0 : 1.0
        }, completion: { _ in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        })
    }
}
