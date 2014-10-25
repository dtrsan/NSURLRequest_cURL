//
//  NSURLRequest+cURL.swift
//
//  Created by Domagoj Tršan on 25/10/14.
//  Copyright (c) 2014 Domagoj Tršan. All rights reserved.
//  Licence: The MIT License (MIT)
//

import Foundation

extension NSURLRequest {

    /**
     *  Returns a cURL command for a request.
     *
     *  @return A String object that contains cURL command or nil if an URL is
     *  not properly initalized.
     */
    func cURL() -> String? {

        if let length = self.URL.absoluteString?.utf16Count {
            if (length == 0) {
                return nil
            }
        } else {
            return nil
        }

        let curlCommand = NSMutableString()
        curlCommand.appendString("curl")

        // append URL
        curlCommand.appendFormat(" '%@'", self.URL.absoluteString!)

        // append method if different from GET
        if("GET" != self.HTTPMethod) {
            curlCommand.appendFormat(" -X %@", self.HTTPMethod!)
        }

        // append headers
        let allHeadersFields = self.allHTTPHeaderFields as? [String: String]
        let allHeadersKeys = allHTTPHeaderFields?.keys.array as [String]
        let sortedHeadersKeys  = allHeadersKeys.sorted { $0 < $1 }
        for key in sortedHeadersKeys {
            curlCommand.appendFormat(" -H '%@: %@'",
                                      key, self.valueForHTTPHeaderField(key)!)
        }

        // append HTTP body
        let httpBody = self.HTTPBody
        if httpBody?.length > 0 {
            let httpBody = NSString(data: self.HTTPBody!,
                                    encoding: NSUTF8StringEncoding)
            let escapedHttpBody =
              NSURLRequest.escapeAllSingleQuotes(httpBody!)
            curlCommand.appendFormat(" --data '%@'", escapedHttpBody)
        }

        return String(curlCommand)
    }

    /**
     *  Escapes all single quotes for shell from a given string.
     *
     *  @param value The value to escape.
     *
     *  @return An escaped value.
     */
    class func escapeAllSingleQuotes(value: String) -> String {
        return
          value.stringByReplacingOccurrencesOfString("'", withString: "'\\''")
    }
}
