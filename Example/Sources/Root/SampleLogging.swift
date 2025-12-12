//
//  SampleLogging.swift
//  SDK Sample
//
//  Created by Leandro Tha on 03/03/25.
//

import LucraSDK

class SampleLogging: BaseLogging {
    required init(level: LoggingServiceLevel) {
        super.init(level: level)
    }
    
    override func info(_ message: String, category: String) {
        super.info(message, category: category)
    }
    
    override func debug(_ message: String, category: String) {
        super.debug(message, category: category)
    }
    
    override func errorBreadcrumb(_ message: String, category: String) {
        super.errorBreadcrumb(message, category: category)
    }
    
//    override func error(_ message: String, category: String, file: String, function: String, line: Int) {
//        super.error(message, category: category, file: file, function: function, line: line)
//        logException(message: message,
//                     file: file,
//                     function: function,
//                     line: line)
//    }
    
    override func set(userId: String?) {
        super.set(userId: userId)
    }
    
    private func logException(message: String, file: String, function: String, line: Int) {

        let params: [String: Any] = [ "exception_message": message,
                                      "file": file,
                                      "function": function,
                                      "line": line ]

    }
}
