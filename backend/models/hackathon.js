
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
        type:Date,
        required:true
    },
    eventTime:{
        type:String,
        required:true
    },
    deadline:{
        type:Date,
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
    totalTeam:{
        type:Number,
        required:true
    },
    duration:{
        type:String,
        required:true
    },
    status:{
        type:String,
        enum:["upcoming",'ongoing','closed']
    },
    level:{
        type:String,
        required:true
    },
    link:{
        type:String,
        required:true
    },
    registered:{
        type:Number,
        default:1
    }

});

const Hackathon = mongoose.model("Hackathon",hackathonSchema);

export default Hackathon;