import SubmitQuizUseCase from "../usecase/submitquiz.usecase.js";
import MongoAttemptRepo from '../repo/mongo_attempt_repo.js';
import MongoQuizRepo from '../repo/mongo_quiz_repo.js';

export const submitQuizController = async(req,res)=>{
    try {
        const {userId,quizId,answers} = req.body;
        if(!userId || !quizId || !answers){
            return res.status(401).json({msg:"Fields are missing!"});
        }
        const attemptRepo = new MongoAttemptRepo();
        const quizRepo = new MongoQuizRepo();
        const submit = new SubmitQuizUseCase(attemptRepo,quizRepo);
        const result =  await submit.execute(quizId,userId,answers);
        res.status(200).json({
            success: true,
            data: result
        });
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
}