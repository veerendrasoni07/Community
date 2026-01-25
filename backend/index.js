import dotenv from 'dotenv';
dotenv.config();

import express from 'express';
import cors from 'cors';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';
import nodemailer from 'nodemailer';
import UserModel from './models/Users.js';
import db from './db.js';
import adminRoutes from './routes/admin.js';
import hackathonRoutes from './routes/hackathon_route.js';
import clubRoutes from './routes/club_route.js';
import authRoutes from './routes/auth.js';
import profileRoutes from './routes/profile_route.js';
import bannerRoutes from './routes/banner_route.js';
import {router} from './controller/clodinary.js';
import quizRouter from './routes/quiz_routes.js';
import pdfRoutes from './routes/pdf_routes.js';

const app = express();
const JWT_SECRET = process.env.JWT_SECRET;
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Admin routes
app.use(adminRoutes);
app.use(hackathonRoutes);
app.use(clubRoutes);
app.use(profileRoutes);
app.use(profileRoutes);
app.use(bannerRoutes);
app.use(authRoutes);
app.use(router);
app.use(pdfRoutes);
app.use(quizRouter);



// // Storying the OTP in memory for now
// const otpStore = {};

// // Email Transporter i am using is nodemailer
// const transporter = nodemailer.createTransport({
//     service: 'gmail',
//     auth: {
//         user: process.env.EMAIL_USER, 
//         pass: process.env.EMAIL_PASS  
//     },
//     debug: true, 
//     logger: true
// });

// // ** Check Availability **
// app.post('/check-availability', async (req, res) => {
//     const { email, username } = req.body;
//     try {
//         const existingEmail = email ? await UserModel.findOne({ email }) : null;
//         const existingUsername = username ? await UserModel.findOne({ username }) : null;

//         res.json({
//             email: existingEmail ? 'Email already exists' : null,
//             username: existingUsername ? 'Username already exists' : null
//         });
//     } catch (error) {
//         res.status(500).json({ error: 'Server error checking availability' });
//     }
// });

// // ** Sending the OTP **
// app.post('/send-otp', async (req, res) => {
//     const { email } = req.body;

//     if (!email) return res.status(400).json({ error: 'Email is required' });

//     try {
//         const otp = Math.floor(100000 + Math.random() * 900000);
//         otpStore[email] = otp;

//         console.log('Attempting to send email to:', email);
//         const mailOptions = {
//             from: process.env.EMAIL_USER,
//             to: email,
//             subject: 'Verify Your Email - CodingEra Community',
//             auth:{
//                 user:'veerendrasoni0555@gmail.com',
//                 pass:'zcyb nsgj fnoa gywg'
//             },
//             html: `
//                 <div style="background-color: #f6f6f6; padding: 20px; font-family: Arial, sans-serif;">
//                     <div style="max-width: 600px; margin: 0 auto; background-color: #ffffff; padding: 30px; border-radius: 10px; box-shadow: 0 3px 10px rgba(0,0,0,0.1);">
//                         <div style="text-align: center; margin-bottom: 30px;">
//                             <h1 style="color: #333; margin: 0;">Welcome to CodingEra Community!</h1>
//                         </div>
//                         <div style="color: #555; font-size: 16px; line-height: 1.5;">
//                             <p>Hello,</p>
//                             <p>Thank you for joining CodingEra Community! To complete your registration, please use the following verification code:</p>
//                             <div style="background-color: #f8f8f8; padding: 15px; text-align: center; margin: 20px 0; border-radius: 5px;">
//                                 <h2 style="color: #2c3e50; letter-spacing: 5px; margin: 0;">${otp}</h2>
//                             </div>
//                             <p style="color: #777; font-size: 14px;">This verification code is valid for 5 minutes only. For security reasons, please do not share this code with anyone.</p>
//                             <p style="margin-top: 30px;">Welcome aboard! We're excited to have you join our community of developers and tech enthusiasts.</p>
//                             <div style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #eee; text-align: center; color: #888; font-size: 14px;">
//                                 <p>© 2024 CodingEra Community. All rights reserved.</p>
//                             </div>
//                         </div>
//                     </div>
//                 </div>
//             `
//         };
        
