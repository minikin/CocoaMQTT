//
//  CocoaMQTTMessage.swift
//  CocoaMQTT
//
//  Created by Feng Lee<feng@eqmtt.io> on 14/8/3.
//  Copyright (c) 2015 emqtt.io. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: Any]

/**
 * MQTT Message
 */
open class CocoaMQTTMessage: NSObject {
    open var qos = CocoaMQTTQOS.qos1
    var dup = false

    open var topic: String
    open var payload: [UInt8]
    open var retained = false
    
    // utf8 bytes array to string
    public var string: String? {
        get {
            return NSString(bytes: payload, length: payload.count, encoding: String.Encoding.utf8.rawValue) as String?
        }
    }
  
    // utf8 bytes array to JSONDictionary
    public var toJSON: JSONDictionary? {
      get {
        guard let json = try? JSONSerialization.jsonObject(with: Data(payload), options: [.mutableContainers, .allowFragments]) as? JSONDictionary else {
          return nil
        }
        return json
      }
    }
  
    public init(topic: String, string: String, qos: CocoaMQTTQOS = .qos1, retained: Bool = false, dup: Bool = false) {
        self.topic = topic
        self.payload = [UInt8](string.utf8)
        self.qos = qos
        self.retained = retained
        self.dup = dup
    }

    public init(topic: String, payload: [UInt8], qos: CocoaMQTTQOS = .qos1, retained: Bool = false, dup: Bool = false) {
        self.topic = topic
        self.payload = payload
        self.qos = qos
        self.retained = retained
        self.dup = dup
    }
  
    public init?(topic: String, json: JSONDictionary, qos: CocoaMQTTQOS = .qos1, retained: Bool = false, dup: Bool = false) {
      guard let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
        return nil
      }
      self.topic = topic
      self.payload = [UInt8](data)
      self.qos = qos
      self.retained = retained
      self.dup = dup
    }
}

/**
 * MQTT Will Message
 */
open class CocoaMQTTWill: CocoaMQTTMessage {
    public init(topic: String, message: String) {
        super.init(topic: topic, payload: message.bytesWithLength)
    }
}
