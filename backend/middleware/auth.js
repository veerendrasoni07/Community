import jwt from 'jsonwebtoken';
import Users from '../models/Users.js';

export const auth = (req,res,next)=>{
    try{
        const token = req.header('x-auth-token');
        if(!token){
            return res.status(401).json({error:"Authentication Failed!"});
        }
        const verified = jwt.verify(token,process.env.ACCESS_TOKEN_SECRET_KEY);
        if(!verified){
            return res.status(401).json({error:"Authentication Failed!"});
        }
        req.user = verified;
        req.token = token;
        next();
    }catch(error){
        res.status(401).json({error:"Authentication Failed!"});
    }
}
