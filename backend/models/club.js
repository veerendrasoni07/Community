const mongoose = require('mongoose');

const clubSchema = new mongoose.Schema({
    image:{
        type:String,
        required:false
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
        required:true
    },
    clubManager:{
        type:String,
        required:true
    },
    detailDes:{
        type:String,
        required:true
    },
    clubRule:{
        type:String,
        required:true
    },
    clubActivities:{
        type:String,
        required:true
    },
    joinLink:{
        type:String,
        required:false
    }

});

const Club = mongoose.model('Club',clubSchema);
module.exports = Club;