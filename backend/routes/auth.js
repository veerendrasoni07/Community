// Two token method --> 
import User from '../models/Users.js';
import { generateRefreshToken,generateAccessToken,hashToken} from '../tokens/token.js';
import RefreshToken from '../models/refresh_token.js';
import bcrypt from 'bcrypt';
import express from 'express';
import Otp from '../models/otp.js';
import jsonwebtoken from 'jsonwebtoken';
import { randomInt } from 'crypto';
import { createTransport } from 'nodemailer';
import { auth } from '../middleware/auth.js';
const authRouter = express.Router();

authRouter.post('/api/sign-up',async(req,res)=>{
    try {
        const {fullname,email,password,gender,username} = req.body;
        console.log(email);
        console.log(password);
        console.log(fullname);
        console.log(gender);
        console.log(username);
        if(!fullname || !email || !password){
            return res.status(400).json({msg:"Name or Email Or Password is missing!"});
        }
        const isUserExist = await User.findOne({email});
        if(isUserExist){
            return res.status(400).json({msg:"User already exist with this email"});
        }
        const hashedPassword = await bcrypt.hash(password,10); 
        let newUser = new User(
            {
                fullname,
                email,
                gender,
                username,
                password:hashedPassword
            }
        );
        newUser = await newUser.save();
        const refreshToken = generateRefreshToken(newUser._id,"user");
        const accessToken = generateAccessToken(newUser._id,"user");
        const hash = hashToken(refreshToken);
        await RefreshToken.create({
            userId:newUser._id,
            refreshToken:hash,
            expiresAt : Date.now()+ 7*24*60*60*1000
        });
        console.log("sign up successfully");
        // TODO : REMOVE PASSWORD FROM THE USER OBJECT
        res.status(200).json({user:newUser,refreshToken,accessToken});

    } catch (error) {
        console.log(error);
        res.json({error:"Internal Server Error"});
    }
});

authRouter.post('/api/sign-in',async(req,res)=>{
    try {
        const {email,password} = req.body;
        
        if(!email || !password){
            return res.status(400).json({msg:"email or password is missing"});
        }
        const user = await User.findOne({email});
        if(!user){
            return res.status(400).json({msg:"User with this email didn't exist"});
        }
        const verified = await bcrypt.compare(password,user.password);
        if(!verified){
            return res.status(401).json({msg:"Password is invalid"});
        }
        const refreshToken = generateRefreshToken(user._id,user.role);
        const accessToken = generateAccessToken(user._id,user.role);
        const hash = hashToken(refreshToken);
        await RefreshToken.create({
            userId:user._id,
            refreshToken:hash,
            expiresAt : Date.now()+ 7*24*60*60*1000
        });

        res.status(200).json({user:user._doc,refreshToken,accessToken});

    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"})
    }
});



// refresh the token 

