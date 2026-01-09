import express from 'express';
import Hackathon from '../models/hackathon.js';
import {authorizeRole} from '../middleware/authorize.js';
import {auth} from '../middleware/auth.js'
const hackathonRoute = express.Router();

hackathonRoute.post('/api/upload-hackathon',auth,authorizeRole("admin"),async (req,res)=>{
    try {
        console.log("route hitteddddddddddddd");
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


hackathonRoute.delete('/api/hackathon-delete',async(req,res)=>{
    try {
        const {hackathonId} = req.body;
        await Hackathon.findByIdAndDelete(hackathonId);
        res.status(200).json({msg:"Deleted Successfully"});
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});


hackathonRoute.put('/api/hackathon-update',async(req,res)=>{
    try {
        const {hackathonId,data} = req.body;
        const update = await Hackathon.findByIdAndUpdate(
            hackathonId,
            {$addToSet:data},
            {new:true}
        );
        return res.status(200).json(update);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});

export default hackathonRoute;