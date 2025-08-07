import { Request, Response } from 'express';
import { sendSuccess, sendError, sendPaginated } from '../utils/response';

// Mock data for development - will be replaced with database queries
const mockCategories = [
  {
    id: '1',
    categoryKey: 'junior_high',
    name: 'junior_high_essentials',
    displayNameCn: '初中必会',
    displayNameEn: 'Junior High Essentials',
    targetLevel: 'A1-A2',
    totalVocabularyCount: 1500,
    totalPassagesCount: 50,
    totalDialoguesCount: 30,
    estimatedDurationDays: 90,
    isPopular: false,
    difficultyColor: '#4CAF50'
  },
  {
    id: '2', 
    categoryKey: 'senior_high',
    name: 'senior_high_essentials',
    displayNameCn: '高中必会',
    displayNameEn: 'Senior High Essentials',
    targetLevel: 'A2-B1',
    totalVocabularyCount: 3500,
    totalPassagesCount: 100,
    totalDialoguesCount: 50,
    estimatedDurationDays: 120,
    isPopular: false,
    difficultyColor: '#FF9800'
  },
  {
    id: '3',
    categoryKey: 'cet4',
    name: 'cet4_essentials', 
    displayNameCn: '四级必会',
    displayNameEn: 'CET-4 Essentials',
    targetLevel: 'B1',
    totalVocabularyCount: 4500,
    totalPassagesCount: 100,
    totalDialoguesCount: 100,
    estimatedDurationDays: 100,
    isPopular: true,
    difficultyColor: '#2196F3'
  },
  {
    id: '4',
    categoryKey: 'business',
    name: 'business_essentials',
    displayNameCn: '商务必会', 
    displayNameEn: 'Business Essentials',
    targetLevel: 'B1-B2',
    totalVocabularyCount: 2500,
    totalPassagesCount: 60,
    totalDialoguesCount: 80,
    estimatedDurationDays: 80,
    isPopular: false,
    difficultyColor: '#795548'
  },
  {
    id: '5',
    categoryKey: 'postgraduate',
    name: 'postgraduate_essentials',
    displayNameCn: '考研必会',
    displayNameEn: 'Postgraduate Essentials', 
    targetLevel: 'B2-C1',
    totalVocabularyCount: 5500,
    totalPassagesCount: 200,
    totalDialoguesCount: 80,
    estimatedDurationDays: 150,
    isPopular: true,
    difficultyColor: '#F44336'
  }
];

const mockContent = [
  {
    id: '1',
    categoryId: '3',
    contentType: 'vocabulary',
    title: 'CET-4 Core Vocabulary - Unit 1',
    subtitle: '大学英语四级核心词汇第一单元',
    difficultyLevel: 'intermediate',
    contentData: {
      words: [
        {
          word: 'abandon',
          pronunciation: '/əˈbændən/',
          meaning: '放弃，抛弃',
          example: 'He abandoned his car in the snow.',
          chineseMeaning: '放弃，抛弃'
        },
        {
          word: 'abstract',
          pronunciation: '/ˈæbstrækt/',
          meaning: '抽象的',
          example: 'Mathematics is an abstract subject.',
          chineseMeaning: '抽象的'
        }
      ]
    },
    estimatedLearnTime: 30,
    importanceScore: 95
  },
  {
    id: '2',
    categoryId: '4',
    contentType: 'dialogues',
    title: 'Business Meeting Introduction',
    subtitle: '商务会议介绍对话',
    difficultyLevel: 'intermediate',
    contentData: {
      scenario: 'Meeting Room Introduction',
      dialogue: [
        {
          speaker: 'A',
          text: 'Good morning everyone. Let me introduce myself. I\'m Sarah from the marketing department.'
        },
        {
          speaker: 'B', 
          text: 'Nice to meet you, Sarah. I\'m David, the project manager for this initiative.'
        }
      ]
    },
    estimatedLearnTime: 15,
    importanceScore: 85
  }
];

export const getCategories = async (req: Request, res: Response): Promise<void> => {
  try {
    // TODO: Replace with actual database query
    // const categories = await prisma.essentialCategories.findMany({
    //   where: { isActive: true },
    //   orderBy: { sortOrder: 'asc' }
    // });

    sendSuccess(res, mockCategories, 'Essential categories retrieved successfully');
  } catch (error) {
    console.error('Error fetching categories:', error);
    sendError(res, 'Failed to fetch essential categories', 500);
  }
};

export const getCategoryById = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    
    // TODO: Replace with actual database query
    const category = mockCategories.find(cat => cat.id === id);
    
    if (!category) {
      sendError(res, 'Category not found', 404);
      return;
    }

    sendSuccess(res, category, 'Category retrieved successfully');
  } catch (error) {
    console.error('Error fetching category:', error);
    sendError(res, 'Failed to fetch category', 500);
  }
};

export const getCategoryContent = async (req: Request, res: Response): Promise<void> => {
  try {
    const { categoryId } = req.params;
    const { type, page = 1, limit = 10 } = req.query;

    // TODO: Replace with actual database query
    let filteredContent = mockContent.filter(content => content.categoryId === categoryId);
    
    if (type) {
      filteredContent = filteredContent.filter(content => content.contentType === type);
    }

    const startIndex = (Number(page) - 1) * Number(limit);
    const endIndex = startIndex + Number(limit);
    const paginatedContent = filteredContent.slice(startIndex, endIndex);

    sendPaginated(
      res,
      paginatedContent,
      Number(page),
      Number(limit),
      filteredContent.length,
      'Category content retrieved successfully'
    );
  } catch (error) {
    console.error('Error fetching category content:', error);
    sendError(res, 'Failed to fetch category content', 500);
  }
};

export const getContentById = async (req: Request, res: Response): Promise<void> => {
  try {
    const { contentId } = req.params;
    
    // TODO: Replace with actual database query
    const content = mockContent.find(c => c.id === contentId);
    
    if (!content) {
      sendError(res, 'Content not found', 404);
      return;
    }

    sendSuccess(res, content, 'Content retrieved successfully');
  } catch (error) {
    console.error('Error fetching content:', error);
    sendError(res, 'Failed to fetch content', 500);
  }
};