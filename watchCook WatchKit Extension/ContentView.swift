//
//  ContentView.swift
//  watchCook WatchKit Extension
//
//  Created by 김재성 on 2022/01/30.
//

import SwiftUI

func loadJson<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

struct ContentView: View {
    
    @State private var recipes: [Recipe] = loadJson("recipeData.json")
//    @State private var recipes: [Recipe] = [Recipe]()
    @State private var text: String = ""
    
    func getDocumentDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return path[0]
    }
    
    func load() {
        DispatchQueue.main.async {
            do {
                if (recipes.isEmpty) {
                    let url = getDocumentDirectory().appendingPathComponent("recipes")
                    
                    let data = try Data(contentsOf: url)

                    recipes = try JSONDecoder().decode([Recipe].self, from: data)
                }
            } catch {
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<recipes.count, id: \.self) { i in
                    NavigationLink {
                        RecipeDetail(recipe: recipes[i])
                    } label: {
                        RecipeRow(text: recipes[i].title)
                    }
                }
            }
            .navigationTitle("레시피 목록")
            .onAppear(perform: {
                load()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