//         const info = await transporter.sendMail(mailOptions);
//         console.log('Email sent successfully:', info.response);

//         console.log(`OTP sent to ${email}: ${otp}`);
//         res.json({ message: 'OTP sent successfully' });

//         setTimeout(() => delete otpStore[email], 5 * 60 * 1000);

//     } catch (error) {
//         console.error('OTP Sending Error:', error);
//         res.status(500).json({ error: 'Failed to send OTP' });
//     }
// });


// // ** Verify OTP **
// app.post('/verify-otp', (req, res) => {
//     const { email, otp } = req.body;

//     if (!email || !otp) return res.status(400).json({ error: 'Email and OTP are required' });

//     if (otpStore[email] && otpStore[email] === Number(otp)) {
//         delete otpStore[email];
//         res.json({ success: true, message: 'OTP Verified' });
//     } else {
//         res.status(400).json({ error: 'Invalid or expired OTP' });
//     }
// });

// // ** Login User **
// app.post('/login', async (req, res) => {
//     try {
//         const { email, password } = req.body;
//         if (!email || !password) {
//             return res.status(400).json({ error: 'Email and password are required' });
//         }

//         const user = await UserModel.findOne({ email });
//         if (!user) {
//             return res.status(401).json({ error: 'Invalid email or password' });
//         }

//         const isValidPassword = await bcrypt.compare(password, user.password);
//         if (!isValidPassword) {
//             return res.status(401).json({ error: 'Invalid email or password' });
//         }

//         const token = jwt.sign({ userId: user._id }, JWT_SECRET, { expiresIn: '24h' });
//         res.json({
//             token,
//             userId: user._id,
//             username: user.username,
//             veri: user.isVerified ? 'verified' : 'unverified',
//             roleAdmin: user.roleAdmin? true : false,
//         });
//     } catch (error) {
//         console.error('Login error:', error);
//         res.status(500).json({ error: 'Internal server error' });
//     }
// });

// // ** Register User **
// app.post('/register', async (req, res) => {
//     try {
//         const { name, username, email, password, collegeName, location } = req.body;
//         if (!name || !username || !email || !password || !collegeName || !location) {
//             return res.status(400).json({ error: 'All fields are required' });
//         }

//         const existingEmail = await UserModel.findOne({ email });
//         const existingUsername = await UserModel.findOne({ username });

//         if (existingEmail) return res.status(409).json({ error: 'Email already exists' });
//         if (existingUsername) return res.status(409).json({ error: 'Username already exists' });

//         const hashedPassword = await bcrypt.hash(password, 10);
//         const user = await UserModel.create({
//             name,
//             username,
//             email,
//             password: hashedPassword,
//             collegeName,
//             location,
//             role: 'User'
//         });

//         const token = jwt.sign({ userId: user._id }, JWT_SECRET, { expiresIn: '24h' });

//         console.log('User created successfully:', user);
//         res.status(201).json({ message: 'User registered successfully', token });

//     } catch (error) {
//         console.error('Registration error:', error);
//         res.status(500).json({ error: 'Internal server error' });
//     }
// });
// // ** Send Reset OTP **
// app.post('/send-reset-otp', async (req, res) => {
//     const { email } = req.body;

//     if (!email) return res.status(400).json({ error: 'Email is required' });

//     try {
//         const user = await UserModel.findOne({ email });
//         if (!user) {
//             return res.status(404).json({ error: 'No account found with this email' });
//         }

//         const otp = Math.floor(100000 + Math.random() * 900000);
//         otpStore[email] = otp;

