//
//  DetailBookmarkDelegate.swift
//  Go Ask A Duck
//
//  Created by Cynthia on 18/02/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import Foundation

protocol DetailBookmarkDelegate: class {
    func bookmarkPassedURL(url: String) -> Void
    //    func hideFavoriteIcon() -> Void
}
