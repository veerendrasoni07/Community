import {
    getActiveQuizController,
    getMyQuizAttemptsController,
    getQuizByIdController,
    submitQuizController
} from "../controller/submit_quiz.controller.js";
import express from 'express';
import { auth } from "../middleware/auth.js";
const quizRouter = express.Router();

quizRouter.get('/api/quiz/active', auth, getActiveQuizController);
quizRouter.get('/api/quiz/attempts/me', auth, getMyQuizAttemptsController);
quizRouter.get('/api/quiz/:quizId', auth, getQuizByIdController);
quizRouter.post('/api/quiz-submit', auth, submitQuizController);

export default quizRouter;
