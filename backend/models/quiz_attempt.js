import mongoose from "mongoose";


const quizAttemptSchema = new mongoose.Schema({
    user:{
        type:mongoose.Types.ObjectId,
        ref:'User',
        required:true
    },
    quiz:{
        type:mongoose.Types.ObjectId,
        ref:'Quiz',
        required:true
    },
    score:{
        type:Number,
        required:true
    },
    answers:{
        type:[Map],
        required:true
    }
});

const QuizAttempt = mongoose.model("QuizAttempt",quizAttemptSchema);

export default QuizAttempt;