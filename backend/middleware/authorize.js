import jwt from 'jsonwebtoken';


export const authorizeRole = (...allowedRoles)=>{
    return (req,res,next)=>{
        if(!req.user){
            console.log("user is not authenticated");

            return res.status(401).json({msg:"Unauthenticated"});
        }
        if(!allowedRoles.includes(req.user.role)){
            console.log("forbidden");
            return res.status(403).json({msg:"Forbidden"});
        }
        next();
    }
}