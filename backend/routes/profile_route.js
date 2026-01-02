const express = require('express');
const User = require('../models/user');
const profileRoute = express.Router();

profileRoute.put('/api/profile/:id',async(req,res)=>{
    try {
        const id = req.params.id;
        const data = req.body;
        const updateProfile = await User.findByIdAndUpdate(id,data,{new:true});
        console.log('Updated Successfully');
        res.status(200).json(updateProfile);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal server error"});
    }
});


module.exports = profileRoute;