authRouter.post('/api/refresh-token',async(req,res)=>{
    try {
        const {refreshToken} = req.body;
        const hash = hashToken(refreshToken);
        const stored = await RefreshToken.findOne({refreshToken:hash});
        if(!stored){
            return res.status(401).json({msg:"Invaild token or token expired"});
        }

        if(stored.revoked){
            await RefreshToken.updateMany(
                {userId:stored.userId},
                {revoked:true}
            );
            return res.status(401).json({msg:"Somethings suspecious noticed, Session Expired Login Again!"})
        }

        const verify = jsonwebtoken.verify(refreshToken,process.env.REFRESH_TOKEN_SECRET_KEY);
        if(!verify){
            return res.status(401).json({msg:"Refresh Token verification failed"});
        }
        const newRefreshToken = generateRefreshToken(verify.id,verify.role);
        const newHashRefreshToken = hashToken(newRefreshToken);
        // token rotation
        stored.replacedByToken = newHashRefreshToken;
        stored.revoked = true;
        await stored.save();
        await RefreshToken.create({
            refreshToken:newHashRefreshToken,
            userId:verify.id,
            expiresAt:Date.now() + 7*24*60*60*1000
        });
        const newAccessToken = generateAccessToken(verify.id,verify.role);

        console.log("---------------------------access token is issued---------------------------------------");
        res.status(200).json({accessToken:newAccessToken,refreshToken:newRefreshToken});

    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});





authRouter.post('/api/get-otp',async(req,res)=>{
    try {
        const {email} = req.body;

        if(!email) return res.status(400).json({msg:"email is missing"});

        

        const user = await User.findOne({email});

        if(!user) return res.status(400).json({msg:"User with this email doesn't exist"});
        const otp = randomInt(100000,999999);
        await Otp.create({
            email,
            otp,
            expiresAt: Date.now() + 5 *60*1000
        });

        const transport = createTransport(
            {
                // service:'gmail',
                // auth:{
                //     user: process.env.EMAIL,
                //     pass: process.env.EMAIL_PASS
                // },
                service : 'gmail',
                port: 587,
                auth: {
                    user: process.env.EMAIL,
                    pass: process.env.EMAIL_PASS
                }
            }
        );


        await transport.sendMail({
            from:"CODING ERA",
            to:email,
            subject: 'Verify Your Email - CodingEra Community',
            text:`Otp is ${otp}, It will expire within 5 minutes`,
            html:  `
                <div style="background-color: #f6f6f6; padding: 20px; font-family: Arial, sans-serif;">
                    <div style="max-width: 600px; margin: 0 auto; background-color: #ffffff; padding: 30px; border-radius: 10px; box-shadow: 0 3px 10px rgba(0,0,0,0.1);">
                        <div style="text-align: center; margin-bottom: 30px;">
                            <h1 style="color: #333; margin: 0;">Password Reset Request</h1>
                            <p style="color: #666; margin-top: 10px;">CodingEra Community</p>
                        </div>
                        <div style="color: #555; font-size: 16px; line-height: 1.5;">
                            <p>Hello,</p>
                            <p>We received a request to reset your password for your CodingEra Community account. Your security is important to us, and we want to ensure that only you have access to your account.</p>
                            <div style="background-color: #f8f8f8; padding: 20px; text-align: center; margin: 25px 0; border-radius: 8px; border: 1px dashed #ccc;">
                                <p style="margin: 0 0 10px; color: #666;">Your Password Reset Code:</p>
                                <h2 style="color: #2c3e50; letter-spacing: 8px; margin: 0; font-size: 32px;">${otp}</h2>
                            </div>
                            <div style="background-color: #fff8dc; padding: 15px; border-radius: 5px; margin: 20px 0;">
                                <p style="margin: 0; color: #666;">⚠️ Important Security Notes:</p>
                                <ul style="margin: 10px 0 0; padding-left: 20px; color: #666;">
                                    <li>This code will expire in 5 minutes</li>
                                    <li>Never share this code with anyone</li>
                                    <li>Our team will never ask for this code</li>
                                </ul>
                            </div>
                            <p>If you didn't request this password reset, please ignore this email or contact our support team immediately at <a href="mailto:support@codingera.com" style="color: #007bff; text-decoration: none;">support@codingera.com</a></p>
                            <div style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #eee;">
                                <p style="color: #888; font-size: 14px; text-align: center; margin: 0;">Stay connected with the CodingEra Community</p>
                                <div style="text-align: center; margin-top: 15px;">
                                    <a href="#" style="color: #007bff; text-decoration: none; margin: 0 10px;">Website</a>
                                    <a href="#" style="color: #007bff; text-decoration: none; margin: 0 10px;">Twitter</a>
                                    <a href="#" style="color: #007bff; text-decoration: none; margin: 0 10px;">GitHub</a>
                                </div>
                                <p style="color: #888; font-size: 12px; text-align: center; margin-top: 20px;">© 2024 CodingEra Community. All rights reserved.</p>
                            </div>
                        </div>
                    </div>
                </div>
            `
        });

        res.status(200).json({success:true,msg:'Otp is send'});

    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});

// verify the otp

authRouter.post('/api/verify-otp',async(req,res)=>{
    try {
        const {email,otp} = req.body;
        if(!email || !otp){
            return res.status(400).json({msg:"email or otp is missing"});
        }
        const user = await User.findOne({email});
        if(!user) return res.status(401).json({msg:"User doesn't exist"});
        const otpExist = await Otp.findOne({otp}).sort({createdAt:-1});
        if(!otpExist) return res.status(400).json({success:false,msg:"Otp Not Found"});
        if(otp !== otpExist.otp) return res.status(400).json({success:false,msg:"Invalid Otp"});
        if(Date.now()>otpExist.expiresAt) return res.status(401).json({success:false,msg:"Otp expired"});
        await Otp.deleteMany({email});
        res.status(200).json({success:true});
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});   
    }
});

authRouter.post('/api/reset-password',async(req,res)=>{
    try {
        const {email,password} = req.body;
        if(!email || !password){
            return res.status(400).json({msg:"email or password is missing"});
        }
        const user = await User.findOne({email});
        if(!user) return res.status(401).json({msg:"User doesn't exist"});
        const hashedPassword = await bcrypt.hash(password,10);
        user.password = hashedPassword;
        await user.save();
        console.log("password reset successfully");
        res.status(200).json({msg:"password reset successfully"});
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});


authRouter.put('/api/update-profile',auth,async (req,res)=>{
    try {
        const {details} = req.body; 
        const userId = req.user.id;
        const exist = await User.findById(userId);
        if(!exist) return res.status(401).json({msg:"User doesn't exist"});
        const updated = await User.findByIdAndUpdate(
            userId,
            {
                $set:details
            },
            {new:true}
        );
        console.log("profile updated");
        res.status(200).json({"user":updated});
    } catch (error) {
        console.log(error);
        res.status(500).json({msg:"Internal Server Error"});
    }
});

export default authRouter;

