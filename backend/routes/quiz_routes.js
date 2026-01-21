import { submitQuizController } from "../controller/submit_quiz.controller.js";
import express from 'express';
const quizRouter = express.Router();

quizRouter.post('/api/quiz-submit',submitQuizController);

export default quizRouter;