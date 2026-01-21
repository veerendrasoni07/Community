import generateQuizJobWorker from '../worker/generateQuiz.worker.js';
import QuizJob from '../models/quiz_job.js';
import Quiz from '../models/quiz.js';
export const generateQuizController =  async(req,res)=>{
    try {
         const { topic, questions } = req.body;

        // 1. Validate request
        if (!topic || !questions) {
            return res.status(400).json({
                error: "topic and questions are required"
            });
        }
        // create a quiz job
        const quizJob = await QuizJob.create({
            quizId: new mongoose.Types.ObjectId(),
            topic,
            difficulty
        });

        process.nextTick(()=>{
            generateQuizJobWorker(quizJob._id);
        })

        res.status(201).json({ quizId:quizJob.quizId,success:true})
    } catch (error) {
        console.log(error);
        return res.status(500).json({
            error: error.message || "Internal Server Error"
        });
    }
}

export const getQuizStatusController = async (req, res) => {
    const job = await QuizJob.findOne({ quizId: req.params.id });

    if (!job) {
        return res.status(404).json({ error: "Quiz not found" });
    }

    return res.json({ status: job.status });
};

export const getQuizController = async (req, res) => {
    const quiz = await Quiz.findById(req.params.id);
    if (!quiz) {
        return res.status(404).json({ error: "Quiz not ready" });
    }
    res.json(quiz);
};

