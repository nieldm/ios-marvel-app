import Foundation

protocol SortAndFilterViewModelProtocol {
    func showSortOptions(forItems items: [SortFilterModel])
}

protocol SortAndFilterViewModelViewProtocol {
    func didTapSortOption()
}

class SortAndFilterViewModel: SortAndFilterViewModelViewProtocol {
    
    var view: SortAndFilterViewModelProtocol?
    
    func didTapSortOption() {
        let items = [
            SortFilterModel(name: "Name Asc", value: "name_asc"),
            SortFilterModel(name: "Name Desc", value: "name_desc"),
            SortFilterModel(name: "Date Asc", value: "date_asc"),
            SortFilterModel(name: "Date Desc", value: "date_desc")
        ]
        
        view?.showSortOptions(forItems: items)
    }
    
}
