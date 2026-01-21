import quizGeneratorService from '../service/quiz_generator_service.js';
import QuizJob from '../models/quiz_job.js';
import MongoQuizRepo from '../repo/mongo_quiz_repo.js';
import Quiz from '../domain/quiz.domain.js';
export const generateQuizJobWorker = async (jobId) => {
    const job = await QuizJob.findById(jobId);
    if (!job) return;

    try {
        const rawQuiz = await quizGeneratorService.generate({
            topic: job.topic,
            difficulty: job.difficulty,
            count: 10
        });
        const quizRepo = new MongoQuizRepo();
        const quiz = new Quiz(rawQuiz);
        await quizRepo.save(quiz);

        job.status = "READY";
        await job.save();

    } catch (err) {
        job.status = "FAILED";
        job.error = err.message;
        await job.save();
    }
};
