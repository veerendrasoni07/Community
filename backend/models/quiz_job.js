import mongoose from "mongoose";

const quizJobSchema = new mongoose.Schema({
    quizId: {
        type: mongoose.Schema.Types.ObjectId,
        required: true
    },
    topic: String,
    difficulty: String,
    status: {
        type: String,
        enum: ["PENDING", "READY", "FAILED"],
        default: "PENDING"
    },
    error: String
}, { timestamps: true });

const QuizJob = mongoose.model("QuizJob", quizJobSchema);

export default QuizJob;
