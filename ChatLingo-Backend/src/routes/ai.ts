import { Router } from 'express';
import { authenticate } from '../middlewares/auth';
import {
  getAiPersonalities,
  startAiConversation,
  sendAiMessage,
  getConversationHistory,
  getUserConversations,
  assessUserInput,
  getPersonalizedRecommendations,
  checkAiServiceStatus
} from '../controllers/aiController';

const router = Router();

// AI service status (public endpoint for health checks)
router.get('/status', checkAiServiceStatus);

// AI personalities (public endpoint)
router.get('/personalities', getAiPersonalities);

// Protected AI conversation routes
router.post('/conversations', authenticate, startAiConversation);
router.get('/conversations', authenticate, getUserConversations);
router.get('/conversations/:conversationId', authenticate, getConversationHistory);
router.post('/conversations/:conversationId/messages', authenticate, sendAiMessage);

// AI assessment routes
router.post('/assess', authenticate, assessUserInput);

// AI recommendations
router.get('/recommendations', authenticate, getPersonalizedRecommendations);

export default router;