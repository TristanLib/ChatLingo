import OpenAI from 'openai';

// Initialize OpenAI client
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY || '',
});

// AI Personality definitions for different roles
export const AI_PERSONALITIES = {
  friendly_teacher: {
    name: '🧑‍🏫 AI Teacher',
    systemPrompt: `You are a friendly and encouraging English teacher helping Chinese students learn English. Your teaching style is:
- Patient and supportive, never critical
- Focus on practical learning and real-world usage
- Provide clear explanations for grammar and vocabulary
- Use the student's essential learning content when possible
- Correct mistakes gently and offer better alternatives
- Ask follow-up questions to encourage practice
- Keep conversations educational but engaging
Always respond in a way that builds confidence while improving English skills.`,
  },

  casual_friend: {
    name: '👥 AI Friend', 
    systemPrompt: `You are a casual, friendly conversation partner helping someone practice English naturally. Your approach is:
- Relaxed and conversational, like talking to a good friend
- Use everyday language and common expressions
- Share interesting topics and ask about their interests
- Gently correct major errors without being too formal
- Keep the conversation flowing naturally
- Be encouraging and positive
- Mix in some slang and colloquial expressions appropriately
Make the English practice feel like chatting with a friend, not studying.`,
  },

  professional_interviewer: {
    name: '💼 AI Interviewer',
    systemPrompt: `You are a professional interviewer conducting English job interviews. Your style is:
- Professional but approachable
- Ask realistic interview questions for various job roles
- Focus on business English and professional communication
- Provide feedback on professional language use
- Help practice common interview scenarios
- Give constructive advice on professional speaking
- Use formal business vocabulary and expressions
- Simulate real workplace communication situations
Help the candidate improve their professional English confidence.`,
  },

  business_partner: {
    name: '🤝 AI Business Partner',
    systemPrompt: `You are a business partner in professional scenarios. Your communication is:
- Business-focused and goal-oriented
- Use professional business vocabulary
- Practice negotiation, presentation, and meeting scenarios
- Focus on clear, efficient communication
- Include business idioms and expressions
- Simulate real business conversations (meetings, calls, emails)
- Provide feedback on business communication effectiveness
- Help with industry-specific language
Make business English practice realistic and immediately applicable.`,
  },
};

export interface AiChatRequest {
  message: string;
  conversationHistory?: Array<{
    role: 'user' | 'assistant';
    content: string;
  }>;
  personality?: keyof typeof AI_PERSONALITIES;
  essentialCategory?: string;
  targetVocabulary?: string[];
}

export interface AiChatResponse {
  message: string;
  suggestions?: string[];
  corrections?: Array<{
    original: string;
    corrected: string;
    explanation: string;
  }>;
  vocabulary?: Array<{
    word: string;
    meaning: string;
    example: string;
  }>;
  conversationId?: string;
}

export class AiService {
  
  async generateChatResponse(request: AiChatRequest): Promise<AiChatResponse> {
    try {
      const personality = AI_PERSONALITIES[request.personality || 'friendly_teacher'];
      
      // Build conversation context
      const messages: OpenAI.Chat.Completions.ChatCompletionMessageParam[] = [
        {
          role: 'system',
          content: this.buildSystemPrompt(personality.systemPrompt, request)
        }
      ];

      // Add conversation history
      if (request.conversationHistory) {
        request.conversationHistory.forEach(msg => {
          messages.push({
            role: msg.role,
            content: msg.content
          });
        });
      }

      // Add current user message
      messages.push({
        role: 'user',
        content: request.message
      });

      // Call OpenAI API
      const completion = await openai.chat.completions.create({
        model: process.env.OPENAI_MODEL || 'gpt-4',
        messages,
        max_tokens: 500,
        temperature: 0.7,
        presence_penalty: 0.1,
        frequency_penalty: 0.1,
      });

      const aiMessage = completion.choices[0]?.message?.content || '';

      // Parse AI response for structured data
      const response = this.parseAiResponse(aiMessage, request);

      return response;

    } catch (error) {
      console.error('OpenAI API Error:', error);
      throw new Error('Failed to generate AI response');
    }
  }

