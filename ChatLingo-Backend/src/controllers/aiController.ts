import { Request, Response } from 'express';
import { sendSuccess, sendError, sendValidationError } from '../utils/response';
import aiService, { AI_PERSONALITIES, AiService } from '../services/aiService';
import { AiConversationRequest, AiMessageRequest, AiAssessmentRequest } from '../types';

// Mock conversation storage (will be replaced with database)
const mockConversations = new Map<string, {
  id: string;
  userId: string;
  personality: string;
  messages: Array<{
    role: 'user' | 'assistant';
    content: string;
    timestamp: Date;
  }>;
  startedAt: Date;
  lastActiveAt: Date;
}>();

export const getAiPersonalities = async (req: Request, res: Response): Promise<void> => {
  try {
    const personalities = Object.entries(AI_PERSONALITIES).map(([key, value]) => ({
      id: key,
      name: value.name,
      description: getPersonalityDescription(key)
    }));

    sendSuccess(res, personalities, 'AI personalities retrieved successfully');
  } catch (error) {
    console.error('Error fetching AI personalities:', error);
    sendError(res, 'Failed to fetch AI personalities', 500);
  }
};

export const startAiConversation = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      sendError(res, 'User authentication required', 401);
      return;
    }

    const { 
      conversationType, 
      essentialCategory, 
      targetContentIds, 
      aiPersonality = 'friendly_teacher',
      learningObjectives 
    }: AiConversationRequest = req.body;

    // Validation
    const errors: string[] = [];
    if (!conversationType) errors.push('Conversation type is required');
    if (aiPersonality && !AI_PERSONALITIES[aiPersonality as keyof typeof AI_PERSONALITIES]) {
      errors.push('Invalid AI personality');
    }

    if (errors.length > 0) {
      sendValidationError(res, errors);
      return;
    }

    // Check OpenAI configuration
    if (!AiService.isConfigured()) {
      sendError(res, 'AI service is not properly configured', 503);
      return;
    }

    // Create new conversation
    const conversationId = `conv_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    const conversation = {
      id: conversationId,
      userId,
      personality: aiPersonality,
      messages: [],
      startedAt: new Date(),
      lastActiveAt: new Date(),
    };

    mockConversations.set(conversationId, conversation);

    // Generate welcome message based on personality
    const welcomeMessage = generateWelcomeMessage(aiPersonality, essentialCategory);

    sendSuccess(res, {
      conversationId,
      aiPersonality,
      welcomeMessage,
      availablePersonalities: Object.keys(AI_PERSONALITIES),
    }, 'AI conversation started successfully', 201);

  } catch (error) {
    console.error('Error starting AI conversation:', error);
    sendError(res, 'Failed to start AI conversation', 500);
  }
};

export const sendAiMessage = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.user?.id;
    const { conversationId } = req.params;
    const { messageText, audioUrl }: AiMessageRequest = req.body;

    if (!userId) {
      sendError(res, 'User authentication required', 401);
      return;
    }

    if (!messageText) {
      sendError(res, 'Message text is required', 400);
      return;
    }

    // Get conversation
    const conversation = mockConversations.get(conversationId);
    if (!conversation) {
      sendError(res, 'Conversation not found', 404);
      return;
    }

    if (conversation.userId !== userId) {
      sendError(res, 'Access denied', 403);
      return;
    }

    // Add user message to conversation
    conversation.messages.push({
      role: 'user',
      content: messageText,
      timestamp: new Date(),
    });

    // Get AI response
    const aiResponse = await aiService.generateChatResponse({
      message: messageText,
      conversationHistory: conversation.messages.slice(-10), // Last 10 messages for context
      personality: conversation.personality as keyof typeof AI_PERSONALITIES,
    });

    // Add AI response to conversation
    conversation.messages.push({
      role: 'assistant',
      content: aiResponse.message,
      timestamp: new Date(),
    });

    conversation.lastActiveAt = new Date();

    sendSuccess(res, {
      conversationId,
      userMessage: messageText,
      aiResponse: aiResponse.message,
      suggestions: aiResponse.suggestions,
      corrections: aiResponse.corrections,
      vocabulary: aiResponse.vocabulary,
      messageCount: conversation.messages.length,
    }, 'Message sent successfully');

  } catch (error) {
    console.error('Error sending AI message:', error);
    sendError(res, 'Failed to send message', 500);
  }
};

export const getConversationHistory = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.user?.id;
    const { conversationId } = req.params;

    if (!userId) {
      sendError(res, 'User authentication required', 401);
      return;
    }

    const conversation = mockConversations.get(conversationId);
    if (!conversation) {
      sendError(res, 'Conversation not found', 404);
      return;
    }

    if (conversation.userId !== userId) {
      sendError(res, 'Access denied', 403);
      return;
    }

    sendSuccess(res, {
      conversationId,
      personality: conversation.personality,
      messages: conversation.messages,
      startedAt: conversation.startedAt,
      lastActiveAt: conversation.lastActiveAt,
      messageCount: conversation.messages.length,
    }, 'Conversation history retrieved successfully');

  } catch (error) {
    console.error('Error fetching conversation history:', error);
    sendError(res, 'Failed to fetch conversation history', 500);
  }
};

export const getUserConversations = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.user?.id;

    if (!userId) {
      sendError(res, 'User authentication required', 401);
      return;
    }

    const userConversations = Array.from(mockConversations.values())
      .filter(conv => conv.userId === userId)
      .map(conv => ({
        id: conv.id,
        personality: conv.personality,
        startedAt: conv.startedAt,
        lastActiveAt: conv.lastActiveAt,
        messageCount: conv.messages.length,
        lastMessage: conv.messages[conv.messages.length - 1]?.content || '',
      }))
      .sort((a, b) => b.lastActiveAt.getTime() - a.lastActiveAt.getTime());

    sendSuccess(res, userConversations, 'User conversations retrieved successfully');

  } catch (error) {
    console.error('Error fetching user conversations:', error);
    sendError(res, 'Failed to fetch conversations', 500);
  }
};

export const assessUserInput = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.user?.id;
    const { 
      assessmentType, 
      inputData, 
      targetContent 
    }: AiAssessmentRequest = req.body;

    if (!userId) {
      sendError(res, 'User authentication required', 401);
      return;
    }

    if (!assessmentType || !inputData) {
      sendError(res, 'Assessment type and input data are required', 400);
      return;
    }

    // Check OpenAI configuration
    if (!AiService.isConfigured()) {
      sendError(res, 'AI service is not properly configured', 503);
      return;
    }

    const assessment = await aiService.generateAssessment(
      inputData.text || inputData,
      targetContent,
      assessmentType as 'grammar' | 'vocabulary' | 'overall'
    );

    sendSuccess(res, {
      assessmentType,
      score: assessment.score,
      feedback: assessment.feedback,
      improvements: assessment.improvements,
      strengths: assessment.strengths,
      timestamp: new Date(),
    }, 'Assessment completed successfully');

  } catch (error) {
    console.error('Error in AI assessment:', error);
    sendError(res, 'Failed to complete assessment', 500);
  }
};

export const getPersonalizedRecommendations = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.user?.id;

    if (!userId) {
      sendError(res, 'User authentication required', 401);
      return;
    }

    // Mock learning history (will be replaced with database query)
    const learningHistory = [
      { content: 'CET-4 vocabulary', date: new Date(), score: 85 },
      { content: 'Business dialogue', date: new Date(), score: 78 },
    ];

    const recommendations = await aiService.generatePersonalizedRecommendations(
      userId,
      learningHistory,
      'intermediate'
    );

    sendSuccess(res, {
      userId,
      recommendations,
      generatedAt: new Date(),
    }, 'Personalized recommendations generated successfully');

  } catch (error) {
    console.error('Error generating recommendations:', error);
    sendError(res, 'Failed to generate recommendations', 500);
  }
};

export const checkAiServiceStatus = async (req: Request, res: Response): Promise<void> => {
  try {
    const isConfigured = AiService.isConfigured();
    let isConnected = false;

    if (isConfigured) {
      isConnected = await aiService.validateConfiguration();
    }

    sendSuccess(res, {
      configured: isConfigured,
      connected: isConnected,
      model: process.env.OPENAI_MODEL || 'gpt-4',
      personalities: Object.keys(AI_PERSONALITIES),
    }, 'AI service status checked');

  } catch (error) {
    console.error('Error checking AI service status:', error);
    sendError(res, 'Failed to check AI service status', 500);
  }
};

// Helper functions
function getPersonalityDescription(personality: string): string {
  const descriptions = {
    friendly_teacher: 'Patient and encouraging teacher who provides educational guidance',
    casual_friend: 'Relaxed conversation partner for natural English practice',
    professional_interviewer: 'Professional interviewer for job interview practice',
    business_partner: 'Business-focused partner for professional communication',
  };
  return descriptions[personality as keyof typeof descriptions] || 'AI conversation partner';
}

function generateWelcomeMessage(personality: string, essentialCategory?: string): string {
  const welcomeMessages = {
    friendly_teacher: `Hello! I'm your AI English teacher. I'm here to help you learn and practice English in a supportive environment. ${essentialCategory ? `I see you're working on ${essentialCategory} level content - great choice!` : ''} What would you like to practice today?`,
    
    casual_friend: `Hey there! Ready to chat and practice some English? ${essentialCategory ? `I know you're focusing on ${essentialCategory} level English, so let's keep it natural and fun.` : ''} What's on your mind today?`,
    
    professional_interviewer: `Good day! I'll be conducting your interview practice session today. ${essentialCategory ? `Since you're preparing for ${essentialCategory} level content, we'll tailor our questions accordingly.` : ''} Shall we begin with a brief introduction about yourself?`,
    
    business_partner: `Hello! I'm here to help you practice professional business communication. ${essentialCategory ? `Given your focus on ${essentialCategory} level content, we'll work on relevant business scenarios.` : ''} What business situation would you like to practice today?`,
  };
  
  return welcomeMessages[personality as keyof typeof welcomeMessages] || 'Hello! How can I help you practice English today?';
}