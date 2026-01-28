import mongoose from 'mongoose';

const clubSchema = new mongoose.Schema({
    image:{
        imageUrl:String,
        image_public_id:String
    },
    clubname:{
        type:String,
        required:true
    },
    techname:{
        type:String,
        required:true
    },
    desc:{
        type:String,
        required:true
    },
    clubLeader:{
        type:String,
        ref:'User',
        required:true
    },
    clubManager:{
        type:String,
        ref:'User',
        required:true
    },
    detailDesc:{
        type:String,
        required:true
    },
    clubRule:{
        type:[String],
        required:true
    },
    clubActivities:{
        type:[String],
        required:true
    },
    form:{
        formUrl:String,
        form_public_id:String
    }

});

const Club = mongoose.model('Club',clubSchema);

export default Club;