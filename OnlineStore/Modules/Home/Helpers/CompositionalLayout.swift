//
//  CompositionalLayout.swift
//  OnlineStore
//
//  Created by Polina on 17.04.2024.
//

import UIKit

enum CompositionalGroupAlignment{
    case vertical
    case horizontal
}

struct CompositionalLayout{
    static func createItem(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, spacing: CGFloat) -> NSCollectionLayoutItem{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height))
        item.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        return item
    }
    
    static func createGroup(alignment: CompositionalGroupAlignment, width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, subitems: [NSCollectionLayoutItem]) -> NSCollectionLayoutGroup{
        switch alignment{
        case .vertical:
            return NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitems: subitems)
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitems: subitems)
        }
    }
    
    static func createSection(group: NSCollectionLayoutGroup, scrollBehavior:  UICollectionLayoutSectionOrthogonalScrollingBehavior, groupSpacing: CGFloat, leading: CGFloat, trailing: CGFloat, top: CGFloat, bottom: CGFloat, supplementary: [NSCollectionLayoutBoundarySupplementaryItem]?) -> NSCollectionLayoutSection{
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = scrollBehavior
        section.interGroupSpacing = groupSpacing
        section.contentInsets = .init(top: top, leading: leading, bottom: bottom, trailing: trailing)
        section.supplementariesFollowContentInsets = false
        section.boundarySupplementaryItems = supplementary ?? []
        return section
    }
}
