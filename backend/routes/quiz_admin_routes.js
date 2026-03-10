import express from "express";
import { auth } from "../middleware/auth.js";
import {
    activateQuizController,
    createQuizController,
    deleteQuizController,
    listAllQuizController
} from "../controller/admin_quiz.controller.js";

const adminQuizRouter = express.Router();

adminQuizRouter.post("/api/admin/quiz", auth, createQuizController);
adminQuizRouter.get("/api/admin/quiz", auth, listAllQuizController);
adminQuizRouter.patch("/api/admin/quiz/:quizId/activate", auth, activateQuizController);
adminQuizRouter.delete("/api/admin/quiz/:quizId", auth, deleteQuizController);

export default adminQuizRouter;