//         const mailOptions = {
//             from: process.env.EMAIL_USER,
//             to: email,
//             subject: 'Password Reset OTP - CodingEra Community',
//             html: `
//                 <div style="background-color: #f6f6f6; padding: 20px; font-family: Arial, sans-serif;">
//                     <div style="max-width: 600px; margin: 0 auto; background-color: #ffffff; padding: 30px; border-radius: 10px; box-shadow: 0 3px 10px rgba(0,0,0,0.1);">
//                         <div style="text-align: center; margin-bottom: 30px;">
//                             <h1 style="color: #333; margin: 0;">Password Reset Request</h1>
//                             <p style="color: #666; margin-top: 10px;">CodingEra Community</p>
//                         </div>
//                         <div style="color: #555; font-size: 16px; line-height: 1.5;">
//                             <p>Hello,</p>
//                             <p>We received a request to reset your password for your CodingEra Community account. Your security is important to us, and we want to ensure that only you have access to your account.</p>
//                             <div style="background-color: #f8f8f8; padding: 20px; text-align: center; margin: 25px 0; border-radius: 8px; border: 1px dashed #ccc;">
//                                 <p style="margin: 0 0 10px; color: #666;">Your Password Reset Code:</p>
//                                 <h2 style="color: #2c3e50; letter-spacing: 8px; margin: 0; font-size: 32px;">${otp}</h2>
//                             </div>
//                             <div style="background-color: #fff8dc; padding: 15px; border-radius: 5px; margin: 20px 0;">
//                                 <p style="margin: 0; color: #666;">⚠️ Important Security Notes:</p>
//                                 <ul style="margin: 10px 0 0; padding-left: 20px; color: #666;">
//                                     <li>This code will expire in 5 minutes</li>
//                                     <li>Never share this code with anyone</li>
//                                     <li>Our team will never ask for this code</li>
//                                 </ul>
//                             </div>
//                             <p>If you didn't request this password reset, please ignore this email or contact our support team immediately at <a href="mailto:support@codingera.com" style="color: #007bff; text-decoration: none;">support@codingera.com</a></p>
//                             <div style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #eee;">
//                                 <p style="color: #888; font-size: 14px; text-align: center; margin: 0;">Stay connected with the CodingEra Community</p>
//                                 <div style="text-align: center; margin-top: 15px;">
//                                     <a href="#" style="color: #007bff; text-decoration: none; margin: 0 10px;">Website</a>
//                                     <a href="#" style="color: #007bff; text-decoration: none; margin: 0 10px;">Twitter</a>
//                                     <a href="#" style="color: #007bff; text-decoration: none; margin: 0 10px;">GitHub</a>
//                                 </div>
//                                 <p style="color: #888; font-size: 12px; text-align: center; margin-top: 20px;">© 2024 CodingEra Community. All rights reserved.</p>
//                             </div>
//                         </div>
//                     </div>
//                 </div>
//             `
//         };
        
//         await transporter.sendMail(mailOptions);
//         res.json({ message: 'Password reset OTP sent successfully' });

//         setTimeout(() => delete otpStore[email], 5 * 60 * 1000);

//     } catch (error) {
//         console.error('Reset OTP Sending Error:', error);
//         res.status(500).json({ error: 'Failed to send reset OTP' });
//     }
// });

// ** Reset Password **
app.post('/reset-password', async (req, res) => {
    const { email, otp, newPassword } = req.body;

    if (!email || !otp || !newPassword) {
        return res.status(400).json({ error: 'Email, OTP, and new password are required' });
    }

    try {
        if (!otpStore[email] || otpStore[email] !== Number(otp)) {
            return res.status(400).json({ error: 'Invalid or expired OTP' });
        }

        const user = await UserModel.findOne({ email });
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        const hashedPassword = await bcrypt.hash(newPassword, 10);
        await UserModel.updateOne({ email }, { password: hashedPassword });

        delete otpStore[email];
        res.json({ message: 'Password reset successful' });

    } catch (error) {
        console.error('Password Reset Error:', error);
        res.status(500).json({ error: 'Failed to reset password' });
    }
});

// ** Server **
app.listen(3001,"0.0.0.0", () => {
    console.log('Server is running on port 3001');
});


// ** Close the MongoDB connection when the app is terminated **