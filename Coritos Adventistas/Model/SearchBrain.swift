//
//  SearchBrain.swift
//  Coritos Adventistas
//
//  Created by Jose Pimentel on 5/18/20.
//  Copyright © 2020 Jose Pimentel. All rights reserved.
//

import Foundation

struct SearchBrain {
    
    var coritos = CoritosBrain()
    var searchCoritos = [Coritos]()
    var searchResults: [Int] = []
    
    var searchCoritosFavoritos = [Coritos]()
    var searchResultsFavoritos: [Int] = []
    
    mutating func search(searchType: String)   {
        
        var i = 0
        var e = 0
        
        while i < coritos.coritos.count {
            
            if(coritos.coritos[i].title.lowercased().contains(searchType.lowercased()))  {
                
                searchCoritos.append(Coritos(title: coritos.coritos[i].title, coritos: coritos.coritos[i].coritos, coritoUrl: coritos.coritos[i].coritoUrl))
                
                searchResults.append(1)
                searchResults[e] = i
                
                e += 1
            }
            
            i += 1
        }
    }
    
    func getCoritos() -> [Coritos] {
        
        return searchCoritos
    }
    
    func getIndex() -> [Int] {
        
        return searchResults
    }
    
    
    
//  <--------------------------------Favoritos Search-------------------------------->
    
    
    mutating func searchFavorito(searchType: String, coritoFavoritos: [Coritos])   {
        
        var i = 0
        var e = 0
        
        while i < coritoFavoritos.count {
            
            if(coritoFavoritos[i].title.lowercased().contains(searchType.lowercased()))  {
                
                searchCoritosFavoritos.append(Coritos(title: coritoFavoritos[i].title, coritos: coritoFavoritos[i].coritos, coritoUrl: coritoFavoritos[i].coritoUrl))
                
                searchResultsFavoritos.append(1)
                searchResultsFavoritos[e] = i
                
                e += 1
            }
            
            i += 1
        }
    }
    
    func getCoritosFavoritos() -> [Coritos] {
        
        return searchCoritosFavoritos
    }
    
    func getIndexFavoritos() -> [Int] {
        
        return searchResultsFavoritos
    }
}
