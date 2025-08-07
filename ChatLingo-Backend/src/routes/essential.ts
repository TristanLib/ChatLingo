import { Router } from 'express';
import { authenticate, optionalAuth } from '../middlewares/auth';
import {
  getCategories,
  getCategoryById,
  getCategoryContent,
  getContentById
} from '../controllers/essentialController';

const router = Router();

// Essential categories routes
router.get('/categories', optionalAuth, getCategories);
router.get('/categories/:id', optionalAuth, getCategoryById);

// Essential content routes  
router.get('/categories/:categoryId/content', optionalAuth, getCategoryContent);
router.get('/content/:contentId', optionalAuth, getContentById);

export default router;