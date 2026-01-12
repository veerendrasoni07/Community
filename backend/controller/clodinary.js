import cloudinary from 'cloudinary';
import { CloudinaryStorage } from 'multer-storage-cloudinary';
import dotenv from 'dotenv';
import express from 'express';
import {auth} from '../middleware/auth.js';

dotenv.config();

cloudinary.v2.config({
    cloud_name:process.env.CLOUD_NAME,
    api_key:process.env.CLOUD_API_KEY,
    api_secret:process.env.CLOUD_API_SECRET
});


const storage = new CloudinaryStorage({
    cloudinary:cloudinary,
    params:{
        folder:"coding-era-notes",
        resource_type:"raw",
        public_id: (req, file) => {
            return `${Date.now()}-${file.originalname}`;
        },
    },
});

const router = express.Router();   
router.post('/api/cloudinary/sign',auth,async(req,res)=>{
    try {
        const userId = req.user.id;
        const {type} = req.body;
    const folder = `${type}/${userId}`;
    const timestamp = Math.floor(Date.now()/1000);
    const paramsToSign = {
        folder,
        timestamp
    }
    const signature = cloudinary.v2.utils.api_sign_request(paramsToSign,process.env.CLOUD_API_SECRET);
    res.status(200).json({
            cloudName:process.env.CLOUD_NAME,
            apiKey:process.env.CLOUD_API_KEY,
            timestamp,
            signature,
            folder,
            uploadPreset:null,
            uploadUrl : `https://api.cloudinary.com/v1_1/${process.env.CLOUD_NAME}/auto/upload`,
    });

    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Cloudinary Error "});
    }
});

export {router,storage};