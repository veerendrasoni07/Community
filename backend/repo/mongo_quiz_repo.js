import QuizRepo from "./quiz.repo.js";
import Quiz from "../models/quiz.js";
class MongoQuizRepo extends QuizRepo{

    async getQuizById(quizId){
        return Quiz.findById(quizId);
    }

    async save(quiz){
        return Quiz.create(quiz);
    }

}

export default MongoQuizRepo;