
import Foundation

protocol ModelType: Codable {
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
}

extension ModelType {
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        return .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            let dateFormats = [
                "yyyyMMddHHmmss",
                "yyyyMMdd",
                "yyyy-MM-dd",
                "yyyy-MM-dd'T'HH:mm:ss",
                "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
            ]
            
            if let matched = dateFormats.first(where: { $0.count == dateString.count }),
               let date = DateFormatter.shared.date(from: dateString, format: matched) {
                return date
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Couldn't find a format that matches \(dateString) in the given date formats.")
            }
        }
    }
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = self.dateDecodingStrategy
        return decoder
    }
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { throw NSError() }
        print(dictionary)
        return dictionary
    }
}

extension DateFormatter {
    static var shared: DateFormatter = {
        let formatter = DateFormatter()
        let locale = Locale(identifier: "ko-Kore_KR")
        formatter.locale = locale
        return formatter
    }()
    
    func date(from string: String, format: String) -> Date? {
        dateFormat = format
        return date(from: string)
    }
}

extension Array: ModelType where Element: ModelType {}
