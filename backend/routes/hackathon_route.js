const express = require('express');
const Hackathon = require('../models/hackathon');
const hackathonRoute = express.Router();

hackathonRoute.post('/api/hackathon',async (req,res)=>{
    try {
        const data = req.body;
        const newHackathon = new Hackathon(data);
        const response = await newHackathon.save();
        console.log("Data Saved");
        res.status(200).json(response);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error!"});
    }
});


hackathonRoute.get('/api/hackathon',async(req,res)=>{
    try {
        const response = await Hackathon.find();
        console.log("Data Fetched");
        res.status(200).json(response);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});

module.exports = hackathonRoute;