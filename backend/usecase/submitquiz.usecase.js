import QuizAttempt from "../domain/quizattempt.domain.js";

class SubmitQuizUseCase{

    constructor(quizRepo,attemptRepo){
        this.quizRepo = quizRepo;
        this.attemptRepo = attemptRepo;
    }


    async execute (quizId,userId,answers){
        //1. fetch quiz data ,correct answer and totalquestions
        //2. create domain object
        //3. calculate the scores
        //4. save the data
        //5. return the result

        const quiz = await this.quizRepo.getQuizById(quizId);
        const correctAnswers = quiz.correctAnswers;
        const totalQuestions = Object.keys(correctAnswers).length;
        const attempt = new QuizAttempt(
            userId,
            quizId,
            answers,
            totalQue
        );
        const score = attempt.calculateScore(correctAnswers);

        await this.attemptRepo.save({
            userId,
            quizId,
            answers,
            score
        });
        return {
            score,
            totalQuestions,
            accuracy:(score/totalQuestions)*100
        }

    }

}

export default SubmitQuizUseCase;