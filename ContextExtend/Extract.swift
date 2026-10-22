
import PDFKit
import Foundation

func extractText(from url: URL) -> String? {
    
    switch url.pathExtension {
        
    case "pdf":
        
        guard let document = PDFDocument(url: url) else {
            return nil
        }
        
        return (0..<document.pageCount)
            .compactMap { document.page(at: $0)?.string }
            .joined(separator: "\n\n")

    default:
        return try? String(contentsOf: url, encoding: .utf8)
        
    }
}
