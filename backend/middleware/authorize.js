import jwt from 'jsonwebtoken';


export const authorizeRole = (...allowedRoles)=>{
    return (req,res,next)=>{
        if(!req.user){
            return res.status(401).json({msg:"Unauthenticated"});
        }
        if(!allowedRoles.includes(req.user.role)){
            return res.status(403).json({msg:"Forbidden"});
        }
        next();
    }
}