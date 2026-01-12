import mongoose from 'mongoose';


const subjectSchema = new mongoose.Schema({
    subject:{
        type:String,
        required:true
    },
    semester:{
        type:String,
        required:true
    },
    noteType:{
        type:String,
        enum:['Detailed Notes','Short Notes','Important Questions'],
        required:true
    },
    chapters:[{
        type:String,
        ref:"Pdf"
    }]
},{timestamps:true});

const Subject = mongoose.model('Subject',subjectSchema);
export default Subject;