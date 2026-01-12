import mongoose from "mongoose";

const pdfSchema = new mongoose.Schema({

    semester:{
        type:String,
        // required:true,
    },
    noteType:{
        type:String,
        enum:['Detailed Notes','Short Notes','Important Questions'],
        // required:true
    },
    subject:{
        type:String,
        // required:true
    },
    chapter:{
        type:String,
        // required:true
    },
    pdf:{
        type:String,
        // required:true
    },
},{timestamps:true});



export default mongoose.model("Pdf", pdfSchema);