  private buildSystemPrompt(basePrompt: string, request: AiChatRequest): string {
    let systemPrompt = basePrompt;

    // Add essential category context
    if (request.essentialCategory) {
      systemPrompt += `\n\nCurrent learning focus: ${request.essentialCategory} level English. Tailor your responses to this level.`;
    }

    // Add target vocabulary
    if (request.targetVocabulary && request.targetVocabulary.length > 0) {
      systemPrompt += `\n\nTarget vocabulary to practice: ${request.targetVocabulary.join(', ')}. Try to naturally incorporate these words when appropriate.`;
    }

    // Add response format guidance
    systemPrompt += `\n\nIMPORTANT: Keep responses conversational and natural. If you notice grammar or vocabulary errors, provide gentle corrections. Be encouraging and help build confidence.`;

    return systemPrompt;
  }

  private parseAiResponse(aiMessage: string, request: AiChatRequest): AiChatResponse {
    // For now, return the basic message
    // In future iterations, we could parse structured responses with corrections and suggestions
    return {
      message: aiMessage,
      suggestions: [], // Could be populated with conversation suggestions
      corrections: [], // Could be populated with grammar corrections
      vocabulary: [], // Could be populated with vocabulary explanations
    };
  }

  async generateAssessment(
    userText: string, 
    targetContent?: string,
    assessmentType: 'grammar' | 'vocabulary' | 'overall' = 'overall'
  ): Promise<{
    score: number;
    feedback: string;
    improvements: string[];
    strengths: string[];
  }> {
    try {
      const systemPrompt = `You are an English language assessment AI. Analyze the following English text and provide:
1. A score from 1-100
2. Specific feedback on ${assessmentType}
3. Areas for improvement
4. Strengths to acknowledge

Be encouraging but constructive. Focus on helping the learner improve.`;

      const completion = await openai.chat.completions.create({
        model: process.env.OPENAI_MODEL || 'gpt-4',
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: `Please assess this English text: "${userText}"` }
        ],
        max_tokens: 300,
        temperature: 0.3,
      });

      const assessment = completion.choices[0]?.message?.content || '';
      
      // Parse assessment (simplified for now)
      return {
        score: Math.floor(Math.random() * 30) + 70, // Placeholder scoring
        feedback: assessment,
        improvements: ['Practice more complex sentence structures', 'Expand vocabulary'],
        strengths: ['Good basic grammar', 'Clear communication'],
      };

    } catch (error) {
      console.error('Assessment API Error:', error);
      throw new Error('Failed to generate assessment');
    }
  }

  async generatePersonalizedRecommendations(
    userId: string,
    learningHistory: any[],
    currentLevel: string
  ): Promise<{
    dailyPlan: string[];
    reviewItems: string[];
    newContent: string[];
    focusAreas: string[];
  }> {
    try {
      const systemPrompt = `You are a personalized English learning advisor. Based on the user's learning history and current level, provide specific recommendations for:
1. Daily learning plan (3-5 items)
2. Content to review
3. New content to explore
4. Areas that need focus

Be specific and actionable.`;

      const completion = await openai.chat.completions.create({
        model: process.env.OPENAI_MODEL || 'gpt-4',
        messages: [
          { role: 'system', content: systemPrompt },
          { 
            role: 'user', 
            content: `User level: ${currentLevel}. Recent learning: ${JSON.stringify(learningHistory.slice(-5))}` 
          }
        ],
        max_tokens: 400,
        temperature: 0.5,
      });

      const recommendations = completion.choices[0]?.message?.content || '';
      
      // Parse recommendations (simplified for now)
      return {
        dailyPlan: [
          'Review 20 essential vocabulary words',
          'Practice one dialogue conversation',
          'Read one short passage',
        ],
        reviewItems: ['Previous week vocabulary', 'Grammar patterns'],
        newContent: ['Business email templates', 'Interview phrases'],
        focusAreas: ['Pronunciation', 'Grammar accuracy'],
      };

    } catch (error) {
      console.error('Recommendations API Error:', error);
      throw new Error('Failed to generate recommendations');
    }
  }

  // Utility method to check if OpenAI is properly configured
  static isConfigured(): boolean {
    return !!(process.env.OPENAI_API_KEY && process.env.OPENAI_API_KEY.length > 0);
  }

  // Method to validate API key
  async validateConfiguration(): Promise<boolean> {
    try {
      await openai.models.list();
      return true;
    } catch (error) {
      console.error('OpenAI configuration validation failed:', error);
      return false;
    }
  }
}

export default new AiService();