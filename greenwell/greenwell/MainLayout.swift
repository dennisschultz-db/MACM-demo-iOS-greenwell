//
//  MainLayout.swift
//  greenwell
//
//  Created by Dennis Schultz on 1/21/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

protocol MainLayoutDelegate {
    // Returns the height of the item at the given index path.
    func collectionView(collectionView:UICollectionView, heightForItemAtIndexPath indexPath:NSIndexPath,
        withWidth:CGFloat) -> CGFloat
}


class MainLayout: UICollectionViewLayout {

    // Maintain link to delegate
    var delegate: MainLayoutDelegate!
    
    // Fixed number of columns and cellPadding
    var numberOfColumns = 2
    var cellPadding: CGFloat = 6.0
    
    // Cache of calculated attributes.  Populated by perpareLayout()
    private var cache = Dictionary<String, UICollectionViewLayoutAttributes>()
    
    // Total content height - calculated by prepareLayout()
    private var contentHeight: CGFloat = 0.0
    // Total content widht - calculated by subtracting insets from the collection view width
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    
    
    // Builds a cache of layout attributes of all the objects on the screen
    override func prepareLayout() {

        // Since Offers and Articles are constantly changing, just rebuild from scratch each time.
        cache.removeAll()
        
        // Column widths are equal
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        
        // Calculate the horizontal offset of all columns
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append( CGFloat(column) * columnWidth )
        }
        
        // Vertical offset will be constructed as we go
        var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
        
        let width = columnWidth - cellPadding * 2
        
        // ==== Section 0 =====
        var column = 0
        var section = 0
        // Section 0 Header
        var indexPath = NSIndexPath(forItem: 0, inSection: section)
        var attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: indexPath)
        // Header is full width, 50 px tall
        var height = CGFloat(50)
        var frame = CGRect(x: xOffset[column], y: yOffset[column], width: self.collectionView!.frame.size.width, height: height)
        var insetFrame = CGRectInset(frame, cellPadding, cellPadding)
        attributes.frame = insetFrame
        cache[layoutKeyForHeaderAtIndexPath(indexPath)] = attributes
 
        contentHeight = max(contentHeight, CGRectGetMaxY(frame))

        // This section header needs to bump all columns down since it is full width
        for thisColumn in 0 ..< numberOfColumns {
            yOffset[thisColumn] = yOffset[thisColumn] + height
        }
        
        
        // Section 0 Accounts
        indexPath = NSIndexPath(forItem: 0, inSection: section)
        
        height = delegate.collectionView(collectionView!, heightForItemAtIndexPath: indexPath, withWidth: width)
        frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
        insetFrame = CGRectInset(frame, cellPadding, cellPadding)
        
        attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.frame = insetFrame
        cache[layoutKeyForIndexPath(indexPath)] = attributes
        
        contentHeight = max(contentHeight, CGRectGetMaxY(frame))
        yOffset[column] = yOffset[column] + height
        
        
        // Section 0 Operations
        column = 1
        indexPath = NSIndexPath(forItem: 1, inSection: section)
        
        height = delegate.collectionView(collectionView!, heightForItemAtIndexPath: indexPath, withWidth: width)
        frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
        insetFrame = CGRectInset(frame, cellPadding, cellPadding)
        
        attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.frame = insetFrame
        cache[layoutKeyForIndexPath(indexPath)] = attributes
        
        contentHeight = max(contentHeight, CGRectGetMaxY(frame))
        yOffset[column] = yOffset[column] + height

        
        
        // ==== Section 1 ==== Offers
        column = 0
        section = 1
        // Section 1 Header
        indexPath = NSIndexPath(forItem: 0, inSection: section)
        attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: indexPath)
        height = CGFloat(50)
        frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
        insetFrame = CGRectInset(frame, cellPadding, cellPadding)
        attributes.frame = insetFrame
        cache[layoutKeyForHeaderAtIndexPath(indexPath)] = attributes
        
        contentHeight = max(contentHeight, CGRectGetMaxY(frame))
        yOffset[column] = yOffset[column] + height
        
        // Section 1 Offers
        for item in 0 ..< AppDelegate.caas.offerings.count {
            indexPath = NSIndexPath(forItem: item, inSection: section)
            
            height = delegate.collectionView(collectionView!, heightForItemAtIndexPath: indexPath, withWidth: width)
            frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            insetFrame = CGRectInset(frame, cellPadding, cellPadding)
            
            attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attributes.frame = insetFrame
            cache[layoutKeyForIndexPath(indexPath)] = attributes
            
            contentHeight = max(contentHeight, CGRectGetMaxY(frame))
            yOffset[column] = yOffset[column] + height

        }
        

        // ==== Section 2 ==== Articles
        column = 1
        section = 2
        // Section 2 Header
        indexPath = NSIndexPath(forItem: 0, inSection: section)
        attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: indexPath)
        height = CGFloat(50)
        frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
        insetFrame = CGRectInset(frame, cellPadding, cellPadding)
        attributes.frame = insetFrame
        cache[layoutKeyForHeaderAtIndexPath(indexPath)] = attributes

        
        contentHeight = max(contentHeight, CGRectGetMaxY(frame))
        yOffset[column] = yOffset[column] + height
        
        // Articles
        for item in 0 ..< AppDelegate.caas.articles.count {
            indexPath = NSIndexPath(forItem: item, inSection: section)
            
            height = delegate.collectionView(collectionView!, heightForItemAtIndexPath: indexPath, withWidth: width)
            frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            insetFrame = CGRectInset(frame, cellPadding, cellPadding)
            
            attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attributes.frame = insetFrame
            cache[layoutKeyForIndexPath(indexPath)] = attributes
            
            contentHeight = max(contentHeight, CGRectGetMaxY(frame))
            yOffset[column] = yOffset[column] + height
            
        }
        
    }
    
    // Provides the dimentions of the entire collection view
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // Returns a list of objects within the given rectangle
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for (_, attributes) in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    // Provides layout attributes for summplementary views (headers)
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        return cache[layoutKeyForHeaderAtIndexPath(indexPath)]
        
    }
    
    // Provides layout attributes for elements
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {

        return cache[layoutKeyForIndexPath(indexPath)]
        
    }

    
    // MARK: Helpers
    
    // Creates a unique key for objects.  Used to uniquely identify
    // each item's layout attributes in the cache
    func layoutKeyForIndexPath(indexPath : NSIndexPath) -> String {
        return "\(indexPath.section)_\(indexPath.row)"
    }
    
    // Creates a unique key for supplemental objects (headers)
    func layoutKeyForHeaderAtIndexPath(indexPath : NSIndexPath) -> String {
        return "s_\(indexPath.section)_\(indexPath.row)"
    }

    
}
