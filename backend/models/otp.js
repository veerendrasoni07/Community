import mongoose from 'mongoose';

const otpSchema = new mongoose.Schema({
    otp:{
        type:Number,
        required:true
    },
    email:{
        type:String,
        required:true
    },
    expiresAt:{
        type:Date,
        required:true
    }
});

const Otp = mongoose.model('Otp',otpSchema);
export default Otp;