//
//  AIChatViewModel.swift
//  ChatLingo
//
//  Created by ChatLingo Team on 2025/8/6.
//

import Foundation

@MainActor
class AIChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    @Published var currentRole: AIRole = .friend
    
    func setAIRole(_ role: AIRole) {
        currentRole = role
        messages.removeAll()
        
        // 添加AI角色的欢迎消息
        let welcomeMessage = ChatMessage(
            content: getWelcomeMessage(for: role),
            isUser: false,
            timestamp: Date(),
            messageType: .text,
            aiRole: role
        )
        messages.append(welcomeMessage)
    }
    
    func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        // 添加用户消息
        let userMessage = ChatMessage(
            content: text,
            isUser: true,
            timestamp: Date(),
            messageType: .text
        )
        messages.append(userMessage)
        
        // 清空输入框
        inputText = ""
        
        // 模拟AI回复
        Task {
            await simulateAIResponse(to: text)
        }
    }
    
    private func simulateAIResponse(to userMessage: String) async {
        isLoading = true
        
        // 模拟网络延迟
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        
        let aiResponse = generateAIResponse(for: userMessage, role: currentRole)
        
        let aiMessage = ChatMessage(
            content: aiResponse,
            isUser: false,
            timestamp: Date(),
            messageType: .text,
            aiRole: currentRole
        )
        
        messages.append(aiMessage)
        isLoading = false
    }
    
    private func getWelcomeMessage(for role: AIRole) -> String {
        switch role {
        case .teacher:
            return "Hello! I'm your English teacher. I'm here to help you improve your English skills. What would you like to practice today?"
        case .friend:
            return "Hey there! I'm excited to chat with you in English. What's on your mind today?"
        case .interviewer:
            return "Good day! I'll be conducting your English interview today. Let's start with a simple question: Could you tell me about yourself?"
        case .colleague:
            return "Hello! As your colleague, I'm here to help you practice professional English. What business topic would you like to discuss?"
        case .customer:
            return "Hello! How can I assist you today? I'm here to help with any questions or concerns you may have."
        case .tourist:
            return "Hi! Welcome! I'm here to help you with travel-related English conversations. Where would you like to go?"
        }
    }
    
    private func generateAIResponse(for userMessage: String, role: AIRole) -> String {
        // 这里是简化的模拟回复，实际应用中应该调用GPT-4 API
        let responses = getResponseTemplates(for: role)
        let randomResponse = responses.randomElement() ?? "I understand. Could you tell me more about that?"
        
        // 简单的回复逻辑
        if userMessage.lowercased().contains("hello") || userMessage.lowercased().contains("hi") {
            return getGreetingResponse(for: role)
        } else if userMessage.lowercased().contains("help") {
            return getHelpResponse(for: role)
        } else {
            return randomResponse
        }
    }
    
    private func getResponseTemplates(for role: AIRole) -> [String] {
        switch role {
        case .teacher:
            return [
                "That's a good start! Let me help you improve that sentence.",
                "I notice a small grammar mistake. The correct way to say that would be...",
                "Excellent! Your English is improving. Try using this word in another sentence.",
                "Let me explain this grammar rule to help you understand better."
            ]
        case .friend:
            return [
                "That sounds interesting! Tell me more about it.",
                "I totally get what you mean! Have you tried...",
                "Wow, that's cool! I'd love to hear more details.",
                "That reminds me of something similar I experienced."
            ]
        case .interviewer:
            return [
                "Thank you for that answer. Can you give me a specific example?",
                "That's good to know. What would you say is your greatest strength?",
                "Interesting perspective. How do you handle challenging situations?",
                "I see. What are your career goals for the next five years?"
            ]
        case .colleague:
            return [
                "That's a solid business strategy. What metrics would you use to measure success?",
                "I agree with your analysis. Have you considered the market implications?",
                "Good point! How do you think this will affect our quarterly results?",
                "That presentation idea sounds promising. What's your timeline for implementation?"
            ]
        case .customer:
            return [
                "I understand your concern. Let me help you with that right away.",
                "Thank you for bringing this to our attention. Here's what we can do...",
                "I apologize for any inconvenience. Allow me to find a solution for you.",
                "That's a great question! I'm happy to explain how this works."
            ]
        case .tourist:
            return [
                "That's a wonderful destination! Have you been there before?",
                "I can recommend some great places to visit there. What are you most interested in?",
                "Make sure to try the local cuisine! Do you have any dietary restrictions?",
                "The best time to visit is usually... What time of year are you planning to go?"
            ]
        }
    }
    
    private func getGreetingResponse(for role: AIRole) -> String {
        switch role {
        case .teacher:
            return "Hello! Great to see you're practicing your greetings. How are you feeling about your English today?"
        case .friend:
            return "Hey! Nice to see you! How's your day going so far?"
        case .interviewer:
            return "Hello! Thank you for coming today. Please, have a seat and make yourself comfortable."
        case .colleague:
            return "Good morning! Ready for another productive day at work?"
        case .customer:
            return "Hello! Welcome! I'm here to assist you with anything you need."
        case .tourist:
            return "Hello! Welcome to our beautiful city! Is this your first time visiting?"
        }
    }
    
    private func getHelpResponse(for role: AIRole) -> String {
        switch role {
        case .teacher:
            return "Of course I can help! What specific area of English would you like to work on - grammar, vocabulary, or pronunciation?"
        case .friend:
            return "Sure thing! I'm here for you. What do you need help with?"
        case .interviewer:
            return "Certainly! Feel free to ask me to clarify any questions during our interview."
        case .colleague:
            return "Absolutely! I'm happy to assist with any work-related questions or projects."
        case .customer:
            return "I'm here to help! What specific issue or question can I assist you with today?"
        case .tourist:
            return "I'd be delighted to help! What information do you need about your travel plans?"
        }
    }
}