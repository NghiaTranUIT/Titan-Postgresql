//
//  TableListDatabaseController.swift
//  Titan_macOS
//
//  Created by Nghia Tran on 4/19/17.
//  Copyright © 2017 nghiatran. All rights reserved.
//

import Cocoa
import TitanCore
import RxSwift
import SwiftyPostgreSQL

class TableListDatabaseController: BaseViewController {

    //
    // MARK: - OUTLET
    @IBOutlet weak var tableView: TitanTableView!
    
    
    //
    // MARK: - Variable
    fileprivate var viewModel: TableListViewModel!
    fileprivate var dataSource: TableListDatabaseSource!
    fileprivate var isSelectedAuto = false
    
    //
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initCommon()
        self.initDataSource()
        self.initViewModel()
        self.binding()
    }
    
}

//
// MARK: - Private
extension TableListDatabaseController {
    
    fileprivate func initCommon() {
        
    }
    
    fileprivate func initDataSource() {
        self.dataSource = TableListDatabaseSource(tableView: self.tableView)
        self.dataSource.delegate = self
        self.dataSource.menuDelegate = self
    }
    
    fileprivate func initViewModel() {
        self.viewModel = TableListViewModel()
    }
    
    fileprivate func binding() {
        
        
        // Reload
        self.viewModel.output.tablesVariable.asObservable()
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: {[weak self] (tables) in
            guard let `self` = self else {return}
            Logger.info("Table schema = \(tables.count)")
            self.tableView.reloadData()
        })
        .addDisposableTo(self.disposeBase)
        
        
        // Select auto from StackView
        self.viewModel.output.selectedTableDriver.drive(onNext: {[weak self] (selectedTable) in
            guard let `self` = self else {return}
            guard let selectedTable = selectedTable else {return}
            
            // Selected row manually
            for (i, table) in self.viewModel.output.tablesVariable.value.enumerated() {
                if table === selectedTable {
                    let index = IndexSet(integer: i)
                    
                    // Don't trigger selection delegation if select auto from view model
                    self.isSelectedAuto = true
                    self.tableView.selectRowIndexes(index, byExtendingSelection: false)
                    self.isSelectedAuto = false
                    break
                }
            }
            
        }).addDisposableTo(self.disposeBase)
    
        // Fetch scheme
        self.viewModel.input.fetchTableSchemaPublisher.onNext()
        
    }
}

//
// MARK: - BaseTableViewDataSourceProtocol
extension TableListDatabaseController: BaseTableViewDataSourceProtocol{
    
    func CommonDataSourceNumberOfItem(at section: Int) -> Int {
        return self.viewModel.output.tablesVariable.value.count
    }
    
    // Number of section
    func CommonDataSourceNumberOfSection() -> Int {
        return 1
    }
    
    // Item at index path
    func CommonDataSourceItem(at indexPath: IndexPath) -> Any {
        return self.viewModel.output.tablesVariable.value[indexPath.item]
    }
    
    // Height for row
    func CommonDataSourceHeight(for row: Int) -> CGFloat {
        return 26.0
    }
    
    // didSelect
    func CommonDataSourceDidSelectedRow(at indexPath: IndexPath) {
        // Prevent trigger if select cell automatic from Model
        // Not from User
        guard self.isSelectedAuto == false else {return}
        self.viewModel.input.selectedTablePublisher.onNext(indexPath)
    }
}

extension TableListDatabaseController: TableListDatabaseSourceDelegate {
    
    func shouldOpenTableInNewTab(_ table: Table) {
        self.viewModel.input.openTableInNewTabPublisher.onNext(table)
    }
}
