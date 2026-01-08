import jwt from 'jsonwebtoken';
import Users from '../models/Users.js';

export const auth = (req,res,next)=>{
    try{
        const token = req.header('x-auth-token');
        if(!token){
            res.status(401).json({error:"Authentication Failed!"});
        }
        const verified = jwt.verify(token,process.env.ACCESS_TOKEN_SECRET_KET);
        if(!verified){
            res.status(401).json({error:"Authentication Failed!"});
        }
        req.user = verified.id;
        req.token = token;
        next();
    }catch(error){
        res.status(401).json({error:"Authentication Failed!"});
    }
}