
import PDFKit
import Foundation

func extractPDFText(from url: URL) -> String? {
    guard let document = PDFDocument(url: url) else {
        return nil
    }

    return (0..<document.pageCount)
        .compactMap { document.page(at: $0)?.string }
        .joined(separator: "\n\n")
}
