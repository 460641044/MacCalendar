//
//  UrlHelper.swift
//  MacCalendar
//
//  Created by ruihelin on 2025/9/28.
//

import Foundation

struct UrlHelper{
    static func extractURL(from text: String) -> (url: URL?, remainingText: String) {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return (nil, text)
        }
        let range = NSRange(text.startIndex..., in: text)
        guard let match = detector.firstMatch(in: text, options: [], range: range),
              let matchRange = Range(match.range, in: text),
              let url = match.url else {
            return (nil, text)
        }
        var remaining = text
        remaining.removeSubrange(matchRange)
        remaining = remaining.trimmingCharacters(in: .whitespacesAndNewlines)
        remaining = remaining.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n")
        return (url, remaining)
    }

    static func normalizeURL(from url: URL) -> URL {
        if let scheme = url.scheme, scheme.lowercased() == "http" || scheme.lowercased() == "https" {
            return url
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.scheme = "https"
        
        return components?.url ?? url
    }
}

