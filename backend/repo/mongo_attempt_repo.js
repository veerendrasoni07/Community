import AttemptRepo from "./attempt.repo.js";
import QuizAttempt from "../models/quiz_attempt.js";
class MongoAttemptRepo extends AttemptRepo {

    async save(attempt){
        return QuizAttempt.create(attempt);
    }



}
export default MongoAttemptRepo;