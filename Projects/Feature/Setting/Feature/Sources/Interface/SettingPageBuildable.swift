//
//  SettingPageBuildable.swift
//  Setting
//
//  Created by choijunios on 12/31/24.
//

import SharedPresentationExt

public protocol SettingPageBuildable: Buildable<SettingPageDependency> {
    
    func build(interactorListener: SettingPageViewModelListener) -> SettingPageRoutable
}
