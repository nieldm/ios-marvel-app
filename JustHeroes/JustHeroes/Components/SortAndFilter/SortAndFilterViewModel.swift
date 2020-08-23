import Foundation

protocol SortAndFilterViewModelProtocol: class {
    func showSortOptions(forItems items: [SortFilterModel])
    func hideSortOptions()
}

protocol SortAndFilterViewModelViewProtocol {
    func didTapSortOption()
}

protocol SortAndFilterViewModelOutput: class {
    func didSelectSort(byOption option: SortOptions)
}

enum SortOptions: String {
    case nameAsc = "name_asc"
    case nameDesc = "name_desc"
    case dateAsc = "date_asc"
    case dateDesc = "date_desc"
    case none
}

class SortAndFilterViewModel: SortAndFilterViewModelViewProtocol {
    
    weak var view: SortAndFilterViewModelProtocol?
    weak var output: SortAndFilterViewModelOutput?
    
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

extension SortAndFilterViewModel: CollectionViewDelegateOutput {
    typealias Item = SortFilterItem

    func didSelect(_ item: SortFilterItem) {
        let option: SortOptions = SortOptions(rawValue: item.model.value) ?? .none
        
        output?.didSelectSort(byOption: option)
        view?.hideSortOptions()
    }
}
