//
//  StackTableViewModel.swift
//  TitanCore
//
//  Created by Nghia Tran on 4/25/17.
//  Copyright © 2017 nghiatran. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyPostgreSQL

public protocol StackTableViewModelType {
    var input: StackTableViewModelInput {get}
    var output: StackTableViewModelOutput {get}
}

public protocol StackTableViewModelInput {
    
}

public protocol StackTableViewModelOutput {
    var stackTableDriver: Driver<[Table]>! {get}
    var stackTableVariable: Variable<[Table]> {get}
    var selectedIndex: Int {get}
}

public class StackTableViewModel: BaseViewModel, StackTableViewModelType, StackTableViewModelInput, StackTableViewModelOutput {
    
    //
    // MARK: - Type
    public var input: StackTableViewModelInput {return self}
    public var output: StackTableViewModelOutput {return self}
    
    //
    // MARK: - Input
    
    //
    // MARK: - Output
    public var stackTableDriver: Driver<[Table]>!
    public var stackTableVariable: Variable<[Table]> { return MainStore.globalStore.detailDatabaseStore.stackTables }
    public var selectedIndex: Int {return MainStore.globalStore.detailDatabaseStore.selectedIndexStackView}
    
    //
    // MARK: - Init
    override public init() {
        super.init()
        
        self.binding()
    }
    
    fileprivate func binding() {
        
        // Stack table
        self.stackTableDriver = MainStore.globalStore.detailDatabaseStore.stackTables.asDriver()
        
    }
}
