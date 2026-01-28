import mongoose from 'mongoose';

const bannerSchema = new mongoose.Schema({
    image:{
        url:String,
        public_id:String
    },
})

const Banner = mongoose.model('Banner',bannerSchema);
export default Banner;