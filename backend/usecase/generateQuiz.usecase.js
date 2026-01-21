import Quiz from "../domain/quiz.domain.js";
import quizGeneratorService from '../service/quiz_generator_service.js'
class GenerateQuizUseCase {

    constructor(quizRepo) {
        this.quizRepo = quizRepo;
    }

    async execute({ topic, questions }) {

    
       // 1. Generate using AI
        const rawQuiz = await this.quizGeneratorService.generate({
            topic,
            difficulty,
            count
        });

        // 2. Domain validation (AI CANNOT BYPASS THIS)
        const quiz = new Quiz(rawQuiz);

        // 3. Save
        const savedQuiz = await this.quizRepo.save(quiz);

        return {
            quizId: savedQuiz._id,
            totalQuestions: quiz.questions.length
        };
    }
}

export default GenerateQuizUseCase;
