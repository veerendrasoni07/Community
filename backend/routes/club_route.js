const express = require('express');
const Club = require('../models/club');

const clubRouter = express.Router();


clubRouter.post('/api/club',async(req,res)=>{
    try {
        const data = req.body;
        const newClub = new Club(data);
        const response = newClub.save();
        console.log("Data Saved!");
        res.status(200).json(response);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});


clubRouter.get('/api/club',async(req,res)=>{
    try {
        const response = await Club.find();
        res.status(200).json(response);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});


module.exports = clubRouter;