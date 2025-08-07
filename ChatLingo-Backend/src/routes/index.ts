import { Router } from 'express';
import authRoutes from './auth';
import essentialRoutes from './essential';

const router = Router();

// Route prefixes
router.use('/auth', authRoutes);
router.use('/essential', essentialRoutes);

// Health check for API routes
router.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    message: 'ChatLingo API is running',
    timestamp: new Date().toISOString(),
    routes: [
      'POST /api/auth/register',
      'POST /api/auth/login', 
      'GET /api/auth/profile',
      'PUT /api/auth/profile',
      'GET /api/essential/categories',
      'GET /api/essential/categories/:id',
      'GET /api/essential/categories/:categoryId/content',
      'GET /api/essential/content/:contentId'
    ]
  });
});

export default router;