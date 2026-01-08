import jwt from 'jsonwebtoken'
import crypto from 'crypto';

export const hashToken = (token)=>{
    return crypto.createHash(
        "sha256",
    ).update(token).digest("hex");
}

export const generateRefreshToken =   (userId,role)=>{
    return jwt.sign(
        {
            id:userId,
            role:role
        },
        process.env.REFRESH_TOKEN_SECRET_KET,
        {expiresIn:'7d'}
    );
}

export const generateAccessToken = (userId,role)=>{
    console.log("access token has been generated");
    return jwt.sign(
        {id:userId,role:role},
        process.env.ACCESS_TOKEN_SECRET_KET,
        {expiresIn:'1h'}
    );
}