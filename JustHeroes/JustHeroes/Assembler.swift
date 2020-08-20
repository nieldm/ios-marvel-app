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
        
        let sections = [section1, section2]
        
        return CardListViewController(
            dataSource: .init(sections: sections),
            delegate: .init(sections: sections)
        )
    }
    
}
