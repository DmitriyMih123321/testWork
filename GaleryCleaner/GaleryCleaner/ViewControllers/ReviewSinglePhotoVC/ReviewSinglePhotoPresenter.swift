//
//  ReviewSinglePhotoPresenter.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 19.04.2025.
//

import Foundation

class ReviewSinglePhotoPresenter {
    fileprivate let reviewService: ReviewSinglePhotoService
    weak fileprivate var reviewView: ReviewSinglePhotoProtocol?
    
    init(reviewService: ReviewSinglePhotoService){
        self.reviewService = reviewService
    }

    func attachView(_ attach: Bool, view: ReviewSinglePhotoProtocol?) {
        if attach {
            reviewView = nil
        } else {
            if let view = view { reviewView = view }
        }
    }
    func getReviewView(){
//        reviewService.setPath(path: <#T##String#>)
        reviewView?.setupView()
        reviewView?.setupImage(reviewService.getPath())
    }
    
}
