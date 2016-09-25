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
        if let url = self.URL {
            let length = url.absoluteString.utf16.count
            if (length == 0) {
                return nil
            }

            let curlCommand = NSMutableString()
            curlCommand.appendString("curl")

            // append URL
            curlCommand.appendFormat(" '%@'", url)

            // append method if different from GET
            if("GET" != self.HTTPMethod) {
                curlCommand.appendFormat(" -X %@", self.HTTPMethod!)
            }

            // append headers
            if let allHTTPHeaderFields = self.allHTTPHeaderFields {
                let allHeadersKeys = Array(allHTTPHeaderFields.keys)
                let sortedHeadersKeys  = allHeadersKeys.sort()
                for key in sortedHeadersKeys {
                    curlCommand.appendFormat(" -H '%@: %@'",
                                             key, self.valueForHTTPHeaderField(key)!)
                }
            }

            // append HTTP body
            if let httpBody = self.HTTPBody where httpBody.length > 0 {
                if let body = NSString(data: httpBody,
                                       encoding: NSUTF8StringEncoding) {
                    let escapedHttpBody =
                        NSURLRequest.escapeAllSingleQuotes(String(body))
                    curlCommand.appendFormat(" --data '%@'", escapedHttpBody)
                }

            }

            return String(curlCommand)
        }

        return nil
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
