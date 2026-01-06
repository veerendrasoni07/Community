
import mongoose from 'mongoose'



const hackathonSchema = new mongoose.Schema({

    name:{
        type:String,
        required:true
    },
    image:{
        type:String,
        required: true
    },
    description:{
        type:String,
        required:true
    },
    eventdate:{
        type:String,
        required:true
    },
    deadline:{
        type:String,
        required:true
    },
    prize:{
        type:Number,
        required:true
    },
    venue:{
        type:String,
        required:true
    },
    teamsize:{
        type:Number,
        required:true
    },
    level:{
        type:String,
        required:true
    },
    link:{
        type:String,
        required:true
    }

});

const Hackathon = mongoose.model("Hackathon",hackathonSchema);

export default Hackathon;