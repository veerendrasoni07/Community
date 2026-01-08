import mongoose  from "mongoose";


const questionSchema = new mongoose.Schema({
    questionText:{
        type:String,
        required:true
    },
    options:{  
        type:[String],
        required:true
    },
    correctAnswer:{
        type:Number,
        required:true
    }
}); 

const quizSchema = new mongoose.Schema({
    quizName:{
        type:String,
        required:true
    },
    quizBanner:{
        type:String,
        required:true
    },
    quizDifficulty:{
        type:String,
        enum:['Easy','Medium','Hard'],
        required:true
    },
    points:{
        type:Number,
        required:true,
        default:0
    },
    questions:[{
        type:questionSchema,
        required:true
    }]
},{timestamps:true});

export default mongoose.model("Quiz", quizSchema);