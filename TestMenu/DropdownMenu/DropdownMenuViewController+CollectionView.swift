//
//  DropdownMenuViewController+CollectionView.swift
//  TestMenu
//
//  Created by Shannon Wu on 12/20/15.
//  Copyright © 2015 Shannon's Dreamland. All rights reserved.
//

import UIKit

// MARK: DropdownMenu + CollectionViewSectionHeaderDelegate

extension DropdownMenuViewController: DropdownCollectionViewSectionHeaderDelegate {
    func toggleSectionContentHiddenState(state: Bool) {
        menuManager?.toggleOpenState(state)
    }
}

// MARK: DropdownMenu + UICollectionViewDelegate

extension DropdownMenuViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let indexPaths = collectionView.indexPathsForSelectedItems() {
            for oldIndexPath in indexPaths {
                if oldIndexPath.section == indexPath.section && oldIndexPath.row != indexPath.row {
                    collectionView.deselectItemAtIndexPath(oldIndexPath, animated: true)
                }
            }
        }
        
        if indexPath.section == 0 {
            menuManager?.didSelectSubmenuAtIndex(DropdownSubmenuIndex(mainSubmenuIndex: indexPath.row, secondarySubmenuIndex: nil))
        }
        else if indexPath.section == 1 {
            menuManager?.didSelectSubmenuAtIndex(DropdownSubmenuIndex(mainSubmenuIndex: nil, secondarySubmenuIndex: indexPath.row))
        }
    }
}

// MARK: DropdownMenu + UICollectionViewDataSource

extension DropdownMenuViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return menuManager?.numberOfSectionsInSubmenu(true) ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuManager?.numberOfRowsInSection(section, isMainSubmenu: true) ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(DropdownMenuConfiguration.cellIdentifier, forIndexPath: indexPath) as? DropdownCollectionViewCell {
            if indexPath.section == 0 {
                cell.titleLabel.text = menuManager?.titleForDropdownSubmenuIndex(DropdownSubmenuIndex(mainSubmenuIndex: indexPath.row, secondarySubmenuIndex: nil))
            } else {
                cell.titleLabel.text = menuManager?.titleForDropdownSubmenuIndex(DropdownSubmenuIndex(mainSubmenuIndex: nil, secondarySubmenuIndex: indexPath.row))
            }
            return cell
        } else {
            assertionFailure("初始化 Collection View Cell 失败")
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            if let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: DropdownMenuConfiguration.headerIdentifier, forIndexPath: indexPath) as? DropdownCollectionViewSectionHeader {
                header.titleLabel.text = menuManager?.titleForSectionInSubmenu(indexPath.section)
                
                if indexPath.section == 0 {
                    collectionViewHeaders = []
                }
                collectionViewHeaders.append(header)

                return header
            }
        }
        else if kind == UICollectionElementKindSectionFooter {
            if indexPath.section == 0 {
                if let footer = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: DropdownMenuConfiguration.decorationFooterIdentifier, forIndexPath: indexPath) as? DropdownCollectionViewSectionDecorationFooter {
                    return footer
                }
            }
            else if indexPath.section == 1 {
                if let footer = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: DropdownMenuConfiguration.doneFooterIdentifier, forIndexPath: indexPath) as? DropdownCollectionViewSectionDoneFooter {
                    footer.delegate = self
                    return footer
                }
            }
        }
        assertionFailure("初始化 Collection View Footer 或者 Header 失败")
        return UICollectionReusableView()
    }
    
    func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
        if elementKind == UICollectionElementKindSectionHeader {
            let itemCount = collectionView.numberOfItemsInSection(indexPath.section)
            if let shrinkItemCount = menuManager?.shrinkStateItemCount {
                toggleExpendButtonState(itemCount < shrinkItemCount ? true : false, atSection: indexPath.section)
            }
        }
    }
}

// MARK: DropdownMenu + DropdownCollectionViewSectionDoneFooterDelegate

extension DropdownMenuViewController: DropdownCollectionViewSectionDoneFooterDelegate {
    func submenuSelectionFinished() {
        animateHideSubmenu()
    }
}

// MARK: DropdownMenu + UICollectionViewDelegateFlowLayout

extension DropdownMenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return DropdownMenuConfiguration.collectionViewSubmenuFirstSectionSize
        }
        else if section == 1 {
            return DropdownMenuConfiguration.collectionViewSubmenuSecondSectionSize
        }
        assertionFailure("不应该请求到这个地方")
        return CGSize.zero
    }
}

// MARK: DropdownMenu + Header
extension DropdownMenuViewController {
    func toggleExpendButtonState(state: Bool, atSection section: Int) {
        guard section < collectionViewHeaders.count || section > 0 else {
            assertionFailure("请求不太合法")
            return
        }
        
        let header = collectionViewHeaders[section]
        header.expandButton.hidden = state
    }
}
