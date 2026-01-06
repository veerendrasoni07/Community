import express from 'express';
import Club from '../models/club.js';

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
        const response = await find();
        res.status(200).json(response);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});


export default clubRouter;