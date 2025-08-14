export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  message?: string;
  error?: string;
}

export interface PaginatedResponse<T> extends ApiResponse<T[]> {
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}

export interface AuthTokens {
  accessToken: string;
  refreshToken: string;
}

export interface UserPayload {
  id: string;
  email: string;
  username: string;
}

// Essential Learning Types
export interface EssentialCategoryResponse {
  id: string;
  categoryKey: string;
  name: string;
  displayNameCn: string;
  displayNameEn: string;
  targetLevel: string;
  totalVocabularyCount: number;
  totalPassagesCount: number;
  totalDialoguesCount: number;
  estimatedDurationDays: number;
  isPopular: boolean;
  difficultyColor?: string;
}

export interface EssentialContentResponse {
  id: string;
  categoryId: string;
  contentType: string;
  title: string;
  subtitle?: string;
  difficultyLevel: string;
  contentData: any;
  estimatedLearnTime?: number;
  importanceScore: number;
}

// AI Features Types
export interface AiConversationRequest {
  conversationType: string;
  essentialCategory?: string;
  targetContentIds?: string[];
  aiPersonality?: string;
  learningObjectives?: string[];
}

export interface AiMessageRequest {
  messageText?: string;
  audioUrl?: string;
}

export interface AiAssessmentRequest {
  assessmentType: string;
  inputData: any;
  targetContent?: string;
}

export interface AiPersonalityResponse {
  id: string;
  name: string;
  description: string;
}

export interface AiConversationResponse {
  conversationId: string;
  aiPersonality: string;
  welcomeMessage: string;
  availablePersonalities: string[];
}

export interface AiMessageResponse {
  conversationId: string;
  userMessage: string;
  aiResponse: string;
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
  messageCount: number;
}

export interface AiAssessmentResponse {
  assessmentType: string;
  score: number;
  feedback: string;
  improvements: string[];
  strengths: string[];
  timestamp: Date;
}

// Progress Types
export interface UserProgressResponse {
  categoryId: string;
  categoryName: string;
  completionPercentage: number;
  completedItems: number;
  totalItems: number;
  currentStreakDays: number;
  totalStudyTime: number;
  lastStudiedAt?: Date;
}