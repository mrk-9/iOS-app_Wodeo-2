//
//  WodeoProducts.swift
//  Wodeo 2
//
//  Created by Gareth Long on 28/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import Foundation

// Use enum as a simple namespace.  (It has no cases so you can't instantiate it.)
public enum WodeoProducts {
    
    /// TODO:  Change this to whatever you set on iTunes connect
    private static let Prefix = "co.uk.ballisticstash.wodeo2."
    
    /// MARK: - Supported Product Identifiers
    public static let moreVideo = Prefix + "exvideo"
    
    
    // All of the products assembled into a set of product identifiers.
    private static let productIdentifiers: Set<ProductIdentifier> = [WodeoProducts.moreVideo]
    
    
    /// Static instance of IAPHelper that for rage products.
    public static let store = IAPHelper(productIdentifiers: WodeoProducts.productIdentifiers)
}

/// Return the resourcename for the product identifier.
func resourceNameForProductIdentifier(productIdentifier: String) -> String? {
    return productIdentifier.componentsSeparatedByString(".").last
}
