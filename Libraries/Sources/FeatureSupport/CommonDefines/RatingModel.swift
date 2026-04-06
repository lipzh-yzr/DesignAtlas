//
//  RatingModel.swift
//  Libraries
//
//  Created by wepie on 2026/4/5.
//

import Foundation

public struct DesignSystemRatingSurvey: Codable, Hashable, Sendable {
    public let designSystem: DesignSystem
    public var questions: [DesignSystemRatingQuestion]
    
    public init(
        designSystem: DesignSystem,
        questions: [DesignSystemRatingQuestion] = Self.defaultQuestions
    ) {
        self.designSystem = designSystem
        self.questions = questions
    }
    
    public static var defaultQuestions: [DesignSystemRatingQuestion] {
        DesignSystemRatingDimension.allCases.map { dimension in
            let isRequired = dimension == .missingComponents ? false : true
            return .init(dimension: dimension, isRequired: isRequired)
        }
    }
}

public struct DesignSystemRatingQuestion: Codable, Hashable, Sendable {
    public let dimension: DesignSystemRatingDimension
    public let isRequired: Bool
    
    public init(
        dimension: DesignSystemRatingDimension,
        isRequired: Bool = true
    ) {
        self.dimension = dimension
        self.isRequired = isRequired
    }
    
    public func accepts(_ answer: DesignSystemRatingAnswerValue?) -> Bool {
        guard isRequired != (answer == nil) else { return false }
        switch (dimension.kind, answer) {
        case let (.rating(scale), .rating(score)):
            return scale.contains(score)
        case (.openText, .openText):
            return true
        default:
            return false
        }
    }
}

public enum DesignSystemRatingDimension: String, CaseIterable, Codable, Hashable, Sendable {
    case overallImpression
    case consistency
    case aesthetics
    case componentCompleteness
    case missingComponents
    
    var kind: DesignSystemRatingQuestionKind {
        switch self {
        case .overallImpression:
            .rating(.fivePoint)
        case .consistency:
            .rating(.fivePoint)
        case .aesthetics:
            .rating(.fivePoint)
        case .componentCompleteness:
            .rating(.fivePoint)
        case .missingComponents:
                .openText(.init(placeholder: "例如：空状态、分段控制器、日期范围选择器等"))
        }
    }
}

public enum DesignSystemRatingQuestionKind: Codable, Hashable, Sendable {
    case rating(DesignSystemRatingScale)
    case openText(DesignSystemOpenTextConfiguration)
    
    private enum CodingKeys: String, CodingKey {
        case type
        case ratingScale
        case openTextConfiguration
    }
    
    private enum Kind: String, Codable {
        case rating
        case openText
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(Kind.self, forKey: .type)
        
        switch kind {
        case .rating:
            self = .rating(try container.decode(DesignSystemRatingScale.self, forKey: .ratingScale))
        case .openText:
            self = .openText(try container.decode(DesignSystemOpenTextConfiguration.self, forKey: .openTextConfiguration))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case let .rating(scale):
            try container.encode(Kind.rating, forKey: .type)
            try container.encode(scale, forKey: .ratingScale)
        case let .openText(configuration):
            try container.encode(Kind.openText, forKey: .type)
            try container.encode(configuration, forKey: .openTextConfiguration)
        }
    }
}

public struct DesignSystemRatingScale: Codable, Hashable, Sendable {
    public var minScore: Int
    public var maxScore: Int
    
    public init(
        minScore: Int,
        maxScore: Int
    ) {
        precondition(minScore < maxScore, "minScore must be smaller than maxScore.")
        
        self.minScore = minScore
        self.maxScore = maxScore
    }
    
    public func contains(_ score: Int) -> Bool {
        score >= minScore && score <= maxScore
    }
    
    public static let fivePoint = Self(
        minScore: 1,
        maxScore: 5
    )
}

public struct DesignSystemOpenTextConfiguration: Codable, Hashable, Sendable {
    public var placeholder: String?
    public var maximumLength: Int?
    
    public init(
        placeholder: String? = nil,
        maximumLength: Int? = 30
    ) {
        self.placeholder = placeholder
        self.maximumLength = maximumLength
    }
    
    public static let feedback = Self(
        placeholder: "请输入你的补充意见",
        maximumLength: 500
    )
}

public struct DesignSystemRatingResponse: Codable, Hashable, Sendable {
    public let dimension: DesignSystemRatingDimension
    public var value: DesignSystemRatingAnswerValue?
    
    public init(
        dimension: DesignSystemRatingDimension,
        value: DesignSystemRatingAnswerValue? = nil
    ) {
        self.dimension = dimension
        self.value = value
    }
}

public enum DesignSystemRatingAnswerValue: Codable, Hashable, Sendable {
    case rating(Int)
    case openText(String)
    
    private enum CodingKeys: String, CodingKey {
        case type
        case rating
        case openText
    }
    
    private enum Kind: String, Codable {
        case rating
        case openText
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(Kind.self, forKey: .type)
        
        switch kind {
        case .rating:
            self = .rating(try container.decode(Int.self, forKey: .rating))
        case .openText:
            self = .openText(try container.decode(String.self, forKey: .openText))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case let .rating(score):
            try container.encode(Kind.rating, forKey: .type)
            try container.encode(score, forKey: .rating)
        case let .openText(text):
            try container.encode(Kind.openText, forKey: .type)
            try container.encode(text, forKey: .openText)
        }
    }
}

public struct DesignSystemRatingSubmission: Codable, Hashable, Sendable {
    public let designSystem: DesignSystem
    public var responses: [DesignSystemRatingResponse]
    public var submittedAt: Date
    
    public init(
        designSystem: DesignSystem,
        responses: [DesignSystemRatingResponse],
        submittedAt: Date = .now
    ) {
        self.designSystem = designSystem
        self.responses = responses
        self.submittedAt = submittedAt
    }
}
