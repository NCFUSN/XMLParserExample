//: By Nathan Furman

import UIKit

enum xmlElements: String {
    
    case book = "book"
    case author = "author"
    case title = "title"
    case genre = "genre"
    case price = "price"
    case publish_date = "publish_date"
    case description = "description"
}

class Book: CustomDebugStringConvertible {
    
    
    var author = ""
    var title  = ""
    var genre = ""
    var price = ""
    var publishDate = ""
    var presentation = ""
    
    var debugDescription: String {
        
        return "Author: \(author), Title: \(title), Genre: \(genre), Price: \(price), Publish Date: \(publishDate), Presentation: \(presentation)"
    }
}

class BookParser: NSObject {
    
    var xmlParser: XMLParser?
    var books = [Book]()
    var xmlString = ""
    var currentBook: Book?
    
    init(xml: String) {
        if let data = xml.data(using: .utf8) {
            
            xmlParser = XMLParser(data: data)
        }
    }
    
    func parse() -> [Book] {
        
        xmlParser?.delegate = self
        xmlParser?.parse()
        return books
    }
}

extension BookParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        // reset xmlString on every iteration
        
        xmlString = ""
        if elementName == xmlElements.book.rawValue {
            currentBook = Book()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        switch elementName {
        case xmlElements.author.rawValue:
            currentBook?.author = xmlString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        case xmlElements.genre.rawValue:
            currentBook?.genre = xmlString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        case xmlElements.price.rawValue:
            currentBook?.price = xmlString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        case xmlElements.description.rawValue:
            currentBook?.presentation = xmlString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        case xmlElements.publish_date.rawValue:
            currentBook?.publishDate = xmlString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
           
        case xmlElements.book.rawValue:
            
            // the end of parse
            
            if let book = currentBook {
                
                books.append(book)
            }
            
        default:
            break
    }
  }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        xmlString += string
    }
}

do {
    
    if let xmlUrl = Bundle.main.url(forResource: "catalog", withExtension: "xml") {
        
        let xml = try String(contentsOf: xmlUrl)
        let bookParser = BookParser(xml: xml)
        let books = bookParser.parse()
        books.map() { book in
            
            print(book)
        }
    }
} catch {
    
    print(error)
}
