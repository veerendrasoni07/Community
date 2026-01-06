import Banner from '../models/banner.js';
import express from 'express';

const bannerRouter = express.Router();


bannerRouter.post('/api/banner',async (req,res)=>{
    try {
        const {image} = req.body;
        const newBanner = new Banner({image});
        const response = await newBanner.save();
        res.status(200).json(response);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal server error!"});
    }
});

bannerRouter.get('/api/banner',async(req,res)=>{
    try {
        const response = await Banner.find();
        res.status(200).json(response);   
    } 
    catch (error) {
        res.status(500).json({error:"Internal server error!"});
    }
})

export default bannerRouter;