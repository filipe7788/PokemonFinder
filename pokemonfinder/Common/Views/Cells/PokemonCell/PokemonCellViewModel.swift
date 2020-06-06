import Foundation

class PokemonCellViewModel: ViewModel {
    var pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
}
