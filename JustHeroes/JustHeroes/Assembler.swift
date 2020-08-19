import Foundation

class Assembler {
    
    static let shared = Assembler()
    
    func resolveCardListViewController_Test() -> CardListViewController {
        let section1 = CardCollectionSection(
            items: [
                CardCollectionItem(),
                CardCollectionItem(),
                CardCollectionItem(),
                CardCollectionItem(),
                CardCollectionItem()
            ]
        )
        
        let section2 = CardCollectionSection(
            items: [
                CardCollectionItem()
            ]
        )
        
        return CardListViewController(dataSource: .init(sections: [section1, section2]))
    }
    
}
